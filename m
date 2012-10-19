Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45326 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2JSOAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 10:00:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: John Weber <rjohnweber@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Using omap3-isp-live example application on beagleboard with DVI
Date: Fri, 19 Oct 2012 16:01 +0200
Message-ID: <1584362.BsWDphDTBL@avalon>
In-Reply-To: <CAFqH_53G_jt1LdTiHtqnGKkqK8mmCOgt-ypQzpzjwpdytpsgzQ@mail.gmail.com>
References: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com> <4949132.OD6tNZX2Jk@avalon> <CAFqH_53G_jt1LdTiHtqnGKkqK8mmCOgt-ypQzpzjwpdytpsgzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

On Wednesday 17 October 2012 11:35:37 Enric Balletbo Serra wrote:
> 2012/10/17 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

[snip]

> > Instead of failing what would be more interesting would be to get the
> > application to work in 16bpp mode as well. For that you will need to paint
> > the frame buffer with a 16bpp color, and set the colorkey to the same
> > value. Would you be able to try that ?
> 
> New patch attached, comments are welcome as I'm newbie with video devices.

Thank you for the patch. In the future could you please send patches inline 
instead of attached (git send-email is a very useful tool for that) ? It would 
make review easier.

You can get the bpp value directly from the frame buffer API without going 
through sysfs. I've modified your patch accordingly, have added support for 
24bpp as well and pushed the result to the repository.

-- 
Regards,

Laurent Pinchart

