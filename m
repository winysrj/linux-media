Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1AXQIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 11:08:48 -0500
Message-ID: <4D3DA40E.8040901@redhat.com>
Date: Mon, 24 Jan 2011 14:08:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/13] [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
References: <cover.1295882104.git.mchehab@redhat.com> <20110124131839.766969d3@pedra> <364852AD-6BC8-40FD-97D0-0BF8AD0DC6C2@wilsonet.com>
In-Reply-To: <364852AD-6BC8-40FD-97D0-0BF8AD0DC6C2@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-01-2011 13:45, Jarod Wilson escreveu:
> On Jan 24, 2011, at 10:18 AM, Mauro Carvalho Chehab wrote:
> 
>> Using xev and testing the "Windows" key on a normal keyboard, it
>> is mapped as KEY_LEFTMETA. So, as this is the standard code for
>> it, use it, instead of a generic, meaningless KEY_PROG1.
> 
> Not sure I agree with this change, or at least, not with using
> KEY_LEFTMETA. The Window MCE key isn't quite analogous to the Windows
> key on a keyboard. Under Windows, I'm pretty sure its a program
> launcher key, that launches (or switches you to) the Windows Media
> Center UI.

If you look from userspace perspective, an application that will use
the media keycodes need to have a proper behaviour for each of the
received keys.

The idea is that each media key should be translated into a X key.
My idea is to add something like:

#define XK_10channelsdown    0xfc00	/* KEY_10CHANNELSDOWN */
#define XK_10channelsup      0xfc01	/* KEY_10CHANNELSUP */
#define XK_Ab                0xfc02	/* KEY_AB */
#define XK_Again             0xfc03	/* KEY_AGAIN */
#define XK_Angle             0xfc04	/* KEY_ANGLE */
#define XK_Audio             0xfc05	/* KEY_AUDIO */
#define XK_Aux               0xfc06	/* KEY_AUX */
...

to /usr/include/X11/keysymdef.h and use those new symbol internals
inside the media userspace applications.

However, for this to work, for each of the used codes, an specific
behavior should be used by the media applications.

If we look on the places that use KEY_PROG1, we have (before this patch series):

$ git grep KEY_PROG1 drivers/media/
drivers/media/dvb/dvb-usb/a800.c: { 0x0201, KEY_PROG1 },       /* SOURCE */
drivers/media/rc/imon.c:  { 0x000000000f00ffeell, KEY_PROG1 }, /* Go */
drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c:  { 0x03, KEY_PROG1 },            /* 1 */
drivers/media/rc/keymaps/rc-avermedia-rm-ks.c:    { 0x0508, KEY_PROG1 },
drivers/media/rc/keymaps/rc-cinergy.c:    { 0x0b, KEY_PROG1 },            /* app */
drivers/media/rc/keymaps/rc-encore-enltv.c:       { 0x53, KEY_PROG1 },            /* teletext */
drivers/media/rc/keymaps/rc-imon-mce.c:   { 0x800ff40d, KEY_PROG1 }, /* Windows MCE button */
drivers/media/rc/keymaps/rc-imon-pad.c:   { 0x2ab195b7, KEY_PROG1 }, /* Go or MultiMon */
drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c:      { 0x0c, KEY_PROG1 },            /* Kworld key */
drivers/media/rc/keymaps/rc-rc6-mce.c:    { 0x800f040d, KEY_PROG1 },              /* Windows MCE button */

By just looking into each comment, is is clear that KEY_PROG1 can
mean different things: Source, Go, function 1, app, teletext, Windows MCE,
"Kworld key".

So, a code like KEY_PROG1 can't be translated into anything useful,
and, even if we create a "XK_Prog1", the translation for Xorg, its
translation inside the applications is not obvious at all. So, we
should really avoid things like that inside the keymaps.

Perhaps using KEY_LEFTMETA is not a good idea to map the Windows MCE
key, but, in this case, we should create another keycode inside evdev
and export it to userspace.

Cheers,
Mauro

