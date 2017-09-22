Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43864 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752131AbdIVMBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 08:01:09 -0400
Date: Fri, 22 Sep 2017 15:01:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com
Subject: Re: [PATCH 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 TX Device
 Tree bindings
Message-ID: <20170922120106.mfxoh34anazqakvz@valkosipuli.retiisi.org.uk>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-2-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922114703.30511-2-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 22, 2017 at 01:47:02PM +0200, Maxime Ripard wrote:
> The Cadence MIPI-CSI2 RX controller is a CSI2 bridge that supports up to 4

Should this be TX?

I was just thinking what does this chip do, and saw both. RX it at least
less common. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
