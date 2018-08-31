Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42160 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728071AbeHaQdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 12:33:17 -0400
Date: Fri, 31 Aug 2018 15:25:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ysato@users.sourceforge.jp, dalias@libc.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove sh_mobile_ceu_camera from arch/sh
Message-ID: <20180831122558.zv7537uyfw5pcnqj@valkosipuli.retiisi.org.uk>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Mon, May 28, 2018 at 06:37:06PM +0200, Jacopo Mondi wrote:
> Hello,
>     this series removes dependencies on the soc_camera based
> sh_mobile_ceu_camera driver from 3 board files in arch/sh and from one
> sensor driver used by one of those boards.
> 
> Hans, this means there are no more user of the soc_camera framework that I know
> of in Linux, and I guess we can now plan of to remove that framework.

What's the status of this set? I think it'd be nice to get it in; the CEU
driver is the last using SoC camera framework.

I guess an ack from the SH folks would be needed for these patches to go
through the media tree.

On the sensor driver patches --- please just move the files. The CEU was
the last that it was possible to use the drivers with.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
