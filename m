Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:33628 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbcFAO7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 10:59:51 -0400
Date: Wed, 1 Jun 2016 09:59:49 -0500
From: Rob Herring <robh@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/2] [media] media: i2c/ov5645: add the device tree
 binding document
Message-ID: <20160601145949.GA13480@rob-hp-laptop>
References: <1464363530-2253-1-git-send-email-todor.tomov@linaro.org>
 <1464363530-2253-2-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1464363530-2253-2-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 27, 2016 at 06:38:49PM +0300, Todor Tomov wrote:
> Add the document for ov5645 device tree binding.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../devicetree/bindings/media/i2c/ov5645.txt       | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt

Acked-by: Rob Herring <robh@kernel.org>
