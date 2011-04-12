Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab1DLVT6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 17:19:58 -0400
Message-ID: <4DA4C204.8030007@redhat.com>
Date: Tue, 12 Apr 2011 17:20:04 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] input: add KEY_IMAGES specifically for AL Image Browser
References: <1302639557-22186-1-git-send-email-jarod@redhat.com> <8a21a9ac-79dd-4991-a059-693dde77f11c@email.android.com> <4DA4BD85.8010303@redhat.com> <20110412210931.GA30410@core.coreip.homeip.net>
In-Reply-To: <20110412210931.GA30410@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dmitry Torokhov wrote:
> On Tuesday, April 12, 2011 02:00:53 PM Jarod Wilson wrote:
>> Andy Walls wrote:
>>> Jarod Wilson<jarod@redhat.com>   wrote:
>>>> Many media center remotes have buttons intended for jumping straight
>>>> to one type of media browser or another -- commonly,
>>>> images/photos/pictures,
>>>> audio/music, television, and movies. At present, remotes with an
>>>> images or photos or pictures button use any number of different
>>>> keycodes which sort of maybe fit. I've seen at least KEY_MEDIA,
>>>> KEY_CAMERA, KEY_GRAPHICSEDITOR and KEY_PRESENTATION. None of those
>>>> seem quite right.
>>>> In my mind, KEY_MEDIA should be something more like a media center
>>>> application launcher (and I'd like to standardize on that for things
>>>> like the windows media center button on the mce remotes). KEY_CAMERA
>>>> is used in a lot of webcams, and typically means "take a picture
>>>> now". KEY_GRAPHICSEDITOR implies an editor, not a browser.
>>>> KEY_PRESENTATION might be the closest fit here, if you think "photo
>>>> slide show", but it may well be more intended for "run application
>>>> in full-screen presentation mode" or to launch something like
>>>> magicpoint, I dunno. And thus, I'd like to have a KEY_IMAGES, which
>>>> matches the HID Usage AL Image Browser, the meaning of which I think
>>>> is crystal-clear. I believe AL Audio Browser is already covered by
>>>> KEY_AUDIO, and AL Movie Browser by KEY_VIDEO, so I'm also adding
>>>> appropriate comments next to those keys.
>>>>
>>>> I have follow-on patches for drivers/hid/hid-input.c and for
>>>> drivers/media/rc/* that make use of this new key, if its deemed
>>>> appropriate for addition. To make it simpler to merge the additional
>>>> patches, it would be nice if this could sneak into 2.6.39, and the
>>>> rest can then get queued up for 2.6.40, avoiding any multi-tree
>>>> integration headaches.
>>>>
>>>> CC: Dmitry Torokhov<dmitry.torokhov@gmail.com>
>>>> CC: Jiri Kosina<jkosina@suse.cz>
>>>> CC: Linux Media<linux-media@vger.kernel.org>
>>>> Signed-off-by: Jarod Wilson<jarod@redhat.com>
>>>> ---
>>>> include/linux/input.h |    5 +++--
>>>> 1 files changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/input.h b/include/linux/input.h
>>>> index e428382..be082e9 100644
>>>> --- a/include/linux/input.h
>>>> +++ b/include/linux/input.h
>>>> @@ -553,8 +553,8 @@ struct input_keymap_entry {
>>>> #define KEY_DVD			0x185	/* Media Select DVD */
>>>> #define KEY_AUX			0x186
>>>> #define KEY_MP3			0x187
>>>> -#define KEY_AUDIO		0x188
>>>> -#define KEY_VIDEO		0x189
>>>> +#define KEY_AUDIO		0x188	/* AL Audio Browser */
>>>> +#define KEY_VIDEO		0x189	/* AL Movie Browser */
>>>> #define KEY_DIRECTORY		0x18a
>>>> #define KEY_LIST		0x18b
>>>> #define KEY_MEMO		0x18c	/* Media Select Messages */
>>>> @@ -605,6 +605,7 @@ struct input_keymap_entry {
>>>> #define KEY_MEDIA_REPEAT	0x1b7	/* Consumer - transport control */
>>>> #define KEY_10CHANNELSUP        0x1b8   /* 10 channels up (10+) */
>>>> #define KEY_10CHANNELSDOWN      0x1b9   /* 10 channels down (10-) */
>>>> +#define KEY_IMAGES		0x1ba	/* AL Image Browser */
>>>>
>>>> #define KEY_DEL_EOL		0x1c0
>>>> #define KEY_DEL_EOS		0x1c1
>>>> --
>>>> 1.7.1
>>>>
>>> Maybe "Launch" instead of "AL" in the comments.  It took me a while to
>>> figure out AL even with the email context.
>> Ah, yes, that's an HID Usage Table-ism, short for "Application Launch".
>> The comment text is taken straight from the HUT's Usage Name column, on
>> page 80 of HUT v1.12, and matches a fair number of other comments in
>> input.h. It wasn't until I started reading the HUT doc that many of the
>> comments next to keys actually started making sense... :)
>>
>> So I'm fine with either "AL" or "Launch", but if we opt for the latter,
>> it might be good to change the rest of the comments to match.
>
> Somewhere above in input.h we have:
>
> /*
>   * Keys and buttons
>   *
>   * Most of the keys/buttons are modeled after USB HUT 1.12
>   * (see http://www.usb.org/developers/hidpage).
>   * Abbreviations in the comments:
>   * AC - Application Control
>   * AL - Application Launch Button
>   * SC - System Control
>   */
>
> Thanks.

D'oh. Okay, yeah, I have vague recollections of seeing that before, and 
its probably what got me looking at the USB HUT in the first place... 
Apologies for the implication the maintainer hadn't documented it. ;)

So, with that in mind, I think just "AL" is indeed appropriate.

-- 
Jarod Wilson
jarod@redhat.com


