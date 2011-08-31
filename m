Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51916 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab1HaPcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:32:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: status request of et8k8, ad5820 and their corresponding rx51 board code
Date: Wed, 31 Aug 2011 17:33:16 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <20110831151524.GA28065@earth.universe>
In-Reply-To: <20110831151524.GA28065@earth.universe>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311733.16363.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

(CC'ing Sakari Ailus)

On Wednesday 31 August 2011 17:15:24 Sebastian Reichel wrote:
> Hi,
> 
> What's the plan for the rx51 camera drivers from [0]? Is there a
> chance, that they get included in the mainline 3.2 or 3.3 kernel?

The ad5820 driver will probably be the simplest one to upstream. It should be 
possible to push it to v3.3. Someone needs to look at the lens-related 
controls and how they can be standardized (if at all).

The et8ek8 driver is a different story. I don't think it should get mainlined 
in its current state. We need to get rid of the "camera firmware" support from 
the driver first, and if possible implement the V4L2 API correctly without 
relying on register lists.

-- 
Regards,

Laurent Pinchart
