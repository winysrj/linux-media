Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:33563 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0HZHao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 03:30:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3camera] How does a lens subdevice get powered up?
Date: Thu, 26 Aug 2010 09:30:42 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
References: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008260930.43141.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Sergio,

On Wednesday 25 August 2010 22:15:36 Aguirre, Sergio wrote:
> Hi Laurent,
> 
> I see that usually a sensor is powered up on attempting a VIDIOC_STREAMON
> at the capture endpoint of the pipeline, in which the sensor is linked.
> 
> Now, what I don't understand quite well is, the Lens driver is a separate
> subdevice, BUT it's obviously not linked to the sensor, nor the pipeline.
> 
> How would the lens driver know when to power up?

At the moment a userspace application needs to keep the lens subdev open to 
power-up the lens controller.

-- 
Regards,

Laurent Pinchart
