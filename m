Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:49209 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbZFRKTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 06:19:39 -0400
Message-ID: <4A3A14E4.2000301@cam.ac.uk>
Date: Thu, 18 Jun 2009 10:20:20 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: OV7670: getting it working with soc-camera.
References: <4A392E31.4050705@cam.ac.uk> <Pine.LNX.4.64.0906172022570.4218@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906172022570.4218@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 17 Jun 2009, Jonathan Cameron wrote:
> 
>> This is purely for info of anyone else wanting to use the ov7670
>> with Guennadi's recent work on converted soc-camera to v4l2-subdevs.
>>
>> It may not be completely minimal, but it's letting me take pictures ;)
> 
> Cool, I like it! Not the pictures, but the fact that the required patch 
> turned out to be so small. Of course, you understand this is not what 
> we'll eventually commit, but, I think, this is a good start. In principle, 
> if a device has all parameters fixed, there's no merit in trying to set 
> them.
Yup, my intention is to slowly remove elements as they become unnecessary
(and push any that actually make sense to the mailing list).

> 
>> Couple of minor queries:
>>
>> Currently it is assumed that there is a means of telling the chip to
>> use particular bus params.  In the case of this one it doesn't support
>> anything other than 8 bit. Stuff may get added down the line, but
>> in meantime does anyone mind if we make icd->ops->set_bus_param
>> optional in soc-camera?
> 
> struct soc_camera_ops will disappear completely anyway, and we don't know 
> yet what the v4l2-subdev counterpart will look like.
> 
Sure, I'll wait and see whether this question is relevant down the line.

...

>> Or for that matter why the address is right shifted by
>> 1 in:
>>
>> v4l_info(client, "chip found @ 0x%02x (%s)\n",
>> 	 client->addr << 1, client->adapter->name);
>>
>> Admittedly the data sheet uses an 'unusual' convention for the
>> address (separate write and read address which correspond to
>> a single address of 0x21 with the relevant write bit set as
>> appropriate).
> 
> That's exactly the reason, I think. Many (or most?) datasheets specify i2c 
> addresses which are a double of Linux i2c address. IIRC this is just a 
> Linux convention to use the shifted address.

Um. I'm not sure I agree with this.  The convention when specifying the
address in registration is to use correct one (without the write bit)
and based on a lot of non video chips I've come across is about 50 / 50
on how they document it (with many using a delightful and random mix of the two)
If you are going to have a registration scheme that requires the board code
to specify the address as 0x21 then to my mind having the driver declare
it as being on 0x42 seems rather odd and misleading.

This is particularly true here where the driver is using smbus calls as
that specification is very clear indeed on the fact that addresses are 7 bit.
Admittedly this chip uses the sccb bus protocol that just 'happens'
to bare a startling resemblance to smbus / i2c.

Still this isn't exactly a crucial element of the driver!
 
>> As ever any comments welcome. Thanks to Guennadi Liakhovetski
>> for his soc-camera work and Hans Verkuil for conversion of the
>> ov7670 to soc-dev.
>>
>> Tested against a merge of todays v4l-next tree and Linus' current
>> with the minor pxa-camera bug I posted earlier fixed and Guennadi's
>> extensive patch set applied (this requires a few hand merges, but
>> nothing too nasty).
> 
> Good to know.
> 
> A couple of comments:
> 

...
>> +#endif
> 
> ...and this switching. All this should be done in struct soc_camera_link 
> .power() and .reset() methods in your platform code.
Ah, I'd missed those methods, thanks!

You are quite right about the i2c_device_table as well, not sure what
got into me there.

Thanks,

Jonathan
