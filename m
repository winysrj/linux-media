Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:34702 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdCOQp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 12:45:29 -0400
Subject: Re: [PATCH v10 2/2] media: i2c: Add support for OV5647 sensor.
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1488798062.git.roliveir@synopsys.com>
 <67b5055a198316f74c5c1339e14a9f18a4106e69.1488798062.git.roliveir@synopsys.com>
 <20170307104545.GI3220@valkosipuli.retiisi.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        <CARLOS.PALMINHA@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        "Rob Herring" <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <350cf398-81a9-7174-fd47-1dc5c0daa990@synopsys.com>
Date: Wed, 15 Mar 2017 16:45:16 +0000
MIME-Version: 1.0
In-Reply-To: <20170307104545.GI3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

On 3/7/2017 10:45 AM, Sakari Ailus wrote:
> Hi Ramiro,
> 
> On Mon, Mar 06, 2017 at 11:16:34AM +0000, Ramiro Oliveira wrote:
> ...
>> +static int __sensor_init(struct v4l2_subdev *sd)
>> +{
>> +	int ret;
>> +	u8 resetval, rdval;
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	dev_dbg(&client->dev, "sensor init\n");
> 
> This looks like a debugging time leftover. Please remove.
> 

Should I send a v11 with this change?

> With that,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> ...
> 
>> +static int ov5647_parse_dt(struct device_node *np)
>> +{
>> +	struct v4l2_of_endpoint bus_cfg;
>> +	struct device_node *ep;
>> +
>> +	int ret;
>> +
>> +	ep = of_graph_get_next_endpoint(np, NULL);
>> +	if (!ep)
>> +		return -EINVAL;
>> +
>> +	ret = v4l2_of_parse_endpoint(ep, &bus_cfg);
>> +
>> +	of_node_put(ep);
>> +	return ret;
>> +}
> 
> This will conflict with my fwnode patchset. Let's see in which order the
> patches will be merged, one of the sets has to be changed. The work is
> trivial though.
> 

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
