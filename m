Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbcAIWY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 17:24:58 -0500
Date: Sat, 9 Jan 2016 16:24:53 -0600
From: Rob Herring <robh@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 07/10] [media] tvp5150: Add device tree binding
 document
Message-ID: <20160109222453.GA9848@rob-hp-laptop>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
 <1452170810-32346-8-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452170810-32346-8-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 07, 2016 at 09:46:47AM -0300, Javier Martinez Canillas wrote:
> Add a Device Tree binding document for the TVP5150 video decoder.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> ---
> 
> Changes in v2:
> - Fix indentation of the DTS example. Suggested by Rob Herring.
> - Rename powerdown-gpios to pdn-gpios to match the pin name in
>   the datasheet. Suggested by Laurent Pinchart.
> - Add optional properties for the video endpoint and list the supported
>   values. Suggested by Laurent Pinchart.
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt

Acked-by: Rob Herring <robh@kernel.org>
