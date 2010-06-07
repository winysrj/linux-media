Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33222 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0FGTpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:45:40 -0400
Received: by vws17 with SMTP id 17so406543vws.19
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 12:45:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100607184434.GA19390@hardeman.nu>
References: <BQCH7Bq3jFB@christoph>
	<4C09482B.8030404@redhat.com>
	<20100607184434.GA19390@hardeman.nu>
Date: Mon, 7 Jun 2010 15:45:38 -0400
Message-ID: <AANLkTinDTJYUgxxJeSZ_jYYZuBXN8jsvkpZILLyc01jb@mail.gmail.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, jarod@redhat.com,
	linux-media@vger.kernel.org, Jon Smirl <jonsmirl@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 7, 2010 at 2:44 PM, David Härdeman <david@hardeman.nu> wrote:
> On Fri, Jun 04, 2010 at 03:38:35PM -0300, Mauro Carvalho Chehab wrote:
>> Em 04-06-2010 12:51, Christoph Bartelmus escreveu:
>> > Hi Mauro,
>> >
>> > on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
>> >> Em 03-06-2010 19:06, Jarod Wilson escreveu:
>> > [...]
>> >>> As for the compat bits... I actually pulled them out of the Fedora kernel
>> >>> and userspace for a while, and there were only a few people who really ran
>> >>> into issues with it, but I think if the new userspace and kernel are rolled
>> >>> out at the same time in a new distro release (i.e., Fedora 14, in our
>> >>> particular case), it should be mostly transparent to users.
>> >
>> >> For sure this will happen on all distros that follows upstream: they'll
>> >> update lirc to fulfill the minimal requirement at Documentation/Changes.
>> >>
>> >> The issue will appear only to people that manually compile kernel and lirc.
>> >> Those users are likely smart enough to upgrade to a newer lirc version if
>> >> they notice a trouble, and to check at the forums.
>> >
>> >>> Christoph
>> >>> wasn't a fan of the change, and actually asked me to revert it, so I'm
>> >>> cc'ing him here for further feedback, but I'm inclined to say that if this
>> >>> is the price we pay to get upstream, so be it.
>> >
>> >> I understand Christoph view, but I think that having to deal with compat
>> >> stuff forever is a high price to pay, as the impact of this change is
>> >> transitory and shouldn't be hard to deal with.
>> >
>> > I'm not against doing this change, but it has to be coordinated between
>> > drivers and user-space.
>> > Just changing lirc.h is not enough. You also have to change all user-space
>> > applications that use the affected ioctls to use the correct types.
>> > That's what Jarod did not address last time so I asked him to revert the
>> > change.
>>
>> For sure coordination between kernel and userspace is very important. I'm sure
>> that Jarod can help with this sync. Also, after having the changes implemented
>> on userspace, I expect one patch from you adding the minimal lirc requirement
>> at Documentation/Changes.
>>
>> > And I'd also like to collect all other change request to the API
>> > if there are any and do all changes in one go.
>>
>> You and Jarod are the most indicated people to point for such needs. Also, Jon
>> and David may have some comments.
>
> David (who has been absent, sorry about that, life got in the way)
> thinks that the lirc raw decoder should implement the minimum amount of
> ioctl's possible while still being usable by the lirc userspace and
> without going beyond being a raw pulse/space "decoder" or we'll risk
> having to extend the entire decoder API just to support the lirc
> compatability decoder.

Thus far, I can get 100% feature-parity w/lirc_mceusb in my ir-core
mceusb driver by adding only 3 tx-specific callbacks to ir_dev_props,
and they're all callbacks (set output mask, set carrier and ir tx
function) that any rc-core native tx solution is also going to need.
On the receive side, zero modifications were made to enable the bridge
driver, outside of the minimal bits to load and register the
"decoder". I definitely don't want to burden {ir,rc}-core with
anything that is lirc-specific. Andy's cx23888 driver seems to have a
whole lot more functionality that it might be desirable to adjust via
userspace than mceusb does, but I think that can still be done w/o any
hooks in the core that are inherently lirc-specific.

For reference, this is the entire diff for what was added to ir-core
to enable tx on the mceusb driver:

http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=commitdiff;h=73d631214ed75003bb73e3303819748b47303fd6

Most of the heavy lifting was done in ir-lirc-codec and mceusb, and
the mceusb parts are all non-lirc-specific (hopefully), and thus ready
to be utilized by a "native" tx solution as well.

> Over time, I hope that rc-core will grow it's own chardev with a clean
> set of ioctls (or sysfs controls, the jury hasn't returned a verdict
> yet). lircd can then be upgraded to support both the in-kernel native
> mode and the legacy lirc mode, and with time, the lirc raw decoder can
> be phased out.

Works for me.

-- 
Jarod Wilson
jarod@wilsonet.com
