Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:55564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaEBOku (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 10:40:50 -0400
MIME-Version: 1.0
Message-ID: <trinity-366a0e3a-4d3d-47f1-9f37-02de36c5e96b-1399041648866@3capp-1and1-bs01>
From: "max.schulze@online.de" <max.schulze@online.de>
To: linux-media@vger.kernel.org
Subject: getting 50 fields/sec from bttv, but not on usb with em28xx /
 cx231xx
Content-Type: text/plain; charset=UTF-8
Date: Fri, 2 May 2014 16:40:48 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have modified the 5dpo example (http://sourceforge.net/p/sdpo-cl/) to work with v4l2_pix_format set to V4L2_FIELD_ALTERNATE. With a pci grabber card and corresponding driver bttv I get 50 fields per second. Fine, great!

I then plugged a usb grabber (2040:c200 Hauppauge, module is cx231xx) and retried the same expriment and it only provides 25 (fields/frames) per second. 
Same with a ( saa7115 8-0025: saa7113 found @ 0x4a em2860 ).

What do these usb grabbers do fundamentally different? Can't they provide every single field? What would be a good starting point for further investigation?

I have looked through media_tree.git/tree/drivers/media/usb/cx231xx/cx231xx-video.c but did not find any clue, as I'm not really into c.

Advice appreciated!

Regards,

Max
