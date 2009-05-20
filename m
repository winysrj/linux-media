Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZETEGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 00:06:42 -0400
Date: Wed, 20 May 2009 01:06:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	Uri Shkolnik <urishk@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Recent Siano patches - testing required
Message-ID: <20090520010637.13258606@pedra.chehab.org>
In-Reply-To: <829197380905191905s4e65915kc0c37429b2cd0ebe@mail.gmail.com>
References: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
	<4A132502.6070103@kernellabs.com>
	<20090519223510.6667dca9@pedra.chehab.org>
	<829197380905191905s4e65915kc0c37429b2cd0ebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2009 22:05:19 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> It's not clear to me why you are putting this code that is untested by
> the community into the v4l-dvb tree.  In all other cases where linuxtv
> developers want to submit large sets of changes, you expect them to
> create a private tree so testers can be solicited *before* it goes
> into v4l-dvb.  Why would this case be any different?

Because it was the way we've indicated to Uri for submitting his patches:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg00473.html

We may change it for the next patch series, but I'll pick the good patches from
this series via patchwork.

Cheers,
Mauro

