Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2JHBYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 21:24:36 -0400
Date: Sun, 7 Oct 2012 22:24:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ir-keytable: Bug in gen_keytables.pl script
Message-ID: <20121007222429.1c8738e5@redhat.com>
In-Reply-To: <5071BACA.1080702@googlemail.com>
References: <5071BACA.1080702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 07 Oct 2012 19:24:26 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> I recently received this launchpad bug:
> https://bugs.launchpad.net/ubuntu/+source/v4l-utils/+bug/1054122
> It seems that the mentioned key mappings are missing.
> 
> If you check the generated mapping file
> 
> http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/utils/keytable/rc_keymaps/imon_pad
> 
> and compare it to the driver file
> 
> http://git.linuxtv.org/media_tree.git/blob/refs/heads/staging/for_v3.7:/drivers/media/rc/keymaps/rc-imon-pad.c#l111
> 
> you'll notice that the parsing stopped at the BTN_xyz table entries:
> 
> >         { 0x299115b7, KEY_KEYBOARD },
> >         { 0x299135b7, KEY_KEYBOARD },
> 
> processing stopped here
> 
> >         { 0x01010000, BTN_LEFT },
> >         { 0x01020000, BTN_RIGHT },
> >         { 0x01010080, BTN_LEFT },
> >         { 0x01020080, BTN_RIGHT },
> >         { 0x688301b7, BTN_LEFT },
> >         { 0x688481b7, BTN_RIGHT },
> > 
> >         { 0x2a9395b7, KEY_CYCLEWINDOWS }, /* TaskSwitcher */
> >         { 0x2b8395b7, KEY_TIME }, /* Timer */
> 
> Mauro, could you please take a look? I guess the BTN_xyz entries should
> be also added to the keytable files. Unfortunately my Perl skills are
> horrible.

Thanks for noticing!

Fixed. The fix for it was quick and simple:

-                   if (m/(0x[\dA-Fa-f]+)[\s\,]+(KEY_[^\s\,\}]+)/) {
-                           $out .= "$1 $2\n";
+                 if (m/(0x[\dA-Fa-f]+)[\s\,]+(KEY|BTN)(\_[^\s\,\}]+)/) {
+                         $out .= "$1 $2$3\n";

Basically, the regex there weren't expecting mouse buttons. Some MCE remotes
have it.

I also updated the keytables, syncing it with the very latest git tree.

Regards,
Mauro
