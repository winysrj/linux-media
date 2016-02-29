Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbcB2VXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 16:23:09 -0500
Subject: Re: linux-next: Tree for Feb 29 (media: em28xx)
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
References: <20160229193034.0b663e03@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	FrankS <fschaefer.oss@googlemail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <56D4B6B9.8020200@infradead.org>
Date: Mon, 29 Feb 2016 13:23:05 -0800
MIME-Version: 1.0
In-Reply-To: <20160229193034.0b663e03@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/29/16 00:30, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20160226:
> 


on i386:

../drivers/media/usb/em28xx/em28xx-video.c: In function 'em28xx_v4l2_init':
../drivers/media/usb/em28xx/em28xx-video.c:2717:38: error: 'struct em28xx' has no member named 'media_dev'
  ret = v4l2_mc_create_media_graph(dev->media_dev);
                                      ^

when CONFIG_MEDIA_CONTROLLER is not enabled.

-- 
~Randy
