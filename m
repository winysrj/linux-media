Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54885 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751199AbeAPKLo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 05:11:44 -0500
Subject: Re: [PATCH v5 9/9] arch: sh: migor: Use new renesas-ceu camera driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-10-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1c6f7b57-2d0c-50c2-add9-386fe1308adc@xs4all.nl>
Date: Tue, 16 Jan 2018 11:11:38 +0100
MIME-Version: 1.0
In-Reply-To: <1515765849-10345-10-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
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
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

        Hans
