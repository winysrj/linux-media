Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94218C43387
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 10:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D1621720
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 10:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbeLZKiY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 05:38:24 -0500
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:51684 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeLZKiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 05:38:24 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08374568|-1;CH=green;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03294;MF=yong.deng@magewell.com;NM=1;PH=DS;RN=24;RT=24;SR=0;TI=SMTPD_---.DdCL9.._1545820694;
Received: from John(mailfrom:yong.deng@magewell.com fp:SMTPD_---.DdCL9.._1545820694)
          by smtp.aliyun-inc.com(10.147.42.22);
          Wed, 26 Dec 2018 18:38:15 +0800
Date:   Wed, 26 Dec 2018 18:38:15 +0800
From:   Yong <yong.deng@magewell.com>
To:     megous@megous.com
Cc:     =?UTF-8?B?J09uZMWZZWo=?= Jirman' via linux-sunxi 
        <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
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
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [linux-sunxi] [PATCH v12 0/2] Initial Allwinner V3s CSI Support
Message-Id: <20181226183815.81443b67313823e4fd7788eb@magewell.com>
In-Reply-To: <20181226102936.2xxu7lii4kcg7656@core.my.home>
References: <1540886988-27696-1-git-send-email-yong.deng@magewell.com>
        <20181226102936.2xxu7lii4kcg7656@core.my.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, 26 Dec 2018 11:29:36 +0100
'Ondřej Jirman' via linux-sunxi <linux-sunxi@googlegroups.com> wrote:

> Hello,
> 
> On Tue, Oct 30, 2018 at 04:09:48PM +0800, Yong Deng wrote:
> > I can't make v4l2-compliance always happy.
> > The V3s CSI support many pixformats. But they are not always available.
> > It's dependent on the input bus format (MEDIA_BUS_FMT_*). 
> > Example:
> > V4L2_PIX_FMT_SBGGR8: MEDIA_BUS_FMT_SBGGR8_1X8
> > V4L2_PIX_FMT_YUYV: MEDIA_BUS_FMT_YUYV8_2X8
> > But I can't get the subdev's format code before starting stream as the
> > subdev may change it. So I can't know which pixformats are available.
> > So I exports all the pixformats supported by SoC.
> > The result is the app (v4l2-compliance) is likely to fail on streamon.
> > 
> > This patchset add initial support for Allwinner V3s CSI.
> 
> I've tested your patches on A83T and CSI works on that SoC too. I'll send
> DTS patches later.
> 
> One thing I noticed is that, when you cat the regmap registers file in debugfs
> while streaming, the kernel locks up hard. I was not able to extract any logs.

May be some registers can't be read when streaming ? Like read-clear regs ?
Or multi CPU core access regs at the same time may cause the bus lock up?

Thanks,
Yong
