Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59169 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1HNBsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 21:48:17 -0400
Received: by bke11 with SMTP id 11so2357424bke.19
        for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 18:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313286189.94904.YahooMailClassic@web121720.mail.ne1.yahoo.com>
References: <4E46FB3C.7060402@iki.fi>
	<1313286189.94904.YahooMailClassic@web121720.mail.ne1.yahoo.com>
Date: Sat, 13 Aug 2011 21:48:14 -0400
Message-ID: <CAGoCfiw0p7jwac94eYM9apUN4Qd8mduteq_xH8ePoyxvO7SNGA@mail.gmail.com>
Subject: Re: PCTV 290e nanostick and remote control support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 13, 2011 at 9:43 PM, Chris Rankin <rankincj@yahoo.com> wrote:
> Hi,
>
> The rc-pinnacle-pctv-hd keymap is missing the definition of the OK key:
>
> --- linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c.orig       2011-08-14 02:42:01.000000000 +0100
> +++ linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c    2011-08-14 02:12:45.000000000 +0100
> @@ -20,6 +20,7 @@
>        { 0x0701, KEY_MENU }, /* Pinnacle logo */
>        { 0x0739, KEY_POWER },
>        { 0x0703, KEY_VOLUMEUP },
> +       { 0x0705, KEY_OK },
>        { 0x0709, KEY_VOLUMEDOWN },
>        { 0x0706, KEY_CHANNELUP },
>        { 0x070c, KEY_CHANNELDOWN },
>
> Cheers,
> Chris

Wow, how the hell did I miss that?  I did numerous remotes for em28xx
based devices that use that RC profile, and never noticed that issue.

Will have to check the merge logs.  Maybe the key got lost when they
refactored the IR support.

Chris, you should add a signed-off-by tag and submit this as a patch
so it can be included upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
