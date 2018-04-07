Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50112 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbeDGMoQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Apr 2018 08:44:16 -0400
Date: Sat, 7 Apr 2018 09:44:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] media: omapfb: relax compilation if COMPILE_TEST
Message-ID: <20180407094409.5fdc4672@vento.lan>
In-Reply-To: <3343566.MdR49rtcuZ@avalon>
References: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com>
        <c318fd1c9f79995c6c2e4e82ca99ff494b2afb7b.1523028795.git.mchehab@s-opensource.com>
        <3343566.MdR49rtcuZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 07 Apr 2018 14:46:56 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday, 6 April 2018 18:33:20 EEST Mauro Carvalho Chehab wrote:
> > The dependency of DRM_OMAP = n can be relaxed for just
> > compilation test.
> > 
> > This allows building the omap3isp driver with allyesconfig
> > on ARM.  
> 
> omapfb has nothing to do with omap3isp. I assume you meant omap_vout.
> 
> There's a reason why both DRM_OMAP and FB_OMAP2 can't be compiled at the same 
> time, they export identical symbols. I believe you will end up with link 
> failures if you do so.

Ah, OK. I'll just drop this patch.

Thanks,
Mauro
