Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab1AZNJB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 08:09:01 -0500
Message-ID: <4D401CC5.4020000@redhat.com>
Date: Wed, 26 Jan 2011 14:08:21 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mark Lord <kernel@teksavvy.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com>
In-Reply-To: <4D4004F9.6090200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

   Hi,

> Btw, I took some time to take analyse the input-kbd stuff.
> As said at the README:
>
> 	This is a small collection of input layer utilities.  I wrote them
> 	mainly for testing and debugging, but maybe others find them useful
> 	too :-)
> 	...
> 	Gerd Knorr<kraxel@bytesex.org>  [SUSE Labs]
>
> This is an old testing tool written by Gerd Hoffmann probably used for him
> to test the V4L early Remote Controller implementations.

Indeed.

> The last "official" version seems to be this one:
> 	http://dl.bytesex.org/cvs-snapshots/input-20081014-101501.tar.gz

Just moved the bits to git a few days ago.
http://bigendian.kraxel.org/cgit/input/

Code is unchanged since 2008 though.

> Gerd, if you're still maintaining it, it is a good idea to apply Dmitry's
> patch:
> 	http://www.spinics.net/lists/linux-input/msg13728.html

Hmm, doesn't apply cleanly ...

cheers,
   Gerd
