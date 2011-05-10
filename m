Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57702 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab1EJMlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 08:41:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [Query] Anyone here working with the mainline omap3isp driver?
Date: Tue, 10 May 2011 14:42:41 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Ohad Ben-Cohen" <ohad@wizery.com>, Bhavin Shah <bshah@ti.com>
References: <BANLkTi=FXUvjikBb-ooLSaicWoRf3kM74Q@mail.gmail.com>
In-Reply-To: <BANLkTi=FXUvjikBb-ooLSaicWoRf3kM74Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101442.41301.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday 10 May 2011 00:04:09 Aguirre, Sergio wrote:
> Hi Everyone,
> 
> I'll just like to know if there's someone working with the mainline
> version of the omap3isp driver.

I do :-)

> Ohad (in CC) has some omap3 iommu changes which might affect the
> omap3isp driver.

Which changes are you referring to ? IOMMU is known to be broken in mainline. 
I've sent a patch to fix it (https://patchwork.kernel.org/patch/736351/).

> I have been a bit away of the omap3 driver these days, so, if there's
> someone else that can try some iommu changes on top, that'll be great.

-- 
Regards,

Laurent Pinchart
