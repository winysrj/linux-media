Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41379 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZGJRJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 13:09:46 -0400
Received: by ewy26 with SMTP id 26so1239753ewy.37
        for <linux-media@vger.kernel.org>; Fri, 10 Jul 2009 10:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A5760FA.6080203@powercraft.nl>
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>
	 <4A4E2B45.8080607@powercraft.nl>
	 <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>
	 <4A572F7E.6010701@iki.fi>
	 <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
	 <4A5760FA.6080203@powercraft.nl>
Date: Fri, 10 Jul 2009 13:09:44 -0400
Message-ID: <829197380907101009h6be6e133rbbda51db2ac91c15@mail.gmail.com>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 10, 2009 at 11:40 AM, Jelle de
Jong<jelledejong@powercraft.nl> wrote:
> Antti if you can fix this issue and help in the future to make some
> signal strength API for application, like w_scan, you can keep the
> Realtek based dvb-t device I sent to you as a gift, some credits for me
> in patches would also be nice since it takes up a lot of time and money
> on my side to :D

I would *really* like to get the strength/SNR situation straightened
out, since it effects all applications, including just the end user's
ability to get some idea of the strength in Kaffeine (something that
should be relatively simple).  I am continuing to brainstorm ideas
some for of solution that won't be considered ridiculous to some
percentage of the demod maintainers.

I did make an effort to credit you for the patches based on your
hardware so far:

http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353/rev/274eda5953b4

> I tolled the mplayer people maybe 5 month's ago about this issue. They
> were quite simple I had 4 devices that worked with mplayer one did not
> the problem was with the device, they did not want to listen to the idea
> something was wrong with there mplayer. If somebody want to convince
> them with this new prove/research please do so, I let it rest.

In fairness, I can appreciate why the mplayer developers' initial
impression would be that this is a device-level problem since the
software works with many other devices.  I did definitely confirm it
to be a bug though, and now that we know *exactly* what is wrong,
getting a fix upstream into mplayer shouldn't be very hard (it should
be a ten line patch).  I cannot possibly see them suggesting that
sending garbage values from the stack in an ioctl() call is
appropriate behavior.  :-)

If you want, do a cvs checkout of the latest mplayer source, get it to
successfully compile and work in your environment, and I will see
about logging in next week to cook up a patch we can submit upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
