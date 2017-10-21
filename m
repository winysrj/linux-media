Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:39248 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932202AbdJUUHJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 16:07:09 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/4] arm: dts: rockchip: enable the first hdmi output
Date: Sat, 21 Oct 2017 22:06:56 +0200
Message-ID: <2074014.EmavDXF96e@phil>
In-Reply-To: <20171020100734.17064-3-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl> <20171020100734.17064-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 20. Oktober 2017, 12:07:32 CEST schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The vdd10_lcd and vcc18_lcd regulators need to be enabled for HDMI output
> to work, so add 'regulator-always-on', just as is done in rk3288-firefly.dtsi.
> 
> Also enable i2c5 and the hdmi block.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

applied for 4.15, after adapting the subject and moving it
to position 3 in the series.


Heiko
