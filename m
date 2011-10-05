Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51158 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1JEQ2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 12:28:15 -0400
Received: by yxl31 with SMTP id 31so1741819yxl.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 09:28:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Oct 2011 18:28:13 +0200
Message-ID: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
Subject: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

since we are all interested in this driver (and tvp5150) i'll try to
make a summary of the current situation and understand what is needed
to finally get it into the main tree instead of having to apply a
dozen patches manually.

The current status of git repositories/branches is:

- main tree: working (i suppose) but no support for bt656 input

- pinchartl/media:
  * omap3isp-omap3isp-next: i think it's in sync with linuxtv master
(for the omap3-isp parts)
  * omap3isp-omap3isp-yuv: like ..next but with some additional format patches

"Floating" patches:

- Deepthy: sent patches (against mainline) to add bt656 support

Laurent made some comments, i haven't seen a v2 to be applied

- Javier: sent patches for tvp5150, currently discussed on
linux-media; possible patches/fixes for omap3-isp

Now what can we all do to converge to a final solution? I think this
is also blocking the possible development/test of missing features,
like the recently-discussed resizer and cropping ones.

Enrico
