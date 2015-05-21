Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35651 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbbEUHxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 03:53:48 -0400
Received: by qceb3 with SMTP id b3so33812658qce.2
        for <linux-media@vger.kernel.org>; Thu, 21 May 2015 00:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150520204557.GB15223@hardeman.nu>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
	<1427824092-23163-2-git-send-email-a.seppala@gmail.com>
	<20150519203851.GC18036@hardeman.nu>
	<CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
	<20150520182901.GB13624@hardeman.nu>
	<CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
	<20150520204557.GB15223@hardeman.nu>
Date: Thu, 21 May 2015 10:53:47 +0300
Message-ID: <CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 May 2015 at 23:45, David Härdeman <david@hardeman.nu> wrote:
> On Wed, May 20, 2015 at 10:26:54PM +0300, Antti Seppälä wrote:
>>On 20 May 2015 at 21:29, David Härdeman <david@hardeman.nu> wrote:
>>> On Wed, May 20, 2015 at 07:46:21PM +0300, Antti Seppälä wrote:
>>>>On 19 May 2015 at 23:38, David Härdeman <david@hardeman.nu> wrote:
>>>>> On Tue, Mar 31, 2015 at 08:48:06PM +0300, Antti Seppälä wrote:
>>>>>>From: James Hogan <james@albanarts.com>
>>>>>>
>>>>>>Add a callback to raw ir handlers for encoding and modulating a scancode
>>>>>>to a set of raw events. This could be used for transmit, or for
>>>>>>converting a wakeup scancode filter to a form that is more suitable for
>>>>>>raw hardware wake up filters.
>>>>>>
>>>>>>Signed-off-by: James Hogan <james@albanarts.com>
>>>>>>Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>>>>>>Cc: David Härdeman <david@hardeman.nu>
>>>>>>---
>>>>>>
>>>>>>Notes:
>>>>>>    Changes in v3:
>>>>>>     - Ported to apply against latest media-tree
>>>>>>
>>>>>>    Changes in v2:
>>>>>>     - Alter encode API to return -ENOBUFS when there isn't enough buffer
>>>>>>       space. When this occurs all buffer contents must have been written
>>>>>>       with the partial encoding of the scancode. This is to allow drivers
>>>>>>       such as nuvoton-cir to provide a shorter buffer and still get a
>>>>>>       useful partial encoding for the wakeup pattern.
>>>>>>
>>>>>> drivers/media/rc/rc-core-priv.h |  2 ++
>>>>>> drivers/media/rc/rc-ir-raw.c    | 37 +++++++++++++++++++++++++++++++++++++
>>>>>> include/media/rc-core.h         |  3 +++
>>>>>> 3 files changed, 42 insertions(+)
>>>>>>
>>>>>>diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
>>>>>>index b68d4f76..122c25f 100644
>>>>>>--- a/drivers/media/rc/rc-core-priv.h
>>>>>>+++ b/drivers/media/rc/rc-core-priv.h
>>>>>>@@ -25,6 +25,8 @@ struct ir_raw_handler {
>>>>>>
>>>>>>       u64 protocols; /* which are handled by this handler */
>>>>>>       int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
>>>>>>+      int (*encode)(u64 protocols, const struct rc_scancode_filter *scancode,
>>>>>>+                    struct ir_raw_event *events, unsigned int max);
>>>>>>
>>>>>>       /* These two should only be used by the lirc decoder */
>>>>>>       int (*raw_register)(struct rc_dev *dev);
>>>>>>diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>>>>>>index b732ac6..dd47fe5 100644
>>>>>>--- a/drivers/media/rc/rc-ir-raw.c
>>>>>>+++ b/drivers/media/rc/rc-ir-raw.c
>>>>>>@@ -246,6 +246,43 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
>>>>>>       return 0;
>>>>>> }
>>>>>>
>>>>>>+/**
>>>>>>+ * ir_raw_encode_scancode() - Encode a scancode as raw events
>>>>>>+ *
>>>>>>+ * @protocols:                permitted protocols
>>>>>>+ * @scancode:         scancode filter describing a single scancode
>>>>>>+ * @events:           array of raw events to write into
>>>>>>+ * @max:              max number of raw events
>>>>>>+ *
>>>>>>+ * Attempts to encode the scancode as raw events.
>>>>>>+ *
>>>>>>+ * Returns:   The number of events written.
>>>>>>+ *            -ENOBUFS if there isn't enough space in the array to fit the
>>>>>>+ *            encoding. In this case all @max events will have been written.
>>>>>>+ *            -EINVAL if the scancode is ambiguous or invalid, or if no
>>>>>>+ *            compatible encoder was found.
>>>>>>+ */
>>>>>>+int ir_raw_encode_scancode(u64 protocols,
>>>>>
>>>>> Why a bitmask of protocols and not a single protocol enum? What's the
>>>>> use case for encoding a given scancode according to one out of a number
>>>>> of protocols (and not even knowing which one)??
>>>>>
>>>>
>>>>I think bitmask was used simply for consistency reasons. Most of the
>>>>rc-core handles protocols in a bitmask (u64 protocols or some variant
>>>>of it).
>>>
>>> Yes, all the parts where multiple protocols make sense use a bitmap of
>>> protocols. If there's any part which uses a bitmap where only one
>>> protocol makes sense that'd be a bug...
>>>
>>>>Especially in the decoders the dev->enabled_protocols is used
>>>>to mean "decode any of these protocols but I don't care which one" and
>>>>the encoders were written to follow that logic.
>>>
>>> The fact that you might want to be able to receive and decode more than
>>> one protocol has no bearing on encoding when you're supposed to know
>>> what it is you want to encode....
>>>
>>> >From ir driver point of view it was also kind of nice to use the u64
>>>>enabled_wakeup_protocols from struct rc_dev which already exists and
>>>>is manipulated with the same sysfs code as the enabled_protocols
>>>>bitmask.
>>>
>>> But it makes no sense? "here's a scancode...I have no idea what it means
>>> since only knowing the protocol allows you to make any sense of the
>>> scancode...but please encode it to something...anything...."
>>>
>>
>>Well it made sense from code simplicity point of view :)
>>
>>But yes current use cases will most likely be valid when encoding only
>>to a single specific protocol at a time. However having a flexible api
>>allows for future expansion though if a new use case is needed to be
>>supported. And like I said earlier using bitmask is also consistent
>>with what rc-core already has.
>
> * drivers/media/rc/img-ir/img-ir-hw.c
> only seems to support one protocol at a time
>
> * drivers/media/rc/rc-loopback.c
> doesn't care
>
> * drivers/media/rc/winbond-cir.c
> seems hardware-wise very similar to nuvoton-cir.c, was not converted to
> use the in-kernel encoders...has a private implementation
>
> * drivers/media/rc/nuvoton-cir.c
> is actually protocol agnostic but with your code it will encode
> according to a randomly chosen protocol among the enabled ones, one that
> will change depending on *module load order*...so unless I'm mistaken
> you'll actually get different pulse/space timings written to hardware
> depending on the order in which certain kernel modules have been
> loaded...
>
> Do you see why this is a bad idea?
>

I see that this is not optimal to leave the proper usage up to the
user but in a way we must work with what we have. See below:

>>That being said I don't object if you wish to propose a patch to
>>refactor the bitmask to be an enumeration instead.
>
> Ehrm...I propose the patches be reverted until they're fixed.
>

Reverting the patch series will not fix what I think you consider
broken. The series has very little to do with the sysfs api for wakeup
protocols that is already in place and which makes drivers (or
encoders) behave in a certain way.

I'm talking about the /sys/class/rc/<rc-device>/wakeup_protocols file
that was included around kernel 3.15 and is being already used by at
least img-ir driver regardless of whether support for encoding ir
scancodes is included or not. The wakeup_protocols allows user to
select multiple protocols because it works in a similar fashion to
protocols file.

I think that you would like to introduce a change to the behavior of
this file to only allow selecting single protocol at a time and
error-out if multiple protocols are enabled but this would break an
existing api to userspace which we are really not allowed to do.

And unless I'm mistaken even if we decided to change the behavior of
the wakeup_protcols file that change would have nothing to do with
this ir-encoding patch series (besides allowing usage of enumerations
instead of bitmasks).

-- 
Antti
