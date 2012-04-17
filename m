Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.insync.za.net ([103.247.152.98]:59355 "EHLO
	mail.insync.za.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2DQUau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 16:30:50 -0400
Date: Wed, 18 Apr 2012 08:30:43 +1200 (NZST)
From: Pieter De Wit <pieter@insync.za.net>
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
cc: linux-media@vger.kernel.org
Subject: Re: v4l2 Device with H264 support
In-Reply-To: <a5a29db4793a36095a2f8746361f6b63@chewa.net>
Message-ID: <alpine.DEB.2.02.1204180828510.3685@eragon.insync.za.net>
References: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net> <a5a29db4793a36095a2f8746361f6b63@chewa.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1226411375-1334694645=:3685"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1226411375-1334694645=:3685
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 17 Apr 2012, Rémi Denis-Courmont wrote:

>   Hello,
>
> On Tue, 17 Apr 2012 12:02:25 +1200 (NZST), Pieter De Wit
> <pieter@insync.za.net> wrote:
>> I would like to stream H264 from a v4l2 device that does hardware
>> encoding. ffmpeg and all of those doesn't seem to understand H264, but
>> v4l2 "does". If I run qv4l2, it shows that H264 is in the encoding list
>> and I can preview that. Using v4l2-ctl, I can set the pixel format to
> H264
>> and the "get-fmt" reports it correctly.
>>
>> Is there any way I can get a "raw" frame dump from the v4l2 device ? I
>> have used "all" the samples I can find and none seems to work.
>
> If the device supports read(/write) mode, I suppose you could simply read
> the device node as a file.
>
> 'vlc v4l2c:///dev/video0 --demux h264' might work "thanks" to a software
> bug whereby the format is not reset, but I have not tried. V4L2 H.264 is
> supported in VLC version 2.0.2-git: 'vlc v4l2:///dev/video0:chroma=h264'.
>
> -- 
> Rémi Denis-Courmont
> Sent from my collocated server
>

Hi,

Thanks for the reply. I suspect that there is some tricks needed to get 
the h264 stream from this device, into something of a player. Can some 
please point me to some code where the v4l2 device is read and the result 
is dumped to stdout ? I will then modify that code :) and submit patches 
if needed etc.

Cheers,

Pieter
--8323329-1226411375-1334694645=:3685--
