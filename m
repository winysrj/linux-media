Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44923 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab2CTXWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 19:22:22 -0400
Subject: Re: 320cx analog part
From: Andy Walls <awalls@md.metrocast.net>
To: volokh <volokh@telros.ru>
Cc: linux-media@vger.kernel.org
Date: Tue, 20 Mar 2012 19:19:47 -0400
In-Reply-To: <1332259555.6182.65.camel@VPir>
References: <1332259555.6182.65.camel@VPir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1332285591.2525.10.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-03-20 at 20:05 +0400, volokh wrote:
> Hi, can somebody help me with developing analog driver part.
> I`m looking for any docs or code.
> 

CX25840/1/2/3 datasheet:
http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf

V4L2 framework for drivers to use:
http://git.linuxtv.org/media_tree.git/blob/HEAD:/Documentation/video4linux/v4l2-framework.txt

V4L2 kernel-userspace API:
http://linuxtv.org/downloads/v4l-dvb-apis/

Videobuf2 kernel internal subsystem (to help with implementing V4L2
API):
http://lwn.net/Articles/447435/

Note:
1. the CX2584x chip has a lot of features to program
2. the V4L2 API is large and has a lot of requirements to implement
3. If you only implement SECAM-D/K at first, think ahead on how to
support other TV standards later.

Regards,
Andy

> Now I starting up cx25840 through i2c bus, and control
> through /dev/video (call_all).
> 
> Now I intend to mmap capture through dib7000 usb device and I stoped
> here.
> 
> Thanks.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


