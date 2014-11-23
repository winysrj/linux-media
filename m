Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaKWNiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:38:50 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: [PATCH v2 0/9] sun6i / A31 ir receiver support
Date: Sun, 23 Nov 2014 14:38:06 +0100
Message-Id: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Here is v2 of my sun6i ir receiver support patch-set as with v1, this
touches clk, mfd (for the prcm clks), dts and media/rc code.

Changes in v2:
-"clk: sunxi: Give sunxi_factors_register a registers parameter"
 -Updated commit message to mention the removal of __init
 -Add error checking to calls of of_iomap
-"rc: sunxi-cir: Add support for an optional reset controller"
 -Document resets property in devicetree bindings doc

Regards,

Hans
