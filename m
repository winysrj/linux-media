Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:42546 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZG1HaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 03:30:04 -0400
Date: Tue, 28 Jul 2009 00:30:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	Andy Walls <awalls@radix.net>
Subject: Re: lsmod path hardcoded in v4l/Makefile
In-Reply-To: <20090727220753.092616bd@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0907280027510.11911@shell2.speakeasy.net>
References: <200906221636.25006.zzam@gentoo.org> <200906230950.26287.zzam@gentoo.org>
 <Pine.LNX.4.58.0906231214360.6411@shell2.speakeasy.net> <200907210914.37819.zzam@gentoo.org>
 <20090727220753.092616bd@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Jul 2009, Mauro Carvalho Chehab wrote:
> Em Tue, 21 Jul 2009 09:14:36 +0200
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> It is not a good idea to run as root. Most people compile everything
> with a normal user and then use "sudo" command to install/remove/insert
> modules. Unfortunately, depending on the distribution, sudo inherits PATH from
> the normal user, instead of root. Due to that, if you replace it for just
> lsmod, it will fail for people that don't use gentoo.
>
> Maybe good solution is to test if lsmod (and other similar tools) are at /sbin
> or /usr/sbin.
>
> Alternatively, we can try to replace lsmod by something like (untested):
>
> v4l_modules := $(shell PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin lsmod|cut -d' ' -f1 ) $(patsubst %.ko,%,$(inst-m))

Check my patch again, we can just delete the v4l_modules line as nothing
uses it.
