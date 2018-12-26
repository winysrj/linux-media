Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4080C43612
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 10:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7051A218AD
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 10:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="EVycJ9GE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbeLZK3k (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 05:29:40 -0500
Received: from vps.xff.cz ([195.181.215.36]:51448 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbeLZK3j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 05:29:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1545820176; bh=7jlh9sob4kpgPWzz20asCkW9HTckjcCtJKHZxR1+jJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EVycJ9GEMR7Axwr+gNniLH/dLHWVCqG5Z3ioCUTHBZlBxsDqlNDz13wuVbl2KAjJE
         MCzhfnuUS8RH1CuZzdrCT8xk+pJaPUp4lwVv1eRoluILz85yilvDgZ+926AF/1atYs
         SsT4dbFxZHrtz/K4LlbMM1pna+sVulhBqCMyfiTU=
Date:   Wed, 26 Dec 2018 11:29:36 +0100
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Yong Deng <yong.deng@magewell.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [linux-sunxi] [PATCH v12 0/2] Initial Allwinner V3s CSI Support
Message-ID: <20181226102936.2xxu7lii4kcg7656@core.my.home>
Mail-Followup-To: Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Tue, Oct 30, 2018 at 04:09:48PM +0800, Yong Deng wrote:
> I can't make v4l2-compliance always happy.
> The V3s CSI support many pixformats. But they are not always available.
> It's dependent on the input bus format (MEDIA_BUS_FMT_*). 
> Example:
> V4L2_PIX_FMT_SBGGR8: MEDIA_BUS_FMT_SBGGR8_1X8
> V4L2_PIX_FMT_YUYV: MEDIA_BUS_FMT_YUYV8_2X8
> But I can't get the subdev's format code before starting stream as the
> subdev may change it. So I can't know which pixformats are available.
> So I exports all the pixformats supported by SoC.
> The result is the app (v4l2-compliance) is likely to fail on streamon.
> 
> This patchset add initial support for Allwinner V3s CSI.

I've tested your patches on A83T and CSI works on that SoC too. I'll send
DTS patches later.

One thing I noticed is that, when you cat the regmap registers file in debugfs
while streaming, the kernel locks up hard. I was not able to extract any logs.


regards,
  Ondrej
