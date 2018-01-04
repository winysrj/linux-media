Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49885 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbeADUKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 15:10:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] arch: sh: migor: Use new renesas-ceu camera driver
Date: Thu, 04 Jan 2018 22:10:30 +0200
Message-ID: <8062486.QngExgQv9j@avalon>
In-Reply-To: <1515081797-17174-10-git-send-email-jacopo+renesas@jmondi.org>
References: <1515081797-17174-1-git-send-email-jacopo+renesas@jmondi.org> <1515081797-17174-10-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 4 January 2018 18:03:17 EET Jacopo Mondi wrote:
> Migo-R platform uses sh_mobile_ceu camera driver, which is now being
> replaced by a proper V4L2 camera driver named 'renesas-ceu'.
> 
> Move Migo-R platform to use the v4l2 renesas-ceu camera driver
> interface and get rid of soc_camera defined components used to register
> sensor drivers and of platform specific enable/disable routines.
> 
> Register clock source and GPIOs for sensor drivers, so they can use
> clock and gpio APIs.
> 
> Also, memory for CEU video buffers is now reserved with membocks APIs,
> and need to be declared as dma_coherent during machine initialization to
> remove that architecture specific part from CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/sh/boards/mach-migor/setup.c      | 225 ++++++++++++++----------------
>  arch/sh/kernel/cpu/sh4a/clock-sh7722.c |   2 +-
>  2 files changed, 101 insertions(+), 126 deletions(-)

-- 
Regards,

Laurent Pinchart
