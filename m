Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41587 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbcEPPhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 11:37:38 -0400
Date: Mon, 16 May 2016 10:37:31 -0500
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
Subject: Re: [PATCH v2 4/9] dt-bindings: Add a binding for Mediatek Video
 Decoder
Message-ID: <20160516153731.GA22492@rob-hp-laptop>
References: <1463052250-38262-1-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-2-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-3-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-4-git-send-email-tiffany.lin@mediatek.com>
 <1463052250-38262-5-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463052250-38262-5-git-send-email-tiffany.lin@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 12, 2016 at 07:24:05PM +0800, Tiffany Lin wrote:
> Add a DT binding documentation of Video Decoder for the
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt  |   50 ++++++++++++++++++--
>  1 file changed, 46 insertions(+), 4 deletions(-)

Please add acks when posting new versions.
