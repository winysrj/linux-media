Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:60841 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZDYRfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 13:35:45 -0400
Date: Sat, 25 Apr 2009 10:35:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Linux and Kernel Video <video4linux-list@redhat.com>
cc: Erik de Castro Lopo <erik@bcode.com>, linux-media@vger.kernel.org
Subject: Re: Compling drivers from v4l-dvb hg tree
In-Reply-To: <20090425081654.3e9932f1.erik@bcode.com>
Message-ID: <Pine.LNX.4.58.0904251030570.3753@shell2.speakeasy.net>
References: <20090424170352.313f1feb.erik@bcode.com>
 <412bdbff0904240625y3902243em5a643380b036e08f@mail.gmail.com>
 <20090425080356.69e0ed9d.erik@bcode.com> <412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
 <20090425081654.3e9932f1.erik@bcode.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Apr 2009, Erik de Castro Lopo wrote:
> On Fri, 24 Apr 2009 18:09:17 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
> > > Ok, but how do I patch the v4l-dvb sources into a linux kernel tree?
> >
> > You don't.

You can, make kernel-links

> > The v4l-dvb sources are maintained out-of-tree, and override whatever
> > is in the linux kernel tree.  Periodically, the v4l-dvb maintainer
> > syncs with the kernel tree and the changes are pushed upstream into
> > the mainline kernel.  This approach allows for the v4l-dvb project to
> > be used with kernel releases other than the current bleeding edge
> > kernel.
>
> Ok,  but the instructions on http://linuxtv.org/repo compiles the
> driver for the current running kernel. How do I compile it for
> another kernel, ie an x86 embedded device that I normally do not
> compile on?

See "make help", it explains this.  Use "make release
DIR=/other/kernel/src/dir" to compile for any kernel you want.  I haven't
tried cross-compiling v4l-dvb so I'm not sure how that will work.  I'd just
try the standard ARCH and CROSS_COMPILE settings like a kernel build uses
and see what happens.
