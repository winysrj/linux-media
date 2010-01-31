Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55890 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0AaIVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 03:21:54 -0500
Date: Sun, 31 Jan 2010 09:23:39 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: PAC7302 short datasheet from PixArt
Message-ID: <20100131092339.763245b2@tele>
In-Reply-To: <alpine.LNX.2.00.1001301426590.21011@banach.math.auburn.edu>
References: <4B63E053.80609@freemail.hu>
	<alpine.LNX.2.00.1001301426590.21011@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 30 Jan 2010 14:56:56 -0600 (CST)
Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:

> First, I am glad that mouse-copying reproduces the accent in your
> name. If you can help explain how to reproduce such things by typing
> while using apine over an ssh connection, using a standard US
> keyboard, I would be glad of the explanation. My wife is Hungarian,
> and I am thus very sensitized to the importance of the question, how
> to do the accents required for writing Hungarian properly.

Hello Theodore,

I am also using a US keyboard and I have no problem with accents and
utf-8.

You must define the character encoding to 'UTF-8' and the font codeset
to 'Lat2' (central Europe). The locale must be set to 'en_US.UTF-8'.
Eventually, you may use the compose mechanism setting the compose
character to a specific key.

In Debian, this in done at installation time, but it may be changed by
dpkg-reconfigure or by hand.

The character encoding and the font codeset are in the
file /etc/default/console-setup. The locale is defined in the
file /etc/default/locale.

For the keyboard, in X, I set the 'compose' keyboard option to 'rwin',
i.e. the right 'ms-windows' key. This is defined in the
file /etc/default/keyboard or /etc/default/console-setup:
	XKBOPTIONS="compose:rwin"
To insert a composed character, press/release left-rwin, then the accent
and then the character. The compose sequences may be found in the file
/etc/console-setup/compose.ISO-8859-2.inc.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
