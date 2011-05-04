Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38330 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1EDPN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 11:13:56 -0400
Received: by gxk21 with SMTP id 21so419320gxk.19
        for <linux-media@vger.kernel.org>; Wed, 04 May 2011 08:13:56 -0700 (PDT)
Message-ID: <4DC16D2D.2080205@gmail.com>
Date: Wed, 04 May 2011 12:13:49 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: Malcolm Priestley <tvboxspy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 00/10] rc-core: my current patchqueue
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <1304021602.3288.5.camel@localhost> <fb1dfe1e7035bbcf648a4bf908a7d1a4@hardeman.nu>
In-Reply-To: <fb1dfe1e7035bbcf648a4bf908a7d1a4@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-04-2011 05:08, David Härdeman escreveu:
> On Thu, 28 Apr 2011 21:13:22 +0100, Malcolm Priestley <tvboxspy@gmail.com>
> wrote:
>> On Thu, 2011-04-28 at 17:13 +0200, David Härdeman wrote:
>>> The following series is what's in my current patch queue for rc-core.
>>>
>>> It only been lightly tested so far and it's based on the "for_v2.6.39"
>>> branch,
>>> but I still wanted to send it to the list so that I can get some
>>> feedback while
>>> I refresh the patches to "for_v2.6.40" and do more testing.
>>
>> Patch [06/10] hasn't made it to gmane or spinics servers.
> 
> Looking through the postfix logs, vger.kernel.org did accept the mail. My
> guess is that it wasn't distributed (or indexed) because of its size.
> 
> I've put patch 6/10 at http://david.hardeman.nu/rc-proto.patch for now,
> and I've included the patch description inline below:

Big patches like that makes harder to comment. So, I'll just get one small
piece of the patch to add my comments.

> Setting and getting keycodes in the input subsystem used to be done via
> the EVIOC[GS]KEYCODE ioctl and "unsigned int[2]" (one int for scancode
> and one for the keycode).
> 
> The interface has now been extended to use the EVIOC[GS]KEYCODE_V2 ioctl
> which uses the following struct:
> 
>         struct input_keymap_entry {
>                 __u8  flags;
>                 __u8  len;
>                 __u16 index;
>                 __u32 keycode;
>                 __u8  scancode[32];
>         };
> 
> (scancode can of course be even bigger, thanks to the len member).
> 
> This patch changes how the "input_keymap_entry" struct is interpreted
> by rc-core by casting it to "rc_keymap_entry":
> 
>         struct rc_scancode {
>                 __u16 protocol;
>                 __u16 reserved[3];
>                 __u64 scancode;
>         }
> 
>         struct rc_keymap_entry {
>                 __u8  flags;
>                 __u8  len;
>                 __u16 index;
>                 __u32 keycode;
>                 union {
>                         struct rc_scancode rc;
>                         __u8 raw[32];
>                 };
>         };
> 
> The u64 scancode member is large enough for all current protocols and it
> would be possible to extend it in the future should it be necessary for
> some exotic protocol.
> 
> The main advantage with this change is that the protocol is made explicit,
> which means that we're not throwing away data (the protocol type) and that
> it'll be easier to support multiple protocols with one decoder (think rc5
> and rc5-streamzap).
> 
> Further down the road we should also have a way to report the protocol of
> a received keypress to userspace.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

<snip/>
>-               rc_keydown(d->rc_dev, priv->rc_keycode, 0);
>+               rc_keydown(d->rc_dev, RC_TYPE_NEC, priv->rc_keycode, 0);


I'm OK with a change like the above, as it allows having some sort of input raw event
to describe the protocol type, helping, for example, to have an userspace program that
will help people to create keytable maps.

