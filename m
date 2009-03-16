Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4199 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZCPKoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 06:44:25 -0400
Message-ID: <37140.62.70.2.252.1237200252.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Mar 2009 11:44:12 +0100 (CET)
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Sun, 15 Mar 2009 19:53:06 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> On Sunday 15 March 2009 18:28:42 Trent Piepho wrote:
>> > On Sun, 15 Mar 2009, Hans Verkuil wrote:
>> > > On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
>> > > > On Sun, 15 Mar 2009, Hans Verkuil wrote:
>> > > > > Hi Mauro,
>> > > > >
>> > > > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
>
> I'll review it during the week. This will likely take some time, since we
> need
> to be sure that we will not cause any regressions on bttv.

No problem.

> I appreciate if people could try the new driver and give us any feedback
> if
> this works or not, and what boards are confirmed to work.

Please do. I have only one bttv card (Hauppauge WinTV with a msp3400), SO
I cannot test any of the tvaudio and tda7432 devices.

>> > > >
>> > > > It would be a lot easier if you would provide patch descriptions.
>> > >
>> > > Here it is:
>> > >
>> > > - bttv: convert to v4l2_subdev.
>> >
>> > You aren't even trying.  I could easily write two pages on this patch.
>>
>> You are right. Mauro already knew about all this, but since I posted it
>> to
>> linux-media as well I should have given a more detailed explanation.
>
> The better is to add such comments at the first patch of the series.
>
> Since the patches change the user behaviour, it should, by default, work
> with
> the broader range as possible of probing things.
>
> It should also print some warning messages about the use of deprecated
> module
> parameters (instead of just removing a module and causing load and causing
> breakages).

No problem.

>
> We should also provide some sort of documenting that this change happened,
> asking people to report troubles to linux-media@vger.kernel.org.

Will do.

>
>>
>> Here we go:
>>
>> > What new module parameters did you add?
>>
>> tvaudio to override the 'needs_tvaudio' from the card definition.
>
> At least on the first kernel with the new driver, IMO, the default should
> for
> this option should be 1.

I disagree. If you set it to 1 then incorrect card definitions will never
be detected. You have a new tvaudio module option that you can use to
setup the right value and, when used, prints a log message telling the
user to inform the mailinglist about it.

>>
>> > Why?
>>
>> Since just modprobing a module manually will no longer work when the i2c
>> autoprobing mechanism disappears. So you need a method to override it.
>>
>> The main reason for doing this is if the card definition is incorrect.
>>
>> > What module parameters did
>> > you delete?
>>
>> autoload
>>
>> > Why?
>>
>> You will always autoload, so it has become meaningless.
>
>> > How does one translate a existing modprobe.conf file?
>>
>> Remove the autoload option.
>
> If you just remove autoload, depmod/insmod will complain and not load it.
> We
> should keep it with a deprecated warning message instead.
>
> We can keep this warning up to a few kernel releases, to make sure that
> people
> will be aware (like we did in the past with other deprecated modprobe
> functions).
>
> Since we're changing an userspace option, we should document it at the
> features
> to deprecated doc in Kernel.

Will do.

>> > Why are the i2c addresses from various i2c chips moved into the bttv
>> > driver?
>>
>> It is now the adapter driver that tells the i2c core where to probe
>> instead
>> of the other way around. The reason is that it is the adapter driver who
>> has the knowledge where i2c chips are.
>
> This is bad. The I2C address is a property of the i2c adapter, not a
> property
> of the bridge driver. We shouldn't hardcode I2C numbers inside bttv or
> other drivers. Maybe we can just create a .h file for each driver, with
> their
> I2C addresses there... oh well, this will just create more complexity.
>
>>
>> > Doesn't it make more sense that the addresses for chip X should
>> > be in the driver for chip X?
>>
>> I do not want to make too many changes, but when all v4l drivers are
>> converted I will revisit this issue. I'm thinking of adding an inline
>> function like this in the header belonging to each i2c driver (in
>> include/media):
>>
>> static inline const unsigned short *tvaudio_addrs(void)
>> {
>> 	static const unsigned short addrs[] = { ... };
>>
>> 	return addrs;
>> }
>>
>> Then you can use that in the adapter driver. It's only relevant if you
>> do
>> not know the exact address, since it is always better to use that if you
>> know it.
>
> This seems even worse. The problem is not related with a I2C range, but
> with
> the fact that msp3400 were designed by the manufacturer to work at the
> address
> with addresses 0x40 or 0x44. There's no practical way (or reason) for any
> bttv
> vendor to use msp3400 on any other address.
>
> So, the bttv and other adapter should only use either one of those two i2c
> addresses if they're trying to talk with msp3400.

Not sure what your point is. That's exactly what is happening. And as I
stated it is my intention to move the list of possible addresses supported
by an i2c device to the device's header in include/media. But I prefer to
do that *after* all drivers are converted to v4l2_subdev so that I have a
good overview of how the various devices are probed.

If you insist I can do this part first, but I'd really rather do it
afterwards as part of a final cleanup sweep.

>> > How has module loading changed?  Can one no longer *not* autoload
>> modules
>> > if you are trying to test drivers that are not installed in
>> /lib/modules?
>>
>> The adapter driver initiates loading of the i2c modules and probes for
>> and
>> attaches to the i2c devices. Just doing 'modprobe foo' will no longer
>> cause
>> it to attach to any i2c adapter.
>
> I think that Trent's talking about a different issue. Since nobody knows
> what
> boards will be broken by this changeset, and assuming that this can
> happen, it
> is important to have some options for the user to change the behaviour, to
> reproduce what we had before.

That's why I added the tvaudio module option.

>
> So, currently, if you load bttv with:
> 	bttv autoload=0
>
> Any user can just load the drivers he knows that it works with his device,
> avoiding to load other drivers that could cause troubles.
>
> IMO, we should have something like this, to offer as an option. Maybe
> something like:
> 	bttv probe_only_i2c_addresses=0x40,0x48,0x60

As far as I can tell this isn't needed at all and only makes things
complicated for the user. If you really want to go this way, then we
should add an msp3400 and tda7432 option alongside the tvaudio option.
That way you can enable/disable each module that bttv needs. I believe
that there is no need for this since msp3400 already detects whether it
found a msp3400 or not, and tda7432 doesn't conflict with anything as far
as I am aware.

Regards,

      Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

