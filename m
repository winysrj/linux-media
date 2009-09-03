Return-path: <linux-media-owner@vger.kernel.org>
Received: from em002a.cxnet.dk ([87.72.115.243]:34212 "EHLO em002a.cxnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbZICQpm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 12:45:42 -0400
Message-ID: <4A9FF2C4.5040604@rokamp.dk>
Date: Thu, 03 Sep 2009 18:45:56 +0200
From: Thomas Rokamp <thomas@rokamp.dk>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with Hauppauge Nova-T USB2
References: <41138.1251890451@rokamp.dk> <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de> <4A9EB032.7000503@rokamp.dk> <alpine.LRH.1.10.0909021957400.3802@pub6.ifh.de> <4A9EB417.5040409@rokamp.dk> <alpine.LRH.1.10.0909030851490.3802@pub6.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0909030851490.3802@pub6.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> mplayer and no special codec:
>
> When I'm running mplayer it shows that:
>
> TS file format detected.
> VIDEO MPEG2(pid=513) AUDIO MPA(pid=644) NO SUBS (yet)!  PROGRAM N. 0
> VIDEO:  MPEG2  704x576  (aspect 2)  25.000 fps  10000.0 kbps (1250.0 
> kbyte/s)
> ========================================================================== 
>
> Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
> VDec: vo config request - 704 x 576 (preferred colorspace: Mpeg PES)
> Could not find matching colorspace - retrying with -vf scale...
> Opening video filter: [scale]
> The selected video_out device is incompatible with this codec.
> Try adding the scale filter, e.g. -vf spp,scale instead of -vf spp.
> VDecoder init failed :(
> Opening video decoder: [libmpeg2] MPEG 1/2 Video decoder libmpeg2-v0.4.0b
> Selected video codec: [mpeg12] vfm: libmpeg2 (MPEG-1 or 2 (libmpeg2))
> ========================================================================== 
>
> ========================================================================== 
>
> Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
> AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
> Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
> ========================================================================== 
>
>
> It looks quite standard to me.
Thanks for helping me debugging this. Turned out that none of the 
players I had at the moment of testing was working (VLC / windows media 
player), so I concluded that the stream was broken.
Media Player Classic played it just fine.

Problem is solved and with MythTV now installed, even VLC will play the 
files, after they have been recorded through MythTV.


Thanks again, also for the other suggestions I have received.

Best regards,
Thomas Rokamp
