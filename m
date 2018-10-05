Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([185.11.138.130]:43622 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJETCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 15:02:34 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Subject: Re: [PATCH v7 2/6] ARM: dts: rockchip: add VPU device node for RK3288
Date: Fri, 05 Oct 2018 14:04:04 +0200
Message-ID: <2088426.XNZsqnkTft@phil>
In-Reply-To: <20181005001226.12789-3-ezequiel@collabora.com>
References: <20181005001226.12789-1-ezequiel@collabora.com> <20181005001226.12789-3-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 5. Oktober 2018, 02:12:22 CEST schrieb Ezequiel Garcia:
> Add the Video Processing Unit node for RK3288 SoC.
> 
> Fix the VPU IOMMU node, which was disabled and lacking
> its power domain property.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

applied for 4.20 (may possibly move to 4.21 though)
after moving power-domain* below (#)iommu* to keep
alphabetical sorting.

Thanks
Heiko
