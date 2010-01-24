Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:54821 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0AXRv4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 12:51:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: gitorious.org/omap3camera: Falied attempt to migrate sensor driver to Zoom2/3 platform
Date: Sun, 24 Jan 2010 18:52:23 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE8944517F0987@dlee02.ent.ti.com> <201001221246.24330.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE8944517F0E40@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944517F0E40@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001241852.23334.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 22 January 2010 19:36:06 Aguirre, Sergio wrote:

[snip]

> Ok, I was able to "work around" the kernel panic with the attached patch.
> 
> I have the feeling that all your development is dependant on loading all
>  camera/sensors as modules in the filesystem. Have you done validation with
>  built-in option in kernel's menuconfig?

You're right. I haven't done any validation, and I've been to reproduce the 
crash when compiling everything directly into the kernel image.

I'm on holidays this week so I won't be able to look into the problem before 
February the 1st. If nobody beats me to it, I'll see how we can fix it 
properly then.

-- 
Regards,

Laurent Pinchart
