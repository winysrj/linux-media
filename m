Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42266 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaLaCQZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 21:16:25 -0500
Date: Wed, 31 Dec 2014 00:16:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Olli Salonen <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvbv5-scan needs which channel file?
Message-ID: <20141231001619.6695d3fb@concha.lan>
In-Reply-To: <20141231001134.64c38344@concha.lan>
References: <54A1B4FD.70006@cogweb.net>
	<CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
	<54A26109.1040109@cogweb.net>
	<CAAZRmGz1Xp9bL+R-sMsHpeuwAJ4aR=Dhu2Hwo-wAqbbFkr1B9w@mail.gmail.com>
	<54A2C971.6090807@cogweb.net>
	<20141231001134.64c38344@concha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Dec 2014 00:11:34 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi David,
> 
> Em Tue, 30 Dec 2014 07:49:05 -0800
> David Liontooth <lionteeth@cogweb.net> escreveu:
> 
> > 
> > OK, perfect; thank you. This should be documented in dvbv5-scan. And we 
> > should have a man page for it.
> 
> This is documented, and there is a man page for it:
> 
> dvbv5-scan(1)                    User Commands                   dvbv5-scan(1)
...

Forgot to mention, but, of course, if you think that the information there
is not enough, feel free to submit patches to improve it ;)

The documentation source file is at:
	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/tree/utils/dvb/dvbv5-scan.1.in

Also, translations for other languages is also welcomed.
-- 

Cheers,
Mauro
