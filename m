Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbcDNQPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:15:09 -0400
Date: Thu, 14 Apr 2016 11:15:03 -0500
From: Rob Herring <robh@kernel.org>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
Subject: Re: [PATCH 2/7] dt-bindings: Add a binding for Mediatek Video Decoder
Message-ID: <20160414161503.GA11394@rob-hp-laptop>
References: <1460548915-17536-1-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
 <1460548915-17536-3-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460548915-17536-3-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 13, 2016 at 08:01:50PM +0800, Tiffany Lin wrote:
> Add a DT binding documentation of Video Decoder for the
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   50 ++++++++++++++++++--
>  1 file changed, 46 insertions(+), 4 deletions(-)

Acked-by: Rob Herring <rob@kernel.org>
