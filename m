Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:49828 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1K2LPU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 06:15:20 -0500
Subject: Re: [PATCH] [media] convert drivers/media/* to use
 module_platform_driver()
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Jonathan Corbet <corbet@lwn.net>,
	Daniel Drake <dsd@laptop.org>, linux-media@vger.kernel.org
In-Reply-To: <1322290135.20464.1.camel@phoenix>
References: <1322290135.20464.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 13:24:37 +0200
Message-ID: <1322565877.5588.8.camel@trdhcp003120.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On Sat, 2011-11-26 at 14:48 +0800, ext Axel Lin wrote:
> This patch converts the drivers in drivers/media/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Richard Röjfors" <richard.rojfors@pelagicore.com>
> Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>


>  drivers/media/radio/radio-wl1273.c         |   17 +-----------

For the above:

Acked-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>

 


