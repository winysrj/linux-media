Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:54999 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdBIKNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 05:13:16 -0500
Subject: Re: [PATCH RESEND v7 2/2] Add support for OV5647 sensor.
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1486136893.git.roliveir@synopsys.com>
 <26e5a587f1ba9e2fbbc04284408305bc8cf8c5c0.1486136893.git.roliveir@synopsys.com>
 <20170203201729.GA18086@kekkonen.localdomain>
 <f23e76ff-326a-c4df-601d-6b12b644bff7@synopsys.com>
 <20170207173116.GC13854@valkosipuli.retiisi.org.uk>
 <e4ce5644-4f44-4c46-219a-cac2126dc8ba@synopsys.com>
 <20170209100254.GH13854@valkosipuli.retiisi.org.uk>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <CARLOS.PALMINHA@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Pavel Machek" <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <3d8368f8-0cae-934b-fc6a-0ead79db14aa@synopsys.com>
Date: Thu, 9 Feb 2017 10:13:02 +0000
MIME-Version: 1.0
In-Reply-To: <20170209100254.GH13854@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

On 2/9/2017 10:02 AM, Sakari Ailus wrote:
> Hi Ramiro,
> 
> On Wed, Feb 08, 2017 at 09:56:12AM +0000, Ramiro Oliveira wrote:
>> Hi Sakari
>>
>> On 2/7/2017 5:31 PM, Sakari Ailus wrote:
>>> Hi Ramiro,
>>>
>>> On Mon, Feb 06, 2017 at 11:38:28AM +0000, Ramiro Oliveira wrote:
>>> ...
>>>>>> +	ret = ov5647_write_array(sd, ov5647_640x480,
>>>>>> +					ARRAY_SIZE(ov5647_640x480));
>>>>>> +	if (ret < 0) {
>>>>>> +		dev_err(&client->dev, "write sensor_default_regs error\n");
>>>>>> +		return ret;
>>>>>> +	}
>>>>>> +
>>>>>> +	ov5647_set_virtual_channel(sd, 0);
>>>>>> +
>>>>>> +	ov5647_read(sd, 0x0100, &resetval);
>>>>>> +	if (!(resetval & 0x01)) {
>>>>>
>>>>> Can this ever happen? Streaming start is at the end of the register list.
>>>>>
>>>>
>>>> I'm not sure it can happen. It was just a safeguard, but I can remove it if you
>>>> think it's not necessary
>>>
>>> You're not reading back the other registers either, albeit I'd check that
>>> the I2C accesses actually succeed. Generally the return values are ignored.
>>>
>>
>> So you're recommending I perform a random I2C access after power on to check the
>> system, and discard the read value? Or just drop this piece of code entirely?
>>
> 
> I'm not. What I'm saying that you're mostly not checking whether I2C
> accesses succeed or not.
> 


I think I'm understanding what you're saying now. You want me to check more
often the return value from write/read functions?

That makes sense. I'll add more checks to the code

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
