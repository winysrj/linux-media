Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63483 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1AXTKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 14:10:48 -0500
Received: by vws16 with SMTP id 16so1973748vws.19
        for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 11:10:47 -0800 (PST)
References: <cover.1295882104.git.mchehab@redhat.com> <20110124131839.766969d3@pedra> <364852AD-6BC8-40FD-97D0-0BF8AD0DC6C2@wilsonet.com> <4D3DA40E.8040901@redhat.com>
In-Reply-To: <4D3DA40E.8040901@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <20F4E9B6-7771-4E11-907A-6F5B0B79E1A4@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 04/13] [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
Date: Mon, 24 Jan 2011 14:11:00 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 24, 2011, at 11:08 AM, Mauro Carvalho Chehab wrote:

> Em 24-01-2011 13:45, Jarod Wilson escreveu:
>> On Jan 24, 2011, at 10:18 AM, Mauro Carvalho Chehab wrote:
>> 
>>> Using xev and testing the "Windows" key on a normal keyboard, it
>>> is mapped as KEY_LEFTMETA. So, as this is the standard code for
>>> it, use it, instead of a generic, meaningless KEY_PROG1.
>> 
>> Not sure I agree with this change, or at least, not with using
>> KEY_LEFTMETA. The Window MCE key isn't quite analogous to the Windows
>> key on a keyboard. Under Windows, I'm pretty sure its a program
>> launcher key, that launches (or switches you to) the Windows Media
>> Center UI.
> 
> If you look from userspace perspective, an application that will use
> the media keycodes need to have a proper behaviour for each of the
> received keys.
> 
> The idea is that each media key should be translated into a X key.
> My idea is to add something like:
> 
> #define XK_10channelsdown    0xfc00	/* KEY_10CHANNELSDOWN */
> #define XK_10channelsup      0xfc01	/* KEY_10CHANNELSUP */
> #define XK_Ab                0xfc02	/* KEY_AB */
> #define XK_Again             0xfc03	/* KEY_AGAIN */
> #define XK_Angle             0xfc04	/* KEY_ANGLE */
> #define XK_Audio             0xfc05	/* KEY_AUDIO */
> #define XK_Aux               0xfc06	/* KEY_AUX */
> ...
> 
> to /usr/include/X11/keysymdef.h and use those new symbol internals
> inside the media userspace applications.
> 
> However, for this to work, for each of the used codes, an specific
> behavior should be used by the media applications.
> 
> If we look on the places that use KEY_PROG1, we have (before this patch series):
...
> So, a code like KEY_PROG1 can't be translated into anything useful,
> and, even if we create a "XK_Prog1", the translation for Xorg, its
> translation inside the applications is not obvious at all. So, we
> should really avoid things like that inside the keymaps.
> 
> Perhaps using KEY_LEFTMETA is not a good idea to map the Windows MCE
> key, but, in this case, we should create another keycode inside evdev
> and export it to userspace.

As discussed on irc, KEY_MEDIA seems like the best answer. There's
something in the mce keymap already mapped to KEY_MEDIA, but I don't
seem to have that key on either of the mce remotes I have handy at
the moment, so its probably on one of the less common remotes... We
can change that key's mapping at a later date, if someone wants to
use that button for something different than the green button.

-- 
Jarod Wilson
jarod@wilsonet.com



