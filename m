Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52174 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752300AbdEQI0b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 04:26:31 -0400
Date: Wed, 17 May 2017 11:25:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        CARLOS.PALMINHA@synopsys.com,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: Re: [PATCH 2/4] media: platform: dwc: Support for DW CSI-2 Host
Message-ID: <20170517082550.GS3227@valkosipuli.retiisi.org.uk>
References: <cover.1488885081.git.roliveir@synopsys.com>
 <6a45f8d24993bc6ab02f8bd76ef1db421ab32d9c.1488885081.git.roliveir@synopsys.com>
 <24d1c826-8c02-d625-efb7-705d3ad9ce3d@xs4all.nl>
 <49e4c275-c660-60fd-cb32-e09a5add91a5@synopsys.com>
 <16996e20-b636-800b-0edc-fa9cca7b4481@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16996e20-b636-800b-0edc-fa9cca7b4481@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,

On Wed, May 17, 2017 at 09:00:59AM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> Can you comment on this? You are much more a CSI sensor expert than I am.

Sure. Thanks for the ping.

> 
> On 16/05/17 20:18, Ramiro Oliveira wrote:
> > Hi Hans,
> > 
> > Thank you very much for your feedback.
> > 
> > On 5/8/2017 11:38 AM, Hans Verkuil wrote:
> >> Hi Ramiro,
> >>
> >> My sincere apologies for the long delay in reviewing this. The good news is that
> >> I should have more time for reviews going forward, so I hope I'll be a lot quicker
> >> in the future.
> >>
> >> On 03/07/2017 03:37 PM, Ramiro Oliveira wrote:
> 
> <snip>
> 
> >>> +		if (mf->width == bt->width && mf->height == bt->width) {
> >>
> >> This is way too generic. There are many preset timings that have the same
> >> width and height but different blanking periods.
> >>
> >> I am really not sure how this is supposed to work. If you want to support
> >> HDMI here, then I would expect to see support for the s_dv_timings op and friends
> >> in this driver. And I don't see support for that in the host driver either.
> >>
> >> Is this a generic csi driver, or specific for hdmi? Or supposed to handle both?
> > 
> > This is a generic CSI driver.
> > 
> >>
> >> Can you give some background and clarification of this?
> > 
> > This piece of code might seem strange but I'm just using it fill our controller
> > timing configuration.
> > 
> > I don't have any specific requirements, but they should match, more or less, the
> > sensor configurations, so I decided to re-use the HDMI blanking values, since,
> > usually, they match with the sensor configurations
> > 
> > So, my intention is to check if there is any HDMI preset that matches the
> > required width and height, and then use the blanking values to configure our
> > controller. I know this might not be very common, and I'm open to use different
> > approaches, but from my perspective it seems to work fine.

What kind of timing information do you need to configure the receiver?

If you pick a random HDMI configuration it can't be expected to match an
unrelated configuration of a sensor. Generally CSI-2 bus frequency, number
of lanes and horizontal and vertical blanking are enough to calculate what
the hardware needs regarding timing. The received image size is necessary
for other purposes.

Do you see that you'd need something else in addition to that?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
