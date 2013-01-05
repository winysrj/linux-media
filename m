Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3AEN0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 08:26:49 -0500
Date: Sat, 5 Jan 2013 11:26:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] em28xx: make remote controls of devices with
 external IR IC working again
Message-ID: <20130105112617.79c3c57a@redhat.com>
In-Reply-To: <50E8236C.6070702@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
	<1356649368-5426-4-git-send-email-fschaefer.oss@googlemail.com>
	<20130104191252.4aec9646@redhat.com>
	<50E8236C.6070702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 05 Jan 2013 13:58:20 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2013 22:12, schrieb Mauro Carvalho Chehab:
> > Em Fri, 28 Dec 2012 00:02:45 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Tested with device "Terratec Cinergy 200 USB".
> > Sorry, but this patch is completely wrong ;)
> 
> Completely wrong ? That's not helpful...
> Please elaborate a bit more on this so that I can do things right next
> time. ;)

Sorry, I was too busy yesterday with the tests to elaborate it more.

In general, big patches like that to fix bug fixes are generally wrong:
they touch on a lot of the code and it is hard to be sure that it doesn't
come with regressions on it.

In this particular case, it was:
	- mixing bug fixes with some other random stuff;
	- moving only one part of the IR needed data elsewhere (it were
	  moving the IR tables, to the board descriptions, keeping them on
	  a separate part of the code, obfuscating the code);
	- putting a large amount of the code inside an if, increasing the
	  driver's complexity with no need;
	- initializing some data for IR that are never used, at em28xx_ir_init;
	- not fixing the snapshot button.

The bug fix was as simple as:
	1) move snapshot button register to happen before IR;
	2) move I2C init to happen before the em2860/2874 IR init.

See:
	http://git.linuxtv.org/media_tree.git/commitdiff/8303dc9952758ab3060a3ee9a19ecb6fec83c600

That's simple to review, and the produced patch can be accepted later at
stable, because it is not a code rewrite.

Of course, if we backport this to -stable, this one is also recommended:
	http://git.linuxtv.org/media_tree.git/commitdiff/728f9778e273a11a65926ac21574e6ca8d911ebf

in order to autoload the RC extension automatically for I2C IR's, but this
is a separate bug.

Btw, I really prefer to have the RC tables for the I2C devices inside
em28xx-input, as:

	1) there are other board-specific platform_data that needed to
	   be filled for the IR to work there;

	2) we want to keep all those platform_data initialization together,
	   to make the code simpler to maintain;

	3) moving all those data to em28xx cards struct is a bad idea, as
	   newer em28xx won't use I2C IR's, as the new chipsets have already
	   its own IR decoder. Moving those 4-5 fields to the board struct
	   would increase its size for every board. So, it would be a waste
	   of space.

Regards,
Mauro
