Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:35875 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbZAVMjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 07:39:45 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 00E93D48196
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 13:39:38 +0100 (CET)
Received: from localhost (lns-bzn-54-82-251-88-81.adsl.proxad.net [82.251.88.81])
	by smtp5-g21.free.fr (Postfix) with ESMTP id F38D5D4815C
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 13:39:35 +0100 (CET)
Date: Thu, 22 Jan 2009 13:33:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca_spca505
Message-ID: <20090122133321.51445189@free.fr>
In-Reply-To: <49779CA2.8050608@vzwmail.net>
References: <49779CA2.8050608@vzwmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Jan 2009 15:07:30 -0700
"T.P. Reitzel" <4066724035@vzwmail.net> wrote:

> OK, I've raised the level of debug to 15 as you requested.

I found no interesting information in your traces: the debug level is
too low and there is only the probe sequence. Please, may you do,
as root:

	echo 0x3f > /sys/modules/gspca_main/parameters/debug

then, as user, run:

	svv -rg

then, as root again, do:

	grep spca /var/log/kern.log > spca.log

and send me the file 'spca.log'? Thank you.

I may have found a problem. May you try to change the line 399 of
linux/drivers/media/gspca/spca505.c from:

	#define initial_brightness 0x7f /* 0x0(white)-0xff(black) */
to:
	#define initial_brightness 0 /* 0x0(white)-0xff(black) */

BTW, your email address ("T.P. Reitzel" <4066724035@vzwmail.net>) is not
correct. Please, may you fix it before posting again?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
