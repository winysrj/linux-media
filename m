Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2196 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaEBOyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 10:54:49 -0400
Message-ID: <5363B1B0.5000405@xs4all.nl>
Date: Fri, 02 May 2014 14:54:40 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "max.schulze@online.de" <max.schulze@online.de>,
	linux-media@vger.kernel.org
Subject: Re: getting 50 fields/sec from bttv, but not on usb with em28xx /
 cx231xx
References: <trinity-366a0e3a-4d3d-47f1-9f37-02de36c5e96b-1399041648866@3capp-1and1-bs01>
In-Reply-To: <trinity-366a0e3a-4d3d-47f1-9f37-02de36c5e96b-1399041648866@3capp-1and1-bs01>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/2014 02:40 PM, max.schulze@online.de wrote:
> Hello,
> 
> I have modified the 5dpo example (http://sourceforge.net/p/sdpo-cl/) to work with v4l2_pix_format set to V4L2_FIELD_ALTERNATE. With a pci grabber card and corresponding driver bttv I get 50 fields per second. Fine, great!
> 
> I then plugged a usb grabber (2040:c200 Hauppauge, module is cx231xx) and retried the same expriment and it only provides 25 (fields/frames) per second. 
> Same with a ( saa7115 8-0025: saa7113 found @ 0x4a em2860 ).
> 
> What do these usb grabbers do fundamentally different? Can't they provide every single field? What would be a good starting point for further investigation?

FIELD_ALTERNATE is only supported by saa7134, bttv and saa7146. No USB driver supports it.

In some (most?) cases that is because the hardware doesn't support it somewhere in their
video pipeline, or because we don't have the datasheets, or the driver author didn't
care about field capture (most of the time people want an interlaced picture).

> 
> I have looked through media_tree.git/tree/drivers/media/usb/cx231xx/cx231xx-video.c but did not find any clue, as I'm not really into c.

At least in this case I don't have datasheets.

> 
> Advice appreciated!\

If you want to capture fields, the three PCI devices mentioned above are the only ones
that can do it.

Regards,

	Hans

> 
> Regards,
> 
> Max
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

