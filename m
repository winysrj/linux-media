Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35120 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbbETQqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 12:46:21 -0400
Received: by qkdn188 with SMTP id n188so30779867qkd.2
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 09:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150519203851.GC18036@hardeman.nu>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
	<1427824092-23163-2-git-send-email-a.seppala@gmail.com>
	<20150519203851.GC18036@hardeman.nu>
Date: Wed, 20 May 2015 19:46:21 +0300
Message-ID: <CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
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

On 19 May 2015 at 23:38, David Härdeman <david@hardeman.nu> wrote:
> On Tue, Mar 31, 2015 at 08:48:06PM +0300, Antti Seppälä wrote:
>>From: James Hogan <james@albanarts.com>
>>
>>Add a callback to raw ir handlers for encoding and modulating a scancode
>>to a set of raw events. This could be used for transmit, or for
>>converting a wakeup scancode filter to a form that is more suitable for
>>raw hardware wake up filters.
>>
>>Signed-off-by: James Hogan <james@albanarts.com>
>>Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>>Cc: David Härdeman <david@hardeman.nu>
>>---
>>
>>Notes:
>>    Changes in v3:
>>     - Ported to apply against latest media-tree
>>
>>    Changes in v2:
>>     - Alter encode API to return -ENOBUFS when there isn't enough buffer
>>       space. When this occurs all buffer contents must have been written
>>       with the partial encoding of the scancode. This is to allow drivers
>>       such as nuvoton-cir to provide a shorter buffer and still get a
>>       useful partial encoding for the wakeup pattern.
>>
>> drivers/media/rc/rc-core-priv.h |  2 ++
>> drivers/media/rc/rc-ir-raw.c    | 37 +++++++++++++++++++++++++++++++++++++
>> include/media/rc-core.h         |  3 +++
>> 3 files changed, 42 insertions(+)
>>
>>diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
>>index b68d4f76..122c25f 100644
>>--- a/drivers/media/rc/rc-core-priv.h
>>+++ b/drivers/media/rc/rc-core-priv.h
>>@@ -25,6 +25,8 @@ struct ir_raw_handler {
>>
>>       u64 protocols; /* which are handled by this handler */
>>       int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
>>+      int (*encode)(u64 protocols, const struct rc_scancode_filter *scancode,
>>+                    struct ir_raw_event *events, unsigned int max);
>>
>>       /* These two should only be used by the lirc decoder */
>>       int (*raw_register)(struct rc_dev *dev);
>>diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>>index b732ac6..dd47fe5 100644
>>--- a/drivers/media/rc/rc-ir-raw.c
>>+++ b/drivers/media/rc/rc-ir-raw.c
>>@@ -246,6 +246,43 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type)
>>       return 0;
>> }
>>
>>+/**
>>+ * ir_raw_encode_scancode() - Encode a scancode as raw events
>>+ *
>>+ * @protocols:                permitted protocols
>>+ * @scancode:         scancode filter describing a single scancode
>>+ * @events:           array of raw events to write into
>>+ * @max:              max number of raw events
>>+ *
>>+ * Attempts to encode the scancode as raw events.
>>+ *
>>+ * Returns:   The number of events written.
>>+ *            -ENOBUFS if there isn't enough space in the array to fit the
>>+ *            encoding. In this case all @max events will have been written.
>>+ *            -EINVAL if the scancode is ambiguous or invalid, or if no
>>+ *            compatible encoder was found.
>>+ */
>>+int ir_raw_encode_scancode(u64 protocols,
>
> Why a bitmask of protocols and not a single protocol enum? What's the
> use case for encoding a given scancode according to one out of a number
> of protocols (and not even knowing which one)??
>

I think bitmask was used simply for consistency reasons. Most of the
rc-core handles protocols in a bitmask (u64 protocols or some variant
of it). Especially in the decoders the dev->enabled_protocols is used
to mean "decode any of these protocols but I don't care which one" and
the encoders were written to follow that logic.

>From ir driver point of view it was also kind of nice to use the u64
enabled_wakeup_protocols from struct rc_dev which already exists and
is manipulated with the same sysfs code as the enabled_protocols
bitmask.

-- 
Antti
