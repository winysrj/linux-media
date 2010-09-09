Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:33852 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0IISvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 14:51:15 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 9 Sep 2010 13:51:07 -0500
Subject: [Query] Is there a spec to request video sensor information?
Message-ID: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I was wondering if there exists a current standard way to query a
Imaging sensor driver for knowing things like the signal vert/horz blanking time.

In an old TI custom driver, we used to have a private IOCTL in the sensor
Driver we interfaced with the omap3 ISP, which was basically reporting:

- Active resolution (Actual image size)
- Full resolution (Above size + dummy pixel columns/rows representing blanking times)

However I resist to keep importing that custom interface, since I think its
Something that could be already part of an standard API.

Any pointers will be much appreciated.

Regards,
Sergio

