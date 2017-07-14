Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37578 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751038AbdGNWCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 18:02:17 -0400
Date: Sat, 15 Jul 2017 01:02:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3ISP CCP2 support
Message-ID: <20170714220211.vuyi5v4k4ortei6k@valkosipuli.retiisi.org.uk>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
 <20170713211335.GA13502@amd>
 <20170713212651.so5aqqp5k325pb4w@valkosipuli.retiisi.org.uk>
 <20170713213805.GA1229@amd>
 <20170713220947.ntfpwkoitfadshnt@valkosipuli.retiisi.org.uk>
 <20170714065611.GA14652@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714065611.GA14652@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 08:56:11AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > The patches work fine on N9.
> > > 
> > > I was able to fix the userspace, and they work for me, too. For both:
> > > 
> > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > Tested-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Thanks! I've applied these on ccp2-prepare. ccp2 branch is rebased, too.
> 
> Thanks!
> 
> I rebased my patches on top of it, and pushed result to camera-fw6-2
> branch.
> 
> Can you drop this patch from ccp2 branch?
> 
> https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ccp2&id=27be6eb1f66389632a5d9dbaf0426a83f1b99b54
> 
> It is preparation for subdevices support on isp; but those will not be
> needed there as we decided to move subdevices to et8ek8.

Indeed; I've dropped the patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
