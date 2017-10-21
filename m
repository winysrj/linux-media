Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:39150 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932159AbdJUTg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 15:36:56 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/4] arm: dts: rockchip: define the two possible CEC pins
Date: Sat, 21 Oct 2017 21:36:42 +0200
Message-ID: <10200758.Ac6vYunJn0@phil>
In-Reply-To: <20171020100734.17064-4-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl> <20171020100734.17064-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 20. Oktober 2017, 12:07:33 CEST schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The CEC line can be routed to two possible pins. Define those pins.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

applied for 4.15, after massaging the subject a bit and moving
hdmi-cec above the hdmi-ddc subnode (alphabetical ordering)


Thanks
Heiko
