Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55306 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752176AbdLENjg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 08:39:36 -0500
Date: Tue, 5 Dec 2017 15:39:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v12 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 documentation
Message-ID: <20171205133933.rixqtzraauypwb4w@valkosipuli.retiisi.org.uk>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129193235.25423-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171129193235.25423-2-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 29, 2017 at 08:32:34PM +0100, Niklas Söderlund wrote:
> Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> are located between the video sources (CSI-2 transmitters) and the video
> grabbers (VIN) on Gen3 of Renesas R-Car SoC.
> 
> Each CSI-2 device is connected to more then one VIN device which
> simultaneously can receive video from the same CSI-2 device. Each VIN
> device can also be connected to more then one CSI-2 device. The routing
> of which link are used are controlled by the VIN devices. There are only
> a few possible routes which are set by hardware limitations, which are
> different for each SoC in the Gen3 family.
> 
> To work with the limitations of routing possibilities it is necessary
> for the DT bindings to describe which VIN device is connected to which
> CSI-2 device. This is why port 1 needs to to assign reg numbers for each
> VIN device that be connected to it. To setup and to know which links are
> valid for each SoC is the responsibility of the VIN driver since the
> register to configure it belongs to the VIN hardware.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Rob Herring <robh@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
