Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:49639 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbZI2X0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 19:26:49 -0400
Subject: Re: [2.6.31] ir-kbd-i2c oops.
From: Hermann Pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <20090929161629.2a5c8d30@hyperion.delvare>
References: <200909160300.28382.pluto@agmk.net>
	 <20090916085701.6e883600@hyperion.delvare>
	 <200909161003.33090.pluto@agmk.net>
	 <20090929161629.2a5c8d30@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 01:26:23 +0200
Message-Id: <1254266783.2657.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Dienstag, den 29.09.2009, 16:16 +0200 schrieb Jean Delvare:
> On Wed, 16 Sep 2009 10:03:32 +0200, Paweł Sikora wrote:
> > On Wednesday 16 September 2009 08:57:01 Jean Delvare wrote:
> > > Hi Pawel,
> > > 
> > > I think this would be fixed by the following patch:
> > > http://patchwork.kernel.org/patch/45707/
> > 
> > still oopses. this time i've attached full dmesg.
> 
> Any news on this? Do you have a refined list of kernels which have the
> bug and kernels which do not? Tried 2.6.32-rc1? Tried the v4l-dvb
> repository?
> 
> Anyone else seeing this bug?

I can see you ask the other way round, but just in case, I don't have
that bug neither on some self compiled 2.6.30 with recent mercurial
v4l-dvb on some outdated Fedora nor on a 

Linux localhost.localdomain 2.6.30.5-43.fc11.x86_64 #1 SMP Thu Aug 27
21:39:52 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux

with my recently purchased older Pinnacle 310i.

Hm, there are different versions of that card, to have it mentioned,
obviously also with different remotes, and I can't tell how to identify
them.

> Your kernel stack trace doesn't look terribly reliable and I am not
> able to come to any conclusion. The crash is supposed to happen in
> ir_input_init(), but the stack trace doesn't lead there. I am also
> skeptical about the +0x64/0x1a52, ir_input_init() is a rather small
> function and I fail to see how it could be 6738 bytes in binary size.
> Might be that the bug caused a stack corruption. Building a debug
> kernel may help.

Cheers,
Hermann


