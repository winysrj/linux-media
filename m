Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42531 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1BNM7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:59:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH v6 02/10] omap3: Remove unusued ISP CBUFF resource
Date: Mon, 14 Feb 2011 13:59:26 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686097-9804-3-git-send-email-laurent.pinchart@ideasonboard.com> <20110214123106.GW2549@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110214123106.GW2549@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141359.27273.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Felipe,

On Monday 14 February 2011 13:31:06 Felipe Balbi wrote:
> On Mon, Feb 14, 2011 at 01:21:29PM +0100, Laurent Pinchart wrote:
> > From: Sergio Aguirre <saaguirre@ti.com>
> > 
> > The ISP CBUFF module isn't use, its resource isn't needed.
> > 
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> it's unused but it's there right ? what's the problem in keeping it ?
> maybe you'd like to add name for the resources as well, there are many
> of them and keeping the order correct might be difficult. You can move
> to platform_get_resource_byname() on drivers.

But if it's unused, why keep it ? :-) There are other resources present on the 
chip (especially on older silicon versions) that are completely unused and 
even undocumented. They're not defined either.

-- 
Regards,

Laurent Pinchart
