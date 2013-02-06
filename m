Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:40315 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFXo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 18:44:57 -0500
Message-ID: <5112EAF6.1040408@wwwdotorg.org>
Date: Wed, 06 Feb 2013 16:44:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 06/10] s5p-fimc: Use pinctrl API for camera ports configuration
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-7-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1359745771-23684-7-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
> Before the camera ports can be used the pinmux needs to be configured
> properly. This patch adds a function to set the camera ports pinctrl
> to a default state within the media driver's probe().
> The camera port(s) are then configured for the video bus operation.

> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt

> +- pinctrl-names    : pinctrl names for camera port pinmux control, at least
> +		     "default" needs to be specified.
> +- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names
> +

A reference to the binding document describing the pin control bindings
would be appropriate here. Given that reference, I'm not sure if
spelling out the property names makes sense since it feels a little like
duplication; an alternative might be simply:

The pinctrl bindings defined in ../../../pinctrl/pinctrl-bindings.txt
must be used to define a pinctrl state named "default".

However, this isn't a big deal; it's fine either way.

