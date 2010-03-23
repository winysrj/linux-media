Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34073 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0CWLi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 07:38:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [Resubmit: PATCH-V2] Introducing ti-media directory
Date: Tue, 23 Mar 2010 12:40:59 +0100
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org
References: <hvaibhav@ti.com> <1268991350-549-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1268991350-549-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231241.00281.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 March 2010 10:35:50 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Looking towards the number of files which are cluttering in media/video/
> directory, it is required to introduce seperate working
> directory for TI devices.

You should then move the omap24xxcam driver as well.

> Again the IP's are being re-used across the devices which makes it very
> difficuilt to re-use the driver code. For example, DM6446 and AM3517 both
> uses exactly same VPFE/CCDC IP, but the driver is encapsulated under
> DAVINCI which makes it impossible to re-use.

I'm not too sure to like the ti-media name. It will soon get quite crowded, 
and name collisions might occur (look at the linux-omap-camera tree and the 
ISP driver in there for instance). Isn't there an internal name to refer to 
both the DM6446 and AM3517 that could be used ?

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>

-- 
Regards,

Laurent Pinchart
