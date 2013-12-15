Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:11803 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3LOLa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 06:30:28 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXU003IMIMRZF60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 15 Dec 2013 06:30:27 -0500 (EST)
Date: Sun, 15 Dec 2013 09:30:22 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/7] V4L2 SDR API
Message-id: <20131215093022.5e6e8d37.m.chehab@samsung.com>
In-reply-to: <52AC99C1.4050108@iki.fi>
References: <1387037729-1977-1-git-send-email-crope@iki.fi>
 <52AC8B20.906@iki.fi> <52AC8FD6.2080504@xs4all.nl> <52AC99C1.4050108@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Dec 2013 19:47:45 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 14.12.2013 19:05, Hans Verkuil wrote:
> > On 12/14/2013 05:45 PM, Antti Palosaari wrote:
> >> Hello
> >> One possible problem I noticed is device node name.
> >>
> >> Documentation/devices.txt
> >>
> >>    65 block	SCSI disk devices (16-31)
> >> 		  0 = /dev/sdq		17th SCSI disk whole disk
> >> 		 16 = /dev/sdr		18th SCSI disk whole disk
> >> 		 32 = /dev/sds		19th SCSI disk whole disk
> >> 		    ...
> >> 		240 = /dev/sdaf		32nd SCSI disk whole disk
> >>
> >> 		Partitions are handled in the same way as for IDE
> >> 		disks (see major number 3) except that the limit on
> >> 		partitions is 15.
> >>
> >>
> >>    81 char	video4linux
> >> 		  0 = /dev/video0	Video capture/overlay device
> >> 		    ...
> >> 		 63 = /dev/video63	Video capture/overlay device
> >> 		 64 = /dev/radio0	Radio device
> >> 		    ...
> >> 		127 = /dev/radio63	Radio device
> >> 		224 = /dev/vbi0		Vertical blank interrupt
> >> 		    ...
> >> 		255 = /dev/vbi31	Vertical blank interrupt
> >>
> >>
> >> What I understand, /dev/sdr is not suitable node name as it conflicts
> >> with existing node name.
> >
> > Good catch, that won't work :-)
> >
> >> Any ideas?
> >
> > /dev/sdradio?
> 
> /dev/swradio?
> 
> 
> Lets do a small poll here. Everyone, but me, has a one vote ;)

I vote for swradio.

The patches look ok to me, provided that you add the proper DocBook
bits on each of them.

I didn't like much that now have 3 ways to describe frequencies.
I think we should latter think on moving the frequency conversion to
the core, and use u64 with 1Hz step at the internal API, converting all
the drivers to use it.

IMHO, we should also provide a backward-compatible way that would allow
userspace to choose to use u64 1-Hz-stepping frequencies.

Of course the changes at the drivers is out of the scope, but perhaps
we should not apply patch 4/7, replacing it, instead, by some patch that
would move the frequency size to u64.

> 
> regards
> Antti


-- 

Cheers,
Mauro
