Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:39120 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932200AbdJUT3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 15:29:10 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/4] arm: dts: rockchip: add the cec clk for dw-hdmi on rk3288
Date: Sat, 21 Oct 2017 21:29:02 +0200
Message-ID: <1702489.CpKZRm6uOh@phil>
In-Reply-To: <20171020100734.17064-2-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl> <20171020100734.17064-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 20. Oktober 2017, 12:07:31 CEST schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The dw-hdmi block needs the cec clk for the rk3288. Add it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

applied for 4.15, after s/arm:/ARM:/ in the subject


Thanks
Heiko
