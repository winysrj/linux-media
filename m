Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2320 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761449AbZDGPZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 11:25:31 -0400
Message-ID: <59280.207.214.87.58.1239117925.squirrel@webmail.xs4all.nl>
Date: Tue, 7 Apr 2009 17:25:25 +0200 (CEST)
Subject: Re: [PATCH 0/3] FM Transmitter driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello again,
>
> On Fri, Apr 03, 2009 at 01:48:21PM +0200, Valentin Eduardo
> (Nokia-D/Helsinki) wrote:
>> On Fri, Apr 03, 2009 at 01:29:27PM +0200, ext Hans Verkuil wrote:
>> > > 2. Split driver into i2c driver (common/tunner?) and media/radio
>> >
>> > Not common/tuner, I think it can just go into media/radio. As long as
>> it is
>> > a stand-alone i2c driver that can be reused.
>>
>> Ok. right.
>
> One question about this split. AFAIU, the split should go as:
> - one i2c driver under media/radio, which handles the i2c device itself
> and
> also registers itself as a v4l2_subdev_tuner of v4l2_subdevice api.
> - another driver under media/radio, which actually registers the
> v4l2_device
> as VFL_TYPE_RADIO and uses the i2c driver through the v4l2_subdev api
> (v4l2_subdev_call ??). In this case, I see this second driver as platform
> driver.
>
> Is that correct ?

Yes, that's correct.

> Any good example of driver which does this?

We do not currently have platform drivers that do that, but you can take a
look at usbvision, which is probably the simplest of the lot when it comes
to this. A more complicated example would be saa7134.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

