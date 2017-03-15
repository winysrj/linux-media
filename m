Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58648 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752027AbdCOWMv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:12:51 -0400
Date: Thu, 16 Mar 2017 00:03:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, vladimir_zapolskiy@mentor.com,
        CARLOS.PALMINHA@synopsys.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v10 2/2] media: i2c: Add support for OV5647 sensor.
Message-ID: <20170315220303.GG10701@valkosipuli.retiisi.org.uk>
References: <cover.1488798062.git.roliveir@synopsys.com>
 <67b5055a198316f74c5c1339e14a9f18a4106e69.1488798062.git.roliveir@synopsys.com>
 <20170307104545.GI3220@valkosipuli.retiisi.org.uk>
 <350cf398-81a9-7174-fd47-1dc5c0daa990@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <350cf398-81a9-7174-fd47-1dc5c0daa990@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Wed, Mar 15, 2017 at 04:45:16PM +0000, Ramiro Oliveira wrote:
> Hi Sakari
> 
> On 3/7/2017 10:45 AM, Sakari Ailus wrote:
> > Hi Ramiro,
> > 
> > On Mon, Mar 06, 2017 at 11:16:34AM +0000, Ramiro Oliveira wrote:
> > ...
> >> +static int __sensor_init(struct v4l2_subdev *sd)
> >> +{
> >> +	int ret;
> >> +	u8 resetval, rdval;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	dev_dbg(&client->dev, "sensor init\n");
> > 
> > This looks like a debugging time leftover. Please remove.
> > 
> 
> Should I send a v11 with this change?

Please do; you can add my ack on that one.

> 
> > With that,
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > ...
> > 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
