Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:45743 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0AKIHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 03:07:49 -0500
Date: Mon, 11 Jan 2010 09:09:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	=?UTF-8?B?U3Q=?= =?UTF-8?B?w6lwaGFuZQ==?= Marguet
	<smarguet@gmail.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_pac7302: sporatdic problem when plugging the device
Message-ID: <20100111090900.731c50a0@tele>
In-Reply-To: <4B4A386D.3080106@freemail.hu>
References: <4B4A0752.6030306@freemail.hu>
	<20100110204844.770f8fd7@tele>
	<4B4A386D.3080106@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 10 Jan 2010 21:28:29 +0100
Németh Márton <nm127@freemail.hu> wrote:

> I tested the behaviour a little bit more. Out of 100 plug-ins:
> 
> OK: 81 times
> "pac7302: reg_w_page(): Failed to write register to index 0x49, value
> 0x0, error -71": 19 times
> 
> Other error message I haven't got, so 19% of the time writing to
> register index 0x49 fails in reg_w_page(). So let's try doing fixing
> the way you described. If you send me a patch I can test it.

In some usbsnoop files I have, the index 0x48 is not loaded. May you
try the attached patch (skip the index 0x48 and remove the delay).

(Stéphane, est-ce que tu peux voir aussi ce que ça donne chez toi?)

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
