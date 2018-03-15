Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47512 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750726AbeCOMb6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 08:31:58 -0400
Date: Thu, 15 Mar 2018 14:31:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: media: rcar_vin: Use status "okay"
Message-ID: <20180315123154.fl5y3kzkvtjlqvc3@valkosipuli.retiisi.org.uk>
References: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2018 at 10:34:40AM +0100, Geert Uytterhoeven wrote:
> According to the Devicetree Specification, "ok" is not a valid status.
> 
> Fixes: 47c71bd61b772cd7 ("[media] rcar_vin: add devicetree support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

There are a few other matches, too, it'd be nice to fix them as well:

$ git grep 'status.*"ok"' -- Documentation/devicetree/bindings/
Documentation/devicetree/bindings/ata/apm-xgene.txt:- status            : Shall be "ok" if enabled or "disabled" if disabled.
Documentation/devicetree/bindings/display/hisilicon/dw-dsi.txt:         status = "ok";
Documentation/devicetree/bindings/display/ti/ti,omap-dss.txt:   status = "ok";
Documentation/devicetree/bindings/display/ti/ti,omap-dss.txt:   status = "ok";
Documentation/devicetree/bindings/media/rcar_vin.txt:        status = "ok";
Documentation/devicetree/bindings/media/rcar_vin.txt:        status = "ok";
Documentation/devicetree/bindings/net/apm-xgene-enet.txt:- status: Should be "ok" or "disabled" for enabled/disabled. Default is "ok".
Documentation/devicetree/bindings/net/apm-xgene-enet.txt:               status = "ok";
Documentation/devicetree/bindings/net/apm-xgene-enet.txt:        status = "ok";
Documentation/devicetree/bindings/pci/hisilicon-pcie.txt:- status: Either "ok" or "disabled".
Documentation/devicetree/bindings/pci/xgene-pci.txt:- status: Either "ok" or "disabled".
Documentation/devicetree/bindings/pci/xgene-pci.txt:            status = "ok";
Documentation/devicetree/bindings/phy/apm-xgene-phy.txt:- status                : Shall be "ok" if enabled or "disabled" if disabled.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