<snip/>
> diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
> index 26ca260..2f0ec1f 100644
> --- a/drivers/media/rc/keymaps/rc-videomate-s350.c
> +++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
> @@ -13,57 +13,56 @@
>  #include <media/rc-map.h>
>  
>  static struct rc_map_table videomate_s350[] = {
> -	{ 0x00, KEY_TV},
> -	{ 0x01, KEY_DVD},
> -	{ 0x04, KEY_RECORD},
> -	{ 0x05, KEY_VIDEO},	/* TV/Video */
> -	{ 0x07, KEY_STOP},
> -	{ 0x08, KEY_PLAYPAUSE},
> -	{ 0x0a, KEY_REWIND},
> -	{ 0x0f, KEY_FASTFORWARD},
> -	{ 0x10, KEY_CHANNELUP},
> -	{ 0x12, KEY_VOLUMEUP},
> -	{ 0x13, KEY_CHANNELDOWN},
> -	{ 0x14, KEY_MUTE},
> -	{ 0x15, KEY_VOLUMEDOWN},
> -	{ 0x16, KEY_1},
> -	{ 0x17, KEY_2},
> -	{ 0x18, KEY_3},
> -	{ 0x19, KEY_4},
> -	{ 0x1a, KEY_5},
> -	{ 0x1b, KEY_6},
> -	{ 0x1c, KEY_7},
> -	{ 0x1d, KEY_8},
> -	{ 0x1e, KEY_9},
> -	{ 0x1f, KEY_0},
> -	{ 0x21, KEY_SLEEP},
> -	{ 0x24, KEY_ZOOM},
> -	{ 0x25, KEY_LAST},	/* Recall */
> -	{ 0x26, KEY_SUBTITLE},	/* CC */
> -	{ 0x27, KEY_LANGUAGE},	/* MTS */
> -	{ 0x29, KEY_CHANNEL},	/* SURF */
> -	{ 0x2b, KEY_A},
> -	{ 0x2c, KEY_B},
> -	{ 0x2f, KEY_CAMERA},	/* Snapshot */
> -	{ 0x23, KEY_RADIO},
> -	{ 0x02, KEY_PREVIOUSSONG},
> -	{ 0x06, KEY_NEXTSONG},
> -	{ 0x03, KEY_EPG},
> -	{ 0x09, KEY_SETUP},
> -	{ 0x22, KEY_BACKSPACE},
> -	{ 0x0c, KEY_UP},
> -	{ 0x0e, KEY_DOWN},
> -	{ 0x0b, KEY_LEFT},
> -	{ 0x0d, KEY_RIGHT},
> -	{ 0x11, KEY_ENTER},
> -	{ 0x20, KEY_TEXT},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x00), KEY_TV},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x01), KEY_DVD},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x04), KEY_RECORD},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x05), KEY_VIDEO},	/* TV/Video */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x07), KEY_STOP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x08), KEY_PLAYPAUSE},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0a), KEY_REWIND},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0f), KEY_FASTFORWARD},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x10), KEY_CHANNELUP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x12), KEY_VOLUMEUP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x13), KEY_CHANNELDOWN},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x14), KEY_MUTE},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x15), KEY_VOLUMEDOWN},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x16), KEY_1},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x17), KEY_2},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x18), KEY_3},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x19), KEY_4},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1a), KEY_5},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1b), KEY_6},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1c), KEY_7},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1d), KEY_8},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1e), KEY_9},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x1f), KEY_0},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x21), KEY_SLEEP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x24), KEY_ZOOM},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x25), KEY_LAST},	/* Recall */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x26), KEY_SUBTITLE},	/* CC */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x27), KEY_LANGUAGE},	/* MTS */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x29), KEY_CHANNEL},	/* SURF */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x2b), KEY_A},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x2c), KEY_B},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x2f), KEY_CAMERA},	/* Snapshot */
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x23), KEY_RADIO},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x02), KEY_PREVIOUSSONG},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x06), KEY_NEXTSONG},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x03), KEY_EPG},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x09), KEY_SETUP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x22), KEY_BACKSPACE},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0c), KEY_UP},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0e), KEY_DOWN},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0b), KEY_LEFT},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x0d), KEY_RIGHT},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x11), KEY_ENTER},
> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x20), KEY_TEXT},
>  };

However, changes like the above makes the keymaps confusing and breaks the
v4l-utils sync scripts without a good reason.

A keymap maps one remote. All keys have the same protocol, so it doesn't make
sense to mix the RC_TYPEs inside each key definition.

Before you answer tha above, you may be thinking on showing some some special 
remote type that might have more than one protocol. If this ever happens, 
just create two keymap tables for it. I'm sure that 99% of the remotes 
just use one protocol (except, of course, for Universal remotes, 
but no default keymap table covers this case).

Mauro.
