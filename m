Return-path: <mchehab@pedra>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:45819
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab1EWRDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 13:03:55 -0400
Message-ID: <4DDA9372.5060200@compulab.co.il>
Date: Mon, 23 May 2011 20:03:46 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, beagleboard@googlegroups.com,
	carlighting@yahoo.co.nz, g.liakhovetski@gmx.de,
	linux-arm-kernel@lists.infradead.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor driver.
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <4DD9146B.2050408@compulab.co.il> <BANLkTi=sqZpAKFxeCbwqpU_7+WZABGa4=w@mail.gmail.com> <201105230947.15775.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105230947.15775.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/23/11 10:47, Laurent Pinchart wrote:
> Hi Javier,
>
> On Monday 23 May 2011 09:25:01 javier Martin wrote:
>> On 22 May 2011 15:49, Igor Grinberg <grinberg@compulab.co.il> wrote:
> [snip]
>
>>>> @@ -309,6 +357,15 @@ static int beagle_twl_gpio_setup(struct device
>>>> *dev, pr_err("%s: unable to configure EHCI_nOC\n", __func__); }
>>>>
>>>> +     if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM) {
>>>> +             /*
>>>> +              * Power on camera interface - only on pre-production, not
>>>> +              * needed on production boards
>>>> +              */
>>>> +             gpio_request(gpio + 2, "CAM_EN");
>>>> +             gpio_direction_output(gpio + 2, 1);
>>> Why not gpio_request_one()?
>> Just to follow the same approach as in the rest of the code.
>> Maybe a further patch could change all "gpio_request()" uses to
>> "gpio_request_one()".
> Please do it the other way around. Replace calls to gpio_request() + 
> gpio_direction_output() with a call to gpio_request_one(), and then modify 
> this patch to use gpio_request_one().

Well, this is done already, you need to follow Tony's linux-next branch...
So, just changing this patch would do...
Also, good practice is to base patches on maintainer's appropriate branch,
so it would be easier to apply.



-- 
Regards,
Igor.

