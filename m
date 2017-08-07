Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:26777 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdHGT5L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 15:57:11 -0400
Date: Mon, 7 Aug 2017 14:56:24 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20170807195624.GE10611@ti.com>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
 <20170720092302.2982-2-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170720092302.2982-2-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Thu [2017-Jul-20 11:23:01 +0200]:
> The Cadence MIPI-CSI2 RX controller is a CSI2RX bridge that supports up to
> 4 CSI-2 lanes, and can route the frames to up to 4 streams, depending on
> the hardware implementation.
> 
> It can operate with an external D-PHY, an internal one or no D-PHY at all
> in some configurations.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/media/cdns-csi2rx.txt      | 87 ++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt
> 

Acked-by: Benoit Parrot <bparrot@ti.com>
