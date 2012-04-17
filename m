Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:48645 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DQGh4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 02:37:56 -0400
To: Pieter De Wit <pieter@insync.za.net>
Subject: Re: v4l2 Device with H264 support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 17 Apr 2012 08:37:41 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <linux-media@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net>
References: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net>
Message-ID: <a5a29db4793a36095a2f8746361f6b63@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello,



On Tue, 17 Apr 2012 12:02:25 +1200 (NZST), Pieter De Wit

<pieter@insync.za.net> wrote:

> I would like to stream H264 from a v4l2 device that does hardware 

> encoding. ffmpeg and all of those doesn't seem to understand H264, but 

> v4l2 "does". If I run qv4l2, it shows that H264 is in the encoding list 

> and I can preview that. Using v4l2-ctl, I can set the pixel format to

H264 

> and the "get-fmt" reports it correctly.

> 

> Is there any way I can get a "raw" frame dump from the v4l2 device ? I 

> have used "all" the samples I can find and none seems to work.



If the device supports read(/write) mode, I suppose you could simply read

the device node as a file.



'vlc v4l2c:///dev/video0 --demux h264' might work "thanks" to a software

bug whereby the format is not reset, but I have not tried. V4L2 H.264 is

supported in VLC version 2.0.2-git: 'vlc v4l2:///dev/video0:chroma=h264'.



-- 

Rémi Denis-Courmont

Sent from my collocated server
