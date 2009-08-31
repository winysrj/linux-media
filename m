Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZHaCSb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 22:18:31 -0400
Date: Sun, 30 Aug 2009 23:18:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Shine Liu <shinel@foxmail.com>
Cc: dougsland@redhat.com, dheitmueller@kernellabs.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [Updated] em28xx: Add entry for GADMEI UTV330+ and
 related IR keymap
Message-ID: <20090830231823.0156f3bc@pedra.chehab.org>
In-Reply-To: <1251648356.1388.33.camel@sl>
References: <1251647815.1388.28.camel@sl>
	<1251648356.1388.33.camel@sl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2009 00:05:56 +0800
Shine Liu <shinel@foxmail.com> escreveu:

> On Sun, 2009-08-30 at 23:56 +0800, Shine Liu wrote:
> > Several days ago, I posted a patch named "em28xx: Add entry for GADMEI
> > UTV330+ and related IR codec" and this patch has been merged into
> > http://linuxtv.org/hg/~dougsland/v4l-dvb/rev/93337af98bcb but not
> > included in Mauro's tree yet.
> > 
> > The patch added a section in ir-keymap which can be used by GADMEI 3xx
> > series cards. But it includes some KEY_[A-Z] keys known by Tvtime. I
> > updated this patch to use the standard media key definition recommanded
> > by Mauro.

It were still using a few wrong key bindings. I fixed it and applied the patch.

That's said, maybe we need a patch to tvtime and other applications that don't
accept some keys, like channel up/down and key_power2.

Cheers,
Mauro
