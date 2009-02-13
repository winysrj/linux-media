Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760906AbZBMVQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 16:16:23 -0500
Date: Fri, 13 Feb 2009 19:15:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	hjkoch@users.berlios.de, tobias.lorenz@gmx.net,
	belavenuto@gmail.com
Subject: Re: RFC: Finalizing the V4L2 RDS interface
Message-ID: <20090213191545.3d92e121@pedra.chehab.org>
In-Reply-To: <200902130955.19995.hverkuil@xs4all.nl>
References: <200902130955.19995.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009 09:55:19 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> RFC: Completing the V4L2 RDS API
> ================================
> 
> Introduction
> ------------
> 
> There are several drivers that implement RDS support: bttv (through 
> saa6588), radio-si470x and radio-cadet. radio-tea5764 wants to support this 
> in the future as well.
> 
> The saa6588 is used in different cards, but is currently only enabled in 
> bttv, but I have it working with a saa7134 as well.
> 
> I expect this to become more important with the increased use of linux and 
> v4l2 in embedded devices. What is holding it back at the moment is the fact 
> that this interface has not been defined properly. It's 90% there, but it 
> is poorly documented and is still not officially part of V4L2.
> 
> This RFC is intended to fill in the final gaps and make it official.
> 
> Current API
> -----------
> 
> The V4L2 spec says this about the RDS Interface:
> 
> 4.11. RDS Interface
> 
> The Radio Data System transmits supplementary information in binary format, 
> for example the station name or travel information, on a inaudible audio 
> subcarrier of a radio program. This interface aims at devices capable of 
> receiving and decoding RDS information.
> 
> The V4L API defines its RDS API as follows.
> 
> From radio devices supporting it, RDS data can be read with the read() 
> function. The data is packed in groups of three, as follows:
> 
> First Octet: Least Significant Byte of RDS Block
> Second Octet: Most Significant Byte of RDS Block
> Third Octet:
> 	Bit 7: Error bit. Indicates that an uncorrectable error occurred
> 	       during reception of this block.
> 	Bit 6: Corrected bit. Indicates that an error was corrected for
> 	       this data block.
> 	Bits 5-3: Received Offset. Indicates the offset received by the
> 		  sync system.
> 	Bits 2-0: Offset Name. Indicates the offset applied to this data.
> 
> It was argued the RDS API should be extended before integration into V4L2, 
> no new API has been devised yet. Please write to the linux-media mailing 
> list for discussion: http://www.linuxtv.org/lists.php. Meanwhile no V4L2 
> driver should set the V4L2_CAP_RDS_CAPTURE capability flag.
> 
> Problems with this API
> ----------------------
> 
> As I said before, it is 90% complete, there are just a few things missing. 
> The Offset Name refers to six possible offsets as defined by the RDS and 
> RBDS standard (that is the US variant of RDS). Possible offsets are: A, B, 
> C, C', D and E (RBDS specific).
> 
> The mapping of the values 0-7 to offsets is as follows:
> 
> 0: A
> 1: B
> 2: C
> 3: D
> 4: C'
> 5: E (RBDS specific)
> 6: invalid block E (RDS mode)
> 7: invalid block
> 
> This mapping comes from the saa6588 RDS decoder, but it makes sense and I 
> see no reason to change this. As long as we document it and add a public 
> RDS header with this information. The original mapping was from the 
> radio-cadet.c driver. Unfortunately, it was never documented and I cannot 
> find any details on what the mapping between number and offset code looks 
> like. Since the cadet is an ISA card I am not too worried about this and 
> I'm following the newer devices.
> 
> After a lot of googling I found this ancient radio-cadet posting: 
> http://lkml.indiana.edu/hypermail/linux/kernel/9904.0/0609.html
> 
> This finally explained what the difference between the Received Offset and 
> the Offset Name is:
> 
> "Bits 5-3: Received Offset. Indicates the block offset received by the 
> decoder hardware (used to determine the location of the block in a RDS 
> group).
> 
> Bits 2-0: Offset Name. Indicates the block offset applied by the decoder. 
> (In some cases, the hardware may try to second-guess the received values to 
> try to overcome poor reception conditions)."
> 
> Currently all other RDS implementations just make a copy of bits 2-0 and the 
> rdsd daemon (http://rdsd.berlios.de/) uses only bits 2-0.
> 
> I would like to change the definition of these bits, setting bits 5-3 to 0. 
> This way we have three bits available for future enhancements. I see no 
> advantage in having two offsets. Just pick the one the decoder gives you.

This would be an userspace API breakage. I can't see any gain on doing this.
Are you needing those bytes for some usage?


IMO, I would describe those bits at the API, marking it with a flag stating
that this its usage is deprecated, recommending to not use. Let's see if
someone will complain. We can keep this as-is until we need, but, in this case,
we need to properly document that it will be removed in some future.

> Another problem is that there is no good method of selecting RDS vs RBDS, or 
> checking which of these two (or both) are available.
> 
> I propose to use the v4l2_tuner struct for this. It is an obvious match 
> since the ability to read RDS is tuner related (no tuner, no RDS :-) ).
> 
> The v4l2_tuner capability field needs two additional caps:
> 
> V4L2_TUNER_CAP_RDS
> V4L2_TUNER_CAP_RBDS
> 
> And we can add support to select RDS/RDBS by using one of the reserved 
> fields:
> 
> __u8 	rds_type;
> __u8 	rds_signal;	/* RDS signal strength quality, 0-255 */
> __u8 	rds_reserved[2];
> __u32   reserved[3];
> 
> And rds_type is:
> 
> V4L2_TUNER_RDS_TYPE_RDS   0x00
> V4L2_TUNER_RDS_TYPE_RBDS  0x01
> 
> We can also add new subband flags V4L2_TUNER_SUB_RDS and V4L2_TUNER_SUB_RBSD 
> so we can report if RDS/RBDS is present.
> 
> I do not think there is any need to introduce an additional 
> V4L2_CAP_RDS_CAPTURE capability, since it is taken care of in v4l2_tuner.
> 
> Finally I would prefer to have the requirement that the driver will buffer 
> at least 10 seconds worth of data (comes to 1200 bytes). 

Why? IMO, this seems to be something that should be a requirement at user side,
not at kernel side: After changing from one station to another, and start
receiving RDS/RBDS, wait for some time before output the data.

> Or perhaps we should add a field that reports the maximum number of buffered packets? 
> E.g. __u16 rds_buf_size. This might be more generic and you can even allow 
> this to be set with VIDIOC_S_TUNER (although drivers can ignore it).

Why to spend 16 bits for it? It seems easier to check for for the amount of
received packets on userspace. I think we should avoid to waste those reserved bytes.

> With these small changes I think the RDS API is pretty complete and can 
> become an official V4L2 API.
> 
> Comments?
> 
> 	Hans Verkuil
> 




Cheers,
Mauro
