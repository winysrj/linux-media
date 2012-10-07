Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57588 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2JGRYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 13:24:31 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1669322bkc.19
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2012 10:24:29 -0700 (PDT)
Message-ID: <5071BACA.1080702@googlemail.com>
Date: Sun, 07 Oct 2012 19:24:26 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: ir-keytable: Bug in gen_keytables.pl script
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I recently received this launchpad bug:
https://bugs.launchpad.net/ubuntu/+source/v4l-utils/+bug/1054122
It seems that the mentioned key mappings are missing.

If you check the generated mapping file

http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/utils/keytable/rc_keymaps/imon_pad

and compare it to the driver file

http://git.linuxtv.org/media_tree.git/blob/refs/heads/staging/for_v3.7:/drivers/media/rc/keymaps/rc-imon-pad.c#l111

you'll notice that the parsing stopped at the BTN_xyz table entries:

>         { 0x299115b7, KEY_KEYBOARD },
>         { 0x299135b7, KEY_KEYBOARD },

processing stopped here

>         { 0x01010000, BTN_LEFT },
>         { 0x01020000, BTN_RIGHT },
>         { 0x01010080, BTN_LEFT },
>         { 0x01020080, BTN_RIGHT },
>         { 0x688301b7, BTN_LEFT },
>         { 0x688481b7, BTN_RIGHT },
> 
>         { 0x2a9395b7, KEY_CYCLEWINDOWS }, /* TaskSwitcher */
>         { 0x2b8395b7, KEY_TIME }, /* Timer */

Mauro, could you please take a look? I guess the BTN_xyz entries should
be also added to the keytable files. Unfortunately my Perl skills are
horrible.

Thanks,
Gregor
