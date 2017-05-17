Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39693 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753427AbdEQHBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 03:01:07 -0400
Subject: Re: [PATCH 2/4] media: platform: dwc: Support for DW CSI-2 Host
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <cover.1488885081.git.roliveir@synopsys.com>
 <6a45f8d24993bc6ab02f8bd76ef1db421ab32d9c.1488885081.git.roliveir@synopsys.com>
 <24d1c826-8c02-d625-efb7-705d3ad9ce3d@xs4all.nl>
 <49e4c275-c660-60fd-cb32-e09a5add91a5@synopsys.com>
Cc: CARLOS.PALMINHA@synopsys.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <16996e20-b636-800b-0edc-fa9cca7b4481@xs4all.nl>
Date: Wed, 17 May 2017 09:00:59 +0200
MIME-Version: 1.0
In-Reply-To: <49e4c275-c660-60fd-cb32-e09a5add91a5@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Can you comment on this? You are much more a CSI sensor expert than I am.

On 16/05/17 20:18, Ramiro Oliveira wrote:
> Hi Hans,
> 
> Thank you very much for your feedback.
> 
> On 5/8/2017 11:38 AM, Hans Verkuil wrote:
>> Hi Ramiro,
>>
>> My sincere apologies for the long delay in reviewing this. The good news is that
>> I should have more time for reviews going forward, so I hope I'll be a lot quicker
>> in the future.
>>
>> On 03/07/2017 03:37 PM, Ramiro Oliveira wrote:

<snip>

>>> +		if (mf->width == bt->width && mf->height == bt->width) {
>>
>> This is way too generic. There are many preset timings that have the same
>> width and height but different blanking periods.
>>
>> I am really not sure how this is supposed to work. If you want to support
>> HDMI here, then I would expect to see support for the s_dv_timings op and friends
>> in this driver. And I don't see support for that in the host driver either.
>>
>> Is this a generic csi driver, or specific for hdmi? Or supposed to handle both?
> 
> This is a generic CSI driver.
> 
>>
>> Can you give some background and clarification of this?
> 
> This piece of code might seem strange but I'm just using it fill our controller
> timing configuration.
> 
> I don't have any specific requirements, but they should match, more or less, the
> sensor configurations, so I decided to re-use the HDMI blanking values, since,
> usually, they match with the sensor configurations
> 
> So, my intention is to check if there is any HDMI preset that matches the
> required width and height, and then use the blanking values to configure our
> controller. I know this might not be very common, and I'm open to use different
> approaches, but from my perspective it seems to work fine.

Regards,

	Hans
