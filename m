Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37351 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1I0MDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 08:03:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Status of the patches under review at LMML (28 patches)
Date: Tue, 27 Sep 2011 14:03:17 +0200
Cc: LMML <linux-media@vger.kernel.org>, Pawel Osiak <pawel@osciak.com>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Eddi De Pieri <eddi@depieri.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
References: <4E7DCE71.4030200@redhat.com>
In-Reply-To: <4E7DCE71.4030200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271403.19207.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday 24 September 2011 14:34:57 Mauro Carvalho Chehab wrote:
> Everything at patchwork were reviewed by me, and I've applied all patches
> that I didn't notice any review by the drivers maintainers.
> 
> Driver maintainers:
> Please review the remaining patches.
> 
> 		== Patches waiting for Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> review ==
> 
> Jun,22 2011: Improve UVC buffering with regard to USB. Add checks to avoid
> division
> http://patchwork.linuxtv.org/patch/7290
> Hans Petter Selasky <hselasky@c2i.net>

On my TODO list.

> Jul,11 2011: Error routes through omap3isp ccdc.
> http://patchwork.linuxtv.org/patch/7428
> Jonathan Cameron <jic23@cam.ac.uk>

This has been superseded by "[media] omap3isp: Don't accept pipelines with no 
video source as valid" which is already in your tree.

> Jul,14 2011: uvcvideo: add fix suspend/resume quirk for Microdia camera
> http://patchwork.linuxtv.org/patch/186
> Ming Lei <tom.leiming@gmail.com>

This has been superseded by "uvcvideo: Set alternate setting 0 on resume if 
the bus has been reset" which is hopefully in your tree on its way to v3.1 :-)

> Jul,13 2011: [RFC, v1] mt9v113: VGA camera sensor driver and support for
> BeagleBoar
> http://patchwork.linuxtv.org/patch/184
> Joel A Fernandes <agnel.joel@gmail.com>

I've reviewed the patch, waiting for the next version.

> Sep, 6 2011: mt9p031: Do not use PLL if external frequency is the same as
> target fr
> http://patchwork.linuxtv.org/patch/7783
> Javier Martin <javier.martin@vista-silicon.com>

I've reviewed the patch, I think we should implement proper PLL support.

-- 
Regards,

Laurent Pinchart
