Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:29803 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFYTdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 15:33:04 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "g.liakhovetski\@gmx.de" <g.liakhovetski@gmx.de>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] media: soc_camera: pxa_camera device-tree support
References: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
	<1403389307-17489-2-git-send-email-robert.jarzmik@free.fr>
	<20140625102801.GA14495@leverpostej>
Date: Wed, 25 Jun 2014 21:32:58 +0200
In-Reply-To: <20140625102801.GA14495@leverpostej> (Mark Rutland's message of
	"Wed, 25 Jun 2014 11:28:01 +0100")
Message-ID: <878uok9445.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Rutland <mark.rutland@arm.com> writes:

> On Sat, Jun 21, 2014 at 11:21:47PM +0100, Robert Jarzmik wrote:
>> @@ -1650,6 +1651,64 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>>  	.set_bus_param	= pxa_camera_set_bus_param,
>>  };
>>  
>> +static int pxa_camera_pdata_from_dt(struct device *dev,
>> +				    struct pxa_camera_dev *pcdev)
>> +{
>> +	int err = 0;
>> +	struct device_node *np = dev->of_node;
>> +	struct v4l2_of_endpoint ep;
>> +
>> +	err = of_property_read_u32(np, "clock-frequency",
>> +				   (u32 *)&pcdev->mclk);
>
> That cast is either unnecessary or this code is broken.
Mmm maybe ...
As a clock rate is an unsigned long by design, where is the
of_property_read_ulong() function ?

> Use a temporary u32 if the types don't match.
If there's no of_*() function available, let's do that.

-- 
Robert
