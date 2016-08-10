Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35887 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbcHJWUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 18:20:14 -0400
Date: Wed, 10 Aug 2016 17:20:12 -0500
From: Rob Herring <robh@kernel.org>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	srv_heupstream@mediatek.com,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 2/4] dt-bindings: Add a binding for Mediatek MDP
Message-ID: <20160810222012.GA30019@rob-hp-laptop>
References: <1470751137-12403-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1470751137-12403-3-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470751137-12403-3-git-send-email-minghsiu.tsai@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 09, 2016 at 09:58:55PM +0800, Minghsiu Tsai wrote:
> Add a DT binding documentation of MDP for the MT8173 SoC
> from Mediatek
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-mdp.txt     |  109 ++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt

Acked-by: Rob Herring <robh@kernel.org>
