Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1634 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZCFMPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 07:15:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFCv2: Finalizing the RDS interface
Date: Fri, 6 Mar 2009 13:15:42 +0100
Cc: Michael Schimek <mschimek@gmx.at>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Hans J. Koch" <hjk@linutronix.de>, tobias.lorenz@gmx.net,
	belavenuto@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903061315.42256.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFCv2: Completing the V4L2 RDS API
================================

Introduction
------------

There are several drivers that implement RDS support: bttv (through 
saa6588), radio-si470x and radio-cadet. radio-tea5764 wants to support this 
in the future as well.

The saa6588 is used in different cards, but is currently only enabled in 
bttv. However, I have it working with a saa7134 as well.

I expect this to become more important with the increased use of linux and 
v4l2 in embedded devices. What is holding it back at the moment is the fact 
that this interface has not been defined properly. It's 90% there, but it 
is poorly documented and is still not officially part of V4L2.

This RFC is intended to fill in the final gaps and make it official.

The main changes in this second revision of this RFC are in the handling of 
the US RBDS format.

Current API
-----------

The V4L2 spec says this about the RDS Interface:

[start quote]
4.11. RDS Interface

The Radio Data System transmits supplementary information in binary format, 
for example the station name or travel information, on a inaudible audio 
subcarrier of a radio program. This interface aims at devices capable of 
receiving and decoding RDS information.

The V4L API defines its RDS API as follows.

>From radio devices supporting it, RDS data can be read with the read() 
function. The data is packed in groups of three, as follows:

First Octet: Least Significant Byte of RDS Block
Second Octet: Most Significant Byte of RDS Block
Third Octet:
	Bit 7: Error bit. Indicates that an uncorrectable error occurred
	       during reception of this block.
	Bit 6: Corrected bit. Indicates that an error was corrected for
	       this data block.
	Bits 5-3: Received Offset. Indicates the offset received by the
		  sync system.
	Bits 2-0: Offset Name. Indicates the offset applied to this data.

It was argued the RDS API should be extended before integration into V4L2, 
no new API has been devised yet. Please write to the linux-media mailing 
list for discussion: http://www.linuxtv.org/lists.php. Meanwhile no V4L2 
driver should set the V4L2_CAP_RDS_CAPTURE capability flag.
[end quote]

Problems with this API
----------------------

As I said before, it is 90% complete, there are just a few things missing:

1. Offset mapping
-----------------

The Offset Name refers to six possible offsets as defined by the RDS and 
RBDS standard (that is the US variant of RDS). Possible offsets are: A, B, 
C, C', D and E (RBDS specific).

The mapping of the values 0-7 to offsets is as follows:

0: block A
1: block B
2: block C
3: block D
4: block C'
5: block E (MMBS specific, see below)
6: invalid block E (RDS mode)
7: invalid block

This mapping comes from the saa6588 RDS decoder, but it makes sense and I 
see no reason to change this. As long as we document it and add the block 
defines to videodev2.h.

The difference between bits 5-3 and 2-0 is that 'Received Offset' refers to 
the offset received by the RDS decoder, while 'Offset Name' is what the RDS 
decoder thinks it should be. This difference only applies to devices that 
have high-level knowledge about the RDS standard and can use that to 
correct wrongly received offsets. The only driver I know that apparently 
can do this is the radio-cadet driver. All other drivers make bits 5-3 
equal to bits 2-0.

All applications that are known to me only use bits 2-0.

I propose that the spec is changed to mark bits 5-3 as deprecated and that 
applications should only look at bits 2-0.

I see no point in using bits 5-3 and making them deprecated might make it 
possible to reuse them in the future if needed.

2. RBDS/MMBS support
--------------------

RBDS is the US variant of RDS. There are very few differences between the 
two, the most important ones being:

- Different Program Information assignments
- Different Program Type assignments
- Support for MMBS (Modified Mobile Search)

The first two are irrelevant to an RDS decoder at this level, but the parser 
of the decoder's output will have to know whether it is receiving RDS or 
RBDS. However, there doesn't seem to be a specific marker that will tell 
you which of the two is being transmitted. The parser will probably have to 
look at the transmitted country code and use that to determine whether it 
needs to parse RDS or RBDS.

The third is for the time-multiplexed MMBS system that is in use in the US. 
It is really a separate protocol that can be interleaved within the RDS 
signal and uses the E blocks. The presence of E blocks indicates that RBDS 
is being used, but the reverse is not true since as I understand it not all 
RBDS transmissions use MMBS.

Not all decoders can handle MMBS, and those that do need to be told that it 
is a valid block.

I propose to use the v4l2_tuner struct for this. It is an obvious match 
since the ability to read RDS is tuner related (no tuner, no RDS :-) ).

The v4l2_tuner capability field needs two additional caps:

V4L2_TUNER_CAP_RDS
V4L2_TUNER_CAP_MMBS

And we can enable MMBS support by adding a flag to the audmode field:

V4L2_TUNER_MODE_FL_MMBS 	0x100

We should also add new subband flags V4L2_TUNER_SUB_RDS and 
V4L2_TUNER_SUB_MMBS so we can report if RDS and MMBS are present. Note that 
MMBS blocks always appear in multiples of 4, so that can be used internally 
to see whether these are bit errors or real MMBS E-blocks.

3. Signal strength
------------------

In my initial proposal I also added an rds_signal field to obtain the signal 
strength of the RDS signal. I've decided not to do so at this time. If 
there is interest in this, then it can be added later.

4. Add RDS device capability
----------------------------

Any driver that can do RDS/RBDS should also set the V4L2_CAP_RDS_CAPTURE 
capability.

5. Flushing of pending data
---------------------------

Changing frequencies or inputs should flush all pending RDS packets. This 
prevents RDS data from the previous frequency from being mixed in with the 
RDS data from the new frequency.

6. RDS encoder
--------------

The spec should make a note that anyone who wants to add RDS encoder support 
to v4l2 should contact the linux-media mailinglist to discuss this.

7. Raw RDS format
-----------------

There has been a discussion on what to do if a device can only output the 
raw RDS samples (similar to raw VBI for video). Should that be needed, then 
we have to add VIDIOC_G/S/TRY_FMT support for RDS. In that case, the 
default for an RDS-capable radio device will be this 'SLICED_RDS' format.



With these changes I think the RDS API is pretty complete and can become an 
official V4L2 API.

Comments?

	Hans Verkuil

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
