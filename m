Return-path: <linux-media-owner@vger.kernel.org>
Received: from bbrack.org ([66.126.51.1]:56964 "EHLO bbrack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZCAA1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 19:27:39 -0500
Received: from delightful.com.hk (localhost.localdomain [127.0.0.1])
	by bbrack.org (8.14.3/8.14.2) with ESMTP id n210RbPw019699
	for <linux-media@vger.kernel.org>; Sat, 28 Feb 2009 16:27:37 -0800
Message-ID: <a54178087de59b2009b1c830e85b2002.squirrel@delightful.com.hk>
In-Reply-To: <1235864596.3072.53.camel@palomino.walls.org>
References: <be2acbfe1fc9d8501a1ec47397077168.squirrel@delightful.com.hk>
    <200903010001.12081.hverkuil@xs4all.nl>
    <1235864596.3072.53.camel@palomino.walls.org>
Date: Sat, 28 Feb 2009 16:27:37 -0800 (PST)
Subject: Re: Recommendation for good example i2c driver code
From: "William M. Brack" <wbrack@mmm.com.hk>
To: "Linux Media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2009-03-01 at 00:01 +0100, Hans Verkuil wrote:
>> On Saturday 28 February 2009 23:18:54 William M. Brack wrote:
>> > When writing a new driver, which existing driver would be a good
>> model
>> > to use for handing the i2c bus?
>>
>> Hi Bill,
>>
>> I recommend reading Documents/video4linux/v4l2-framework.txt. It's
>> not clear
>> from your question whether you want an example driver for an i2c
>> device, or
>> an example for how to use i2c devices in an PCI or USB driver.
>>
>> A simple, but decent example source for the first would be wm8739.c
>> and for
>> the second we have saa7134 or cx18.
>>
>> It's a bit in flux at the moment since we are moving all drivers
>> over to the
>> v4l2_device/v4l2_subdev structure, but some still use the old model.
>
> Bill,
>
> Your question also did not specify if this was a driver for an analog
> (V4L2) or DTV (DVB) capture unit.  Hans' comments regarding
> v4l2_device/v4l2_subdev currently only apply to analog capture units
> or
> the analog side of hybrid capture units.  If you have a DTV-only
> capture
> unit, the v4l2_device/v4l2_subdevice framework doesn't apply at
> present.
>
> AFAICT, the saa7134 and cx18 drivers both have code to deal with
> hybrid
> analog/DTV units.
>
> Regards,
> Andy
>
>> Regards,
>>
>> 	Hans

Sorry about my lack of clarity - I'm working on a driver to support
the (analog) TW6800-series chips for v4l2.  I've got most of the video
working, using the cx88 driver as a model, and now want to add in i2c
and vbi before asking for overall review by list members.  I'll review
v4l2-framework.txt, and read through applicable saa7134 and cx18 code.

Thanks,
Bill

