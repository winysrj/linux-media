Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64863 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDILFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 07:05:11 -0400
Message-id: <53452960.5070501@samsung.com>
Date: Wed, 09 Apr 2014 13:05:04 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org,
	sylvester.nawrocki@gmail.com, rahul.sharma@samsung.com
Subject: Re: [PATCHv2 2/3] drm: exynos: hdmi: use hdmiphy as PHY
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
 <53452157.9030203@samsung.com>
In-reply-to: <53452157.9030203@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,
This issue could be solved by exporting a regmap from PMU driver
or Exynos clock provider for the usage by exynos-simple-phy.
The operations on PHYs from exynos-simple-phy provider would
be chained to PMU driver and protected by a spinlock in the regmap.

Luckily, the divider is not used as far as I know.

Regards,
Tomasz Stanislawski

On 04/09/2014 12:30 PM, Andrzej Hajda wrote:
> Hi Tomasz,
> 
> On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
>> The HDMIPHY (physical interface) is controlled by a single
>> bit in a power controller's regiter. It was implemented
>> as clock. It was a simple but effective hack.
> 
> This power controller register has also bits to control HDMI clock
> divider ratio. I guess current drivers do not change it, but how do you
> want to implement access to it if some HDMI driver in the future will
> need to change ratio. I guess in case of clk it would be easier.
> 
> Regards
> Andrzej
> 
> 

