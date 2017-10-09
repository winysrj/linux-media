Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56920 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751769AbdJIH6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 03:58:07 -0400
Date: Mon, 9 Oct 2017 10:58:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] media: atmel-isc: Enable the clocks during probe
Message-ID: <20171009075804.2qr3pbunqzhdz5go@valkosipuli.retiisi.org.uk>
References: <20170928081828.20335-1-wenyou.yang@microchip.com>
 <20170928081828.20335-4-wenyou.yang@microchip.com>
 <20170928212543.sltvd4rgswfowtcd@valkosipuli.retiisi.org.uk>
 <7d5bd4ff-f18e-5f0d-9ce1-3f5169be4c14@Microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d5bd4ff-f18e-5f0d-9ce1-3f5169be4c14@Microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
Wenyou,

On Mon, Oct 09, 2017 at 01:49:44PM +0800, Yang, Wenyou wrote:
> Hi Sakari,
> 
> Sorry for late answer, because I was in vacation last week.
> 
> On 2017/9/29 5:25, Sakari Ailus wrote:
> > Hi Wenyou,
> > 
> > On Thu, Sep 28, 2017 at 04:18:26PM +0800, Wenyou Yang wrote:
> > > To meet the relationship, enable the HCLOCK and ispck during the
> > > device probe, "isc_pck frequency is less than or equal to isc_ispck,
> > > and isc_ispck is greater than or equal to HCLOCK."
> > > Meanwhile, call the pm_runtime_enable() in the right place.
> > > 
> > > Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> > > ---
> > > 
> > > Changes in v3: None
> > > Changes in v2: None
> > > 
> > >   drivers/media/platform/atmel/atmel-isc.c | 31 +++++++++++++++++++++++++------
> > >   1 file changed, 25 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> > > index 0b15dc1a3a0b..f092c95587c1 100644
> > > --- a/drivers/media/platform/atmel/atmel-isc.c
> > > +++ b/drivers/media/platform/atmel/atmel-isc.c
> > > @@ -1594,6 +1594,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
> > >   	struct isc_subdev_entity *sd_entity;
> > >   	struct video_device *vdev = &isc->video_dev;
> > >   	struct vb2_queue *q = &isc->vb2_vidq;
> > > +	struct device *dev = isc->dev;
> > >   	int ret;
> > >   	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
> > > @@ -1677,6 +1678,10 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
> > >   		return ret;
> > >   	}
> > > +	pm_runtime_set_active(dev);
> > > +	pm_runtime_enable(dev);
> > > +	pm_request_idle(dev);
> > Remember that the driver's async complete function could never get called.
> > 
> > What would be the reason to move it here?
> The ISC provides the clock for the sensor, namely, it is the clock provider
> for the external sensor.
> So it keeps active to make the sensor probe successfully.
> Otherwise, the sensor, such as 0v7670 fails to probe due to the failure to
> clk_enable().

You'll still need to balance the get and put calls.

complete callback is not necessarily called at all or could be called
multiple times. Instead, you should probably do pm_runtime_get_sync() when
the clock is enabled and put when it's disabled.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
