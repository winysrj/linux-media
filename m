Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47114 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3LSSdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 13:33:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v10 1/2] s5k5baf: add camera sensor driver
Date: Thu, 19 Dec 2013 19:33:44 +0100
Message-ID: <2100889.mqgrGv2fsV@avalon>
In-Reply-To: <52B2FAA4.2070904@samsung.com>
References: <1386243520-17117-1-git-send-email-a.hajda@samsung.com> <1386243520-17117-2-git-send-email-a.hajda@samsung.com> <52B2FAA4.2070904@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 19 December 2013 14:54:44 Sylwester Nawrocki wrote:
> On 05/12/13 12:38, Andrzej Hajda wrote:
> > Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> > with embedded SoC ISP.
> > The driver exposes the sensor as two V4L2 subdevices:
> > - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
> >   no controls.
> > - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
> >   pre/post ISP cropping, downscaling via selection API, controls.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Hi Laurent,
> 
> Does this driver look sane to you, at its 10'th version? :)
> If so I could send a pull request including it this week.

Yes, it does. Sorry for the delay. Please send the pull request.

-- 
Regards,

Laurent Pinchart

