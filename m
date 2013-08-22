Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:35760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3HVUBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 16:01:17 -0400
Message-ID: <52166E09.60908@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:01:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 08:41 AM, Andrzej Hajda wrote:
> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> with embedded SoC ISP.
> The driver exposes the sensor as two V4L2 subdevices:
> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>   no controls.
> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>   pre/post ISP cropping, downscaling via selection API, controls.

The binding,
Acked-by: Stephen Warren <swarren@nvidia.com>

(although it would be great if another DT binding maintainer gave it a
quick look-over to make sure I didn't miss anything!)
