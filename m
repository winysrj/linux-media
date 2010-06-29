Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46023 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0F2NWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 09:22:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [media-ctl RFC][PATCH 0/5] Exported headers to userspace fixes
Date: Tue, 29 Jun 2010 15:22:38 +0200
Cc: linux-media@vger.kernel.org
References: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
In-Reply-To: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291522.39388.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Tuesday 29 June 2010 14:43:05 Sergio Aguirre wrote:
> Hi Laurent,
> 
> While trying to generate kernel headers by doing 'make headers_install',
> I noticed that the headers weren't actually copied into the filesystem.
> 
> So, here's some fixes I have come across. This is the baseline I use:
> 
> http://gitorious.org/omap3camera/mainline/commits/devel
> 
> Any feedback is greatly appreciated.

Thanks for the patches. They look good to me.

I'll squash the patches with the related patches when submitting the code 
upstream. In the meantime they will go to the omap3camera tree, but that will 
have to wait until Sakari comes back from holidays.

-- 
Regards,

Laurent Pinchart
