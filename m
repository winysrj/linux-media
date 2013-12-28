Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52893 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab3L1SNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 13:13:52 -0500
Message-ID: <1388254550.2129.83.camel@palomino.walls.org>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Andy Walls <awalls@md.metrocast.net>
To: Andy <dssnosher@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Sat, 28 Dec 2013 13:15:50 -0500
In-Reply-To: <CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	 <CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	 <CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2013-12-27 at 00:37 -0500, Andy wrote:
> I am trying to capture input from /dev/video0 which is Hauppauge Win
> 150 MCE PCI card but I get the following error which has no record on
> google
> 
> [video4linux2,v4l2 @ 0xb080d60] The device does not support the
> streaming I/O method.
> /dev/video0: Function not implemented

The ivtv driver does not support the V4L2 Streaming I/O ioctl()'s for
transferring video data buffers.  It only supports the read()/write()
calls.

I'm not sure about ffmpeg, but mplayer is happy to read() the mpeg
stream from standard input or the device node:

# cat /dev/video0 | mplayer
or
# mplayer /dev/video0 

Regards,
Andy

> Here is the ffmpeg command
> ffmpeg -y -f:v video4linux2 -i /dev/video0 -f:a alsa -ac 1 -i hw:1,0
> -threads 2 -override_ffserver -flags +global_header -vcodec libx264 -s
> 320x240 -preset superfast -r 7.5 -acodec aac -ar 44100
> ipgoeshere:port/dvbstest.ffm
> 
> Disregard the DVB syntax, not relevant
> 
> Any idea what is causing the error?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


