Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:59861 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab0JFHrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 03:47:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH v2 4/6] ARM: OMAP3: Update Camera ISP definitions for OMAP3630
Date: Wed, 6 Oct 2010 09:47:54 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1286284734-12292-5-git-send-email-laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894472B4F82D@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894472B4F82D@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010060947.55093.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio,

On Tuesday 05 October 2010 18:09:42 Aguirre, Sergio wrote:
> On Tuesday, October 05, 2010 8:19 AM Laurent Pinchart wrote:
> > 
> > From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> > 
> > Add new/changed base address definitions and resources for
> > OMAP3630 ISP.
> > 
> > The OMAP3430 CSI2PHY block is same as the OMAP3630 CSIPHY2
> > block. But the later name is chosen as it gives more symmetry
> > to the names.
> 
> This patch needs to go through linux-omap ML.

Sure. I'll send it (as well as the next patch) to the linux-omap mailing list 
after the first review round of the OMAP3 ISP driver.

-- 
Regards,

Laurent Pinchart
