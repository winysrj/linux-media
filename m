Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45274 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaDFXfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Apr 2014 19:35:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Scheuermann, Mail" <Scheuermann@barco.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: AW: v4l2_buffer with PBO mapped memory
Date: Mon, 07 Apr 2014 01:37:28 +0200
Message-ID: <12148246.7IO9AkCti4@avalon>
In-Reply-To: <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2EA13@KUUMEX11.barco.com>
References: <533C2872.5090603@barco.com> <82154683.DEhQIaoLxb@avalon> <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2EA13@KUUMEX11.barco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Friday 04 April 2014 20:01:33 Scheuermann, Mail wrote:
> Hi Laurent,
> 
> I've done the following:
> 
> echo 3 >/sys/module/videobuf2_core/parameters/debug
> 
> and found in /var/log/kern.log after starting my program:
> 
> [239432.535077] vb2: Buffer 0, plane 0 offset 0x00000000
> [239432.535080] vb2: Buffer 1, plane 0 offset 0x001c2000
> [239432.535082] vb2: Buffer 2, plane 0 offset 0x00384000
> [239432.535083] vb2: Allocated 3 buffers, 1 plane(s) each
> [239432.535085] vb2: qbuf: userspace address for plane 0 changed,
> reacquiring memory
> [239432.535087] vb2: qbuf: failed acquiring userspace memory for plane 0

This confirms everything is working properly up to the point where videobuf2-
vmalloc fails to acquire the user pointer memory. The problem comes from 
vb2_vmalloc_get_userptr() in drivers/media/v4l2-core/videobuf2-vmalloc.c. 
Unfortunately that function lacks debugging. Are you familiar enough with 
kernel programming to add printk statements there and see where it fails ?

> [239432.535088] vb2: qbuf: buffer preparation failed: -22
> [239432.535128] vb2: streamoff: not streaming

-- 
Regards,

Laurent Pinchart

