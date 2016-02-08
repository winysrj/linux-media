Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57408 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbcBHSyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 13:54:15 -0500
Date: Mon, 8 Feb 2016 12:54:09 -0600
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
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Subject: Re: [PATCH v4 1/8] dt-bindings: Add a binding for Mediatek Video
 Processor
Message-ID: <20160208185409.GA14017@rob-hp-laptop>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 04, 2016 at 07:34:56PM +0800, Tiffany Lin wrote:
> From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> 
> Add a DT binding documentation of Video Processor Unit for the
> MT8173 SoC from Mediatek.
> 
> 
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vpu.txt     |   31 ++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt

Acked-by: Rob Herring <robh@kernel.org>

