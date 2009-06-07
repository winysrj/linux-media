Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f177.google.com ([209.85.221.177]:61196 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZFGNZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 09:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <200906070835.46989.hverkuil@xs4all.nl>
References: <200906061500.49338.hverkuil@xs4all.nl>
	 <9e4733910906061520o7b0b2858wf4530cf672b1adc9@mail.gmail.com>
	 <200906070835.46989.hverkuil@xs4all.nl>
Date: Sun, 7 Jun 2009 09:25:11 -0400
Message-ID: <9e4733910906070625i74477c9ma422b061eb61449d@mail.gmail.com>
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address lists
	on the fly
From: Jon Smirl <jonsmirl@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 7, 2009 at 2:35 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Sunday 07 June 2009 00:20:26 Jon Smirl wrote:
>> On Sat, Jun 6, 2009 at 9:00 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
>> > Hi all,
>> >
>> > For video4linux we sometimes need to probe for a single i2c address.
>> > Normally you would do it like this:
>>
>> Why does video4linux need to probe to find i2c devices? Can't the
>> address be determined by knowing the PCI ID of the board?
>
> There are two reasons we need to probe: it is either because when the board
> was added no one bothered to record which chip was on what address (this
> happened in particular with old drivers like bttv) or because there is
> simply no other way to determine the presence or absence of an i2c device.

Unrecorded boards could be handled by adding a printk at driver init
time asking people to email you the needed information. Then remove
the printks as soon as you get the answer.

>
> E.g. there are three versions of one card: without upd64083 (Y/C separation
> device) and upd64031a (ghost reduction device), with only the upd64031a and
> one with both. Since they all have the same PCI ID the only way to
> determine the model is to probe.

Did they happen to change the subsystem device_id? There are two pairs
of PCI IDs on each card. Most of the time the subsystem vendor/device
isn't set.

Getting rid of the probes altogether is the most reliable solution.
There is probably a way to identify these boards more specifically
that you haven't discovered yet.  PCI subsystem device ID is worth
checking.

>
> Regards,
>
>        Hans
>
>>
>> > static const unsigned short addrs[] = {
>> >        addr, I2C_CLIENT_END
>> > };
>> >
>> > client = i2c_new_probed_device(adapter, &info, addrs);
>> >
>> > This is a bit awkward and I came up with this macro:
>> >
>> > #define V4L2_I2C_ADDRS(addr, addrs...) \
>> >        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
>> >
>> > This can construct a list of one or more i2c addresses on the fly. But
>> > this is something that really belongs in i2c.h, renamed to I2C_ADDRS.
>> >
>> > With this macro we can just do:
>> >
>> > client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
>> >
>> > Comments?
>> >
>> > Regards,
>> >
>> >        Hans
>> >
>> > --
>> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>



-- 
Jon Smirl
jonsmirl@gmail.com
