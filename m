Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:40583 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0IMP14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 11:27:56 -0400
Message-ID: <4C8E42F8.1080201@maxwell.research.nokia.com>
Date: Mon, 13 Sep 2010 18:27:52 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ivan Ivanov <iivanov@mm-sol.com>
Subject: Re: [Query] Is there a spec to request video sensor information?
References: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Aguirre, Sergio wrote:
> Hi,

Hi Sergio,

> I was wondering if there exists a current standard way to query a
> Imaging sensor driver for knowing things like the signal vert/horz blanking time.
> 
> In an old TI custom driver, we used to have a private IOCTL in the sensor
> Driver we interfaced with the omap3 ISP, which was basically reporting:
> 
> - Active resolution (Actual image size)
> - Full resolution (Above size + dummy pixel columns/rows representing blanking times)
> 
> However I resist to keep importing that custom interface, since I think its
> Something that could be already part of an standard API.

The N900 sensor drivers currently use private controls for this purpose.
That is an issue which should be resolved. I agree there should be a
uniform, standard way to access this information.

What we currently have is this, not in upstream:

---
/* SMIA-type sensor information */
#define V4L2_CID_MODE_CLASS_BASE                (V4L2_CTRL_CLASS_MODE |
0x900)
#define V4L2_CID_MODE_CLASS                     (V4L2_CTRL_CLASS_MODE | 1)
#define V4L2_CID_MODE_FRAME_WIDTH               (V4L2_CID_MODE_CLASS_BASE+1)
#define V4L2_CID_MODE_FRAME_HEIGHT              (V4L2_CID_MODE_CLASS_BASE+2)
#define V4L2_CID_MODE_VISIBLE_WIDTH             (V4L2_CID_MODE_CLASS_BASE+3)
#define V4L2_CID_MODE_VISIBLE_HEIGHT            (V4L2_CID_MODE_CLASS_BASE+4)
#define V4L2_CID_MODE_PIXELCLOCK                (V4L2_CID_MODE_CLASS_BASE+5)
#define V4L2_CID_MODE_SENSITIVITY               (V4L2_CID_MODE_CLASS_BASE+6)
---

The pixel clock is read-only but some of the others should likely be
changeable.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
