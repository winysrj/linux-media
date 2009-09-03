Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:64721 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbZICHDj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 03:03:39 -0400
Date: Thu, 3 Sep 2009 09:03:32 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Thomas Rokamp <thomas@rokamp.dk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with Hauppauge Nova-T USB2
In-Reply-To: <4A9EB417.5040409@rokamp.dk>
Message-ID: <alpine.LRH.1.10.0909030851490.3802@pub6.ifh.de>
References: <41138.1251890451@rokamp.dk> <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de> <4A9EB032.7000503@rokamp.dk> <alpine.LRH.1.10.0909021957400.3802@pub6.ifh.de> <4A9EB417.5040409@rokamp.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Sep 2009, Thomas Rokamp wrote:
>> wget http://phail.dk/test01.mpg
>> mplayer test01.mpg
>> 
>> and I see a nice star animation looks like Eurosport .
>> 
>>> http://phail.dk/test02.mpg
>> 
>> doing the same thing with this file:
>> 
>> It show Melzer vs. Safin playing Tennis at the US Open on Eurosport.
>> 
>> Something's wrong with your mplayer/vlc/libffmpeg or whatever, definitely 
>> not a problem of driver or reception.
>
> Yikes... well, thanks for that information. Been trying on two machines, 
> windows + linux, and no result.
> What player are you using? Any special codec?

mplayer and no special codec:

When I'm running mplayer it shows that:

TS file format detected.
VIDEO MPEG2(pid=513) AUDIO MPA(pid=644) NO SUBS (yet)!  PROGRAM N. 0
VIDEO:  MPEG2  704x576  (aspect 2)  25.000 fps  10000.0 kbps (1250.0 
kbyte/s)
==========================================================================
Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
VDec: vo config request - 704 x 576 (preferred colorspace: Mpeg PES)
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
The selected video_out device is incompatible with this codec.
Try adding the scale filter, e.g. -vf spp,scale instead of -vf spp.
VDecoder init failed :(
Opening video decoder: [libmpeg2] MPEG 1/2 Video decoder libmpeg2-v0.4.0b
Selected video codec: [mpeg12] vfm: libmpeg2 (MPEG-1 or 2 (libmpeg2))
==========================================================================
==========================================================================
Opening audio decoder: [mp3lib] MPEG layer-2, layer-3
AUDIO: 48000 Hz, 2 ch, s16le, 192.0 kbit/12.50% (ratio: 24000->192000)
Selected audio codec: [mp3] afm: mp3lib (mp3lib MPEG layer-2, layer-3)
==========================================================================

It looks quite standard to me.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
