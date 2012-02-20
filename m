Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe03.c2i.net ([212.247.154.66]:33013 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752092Ab2BTTVY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 14:21:24 -0500
From: Hans Petter Selasky <hselasky@c2i.net>
To: James Hogan <james@albanarts.com>
Subject: Re: [BUG] divide by zero in uvc_video_clock_update, v3.3-rc4
Date: Mon, 20 Feb 2012 20:19:32 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120219234151.GA32005@balrog>
In-Reply-To: <20120219234151.GA32005@balrog>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202202019.32756.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 20 February 2012 00:41:51 James Hogan wrote:
> Hi,
> 
> I just tried v3.3-rc4 on an Acer Aspire One Happy 2 netbook. I happened
> to open the settings dialog box of kopete, which shows a view of the
> webcam. The kernel switched to a text console with a register dump (see
> below), indicating a divide error in uvc_video_clock_update.
> 
> The IP is on 7482, a divide, presumably by %r11 (see objdump output below)
> which is 0 in the register dump. It appears to be the div_u64 in
> uvc_video_clock_update().
> 
> I haven't tried any other recent kernel versions.
> 
> My asm is rusty and I don't really have any time to look further into it.
> Is this enough to go on?
> 
> Thanks
> James

Hi,

This is a known issue which has been fixed by:

http://git.linuxtv.org/pinchartl/uvcvideo.git/commit/5c97eb2eb9c45dad8825de7754ceb33699451978

--HPS
