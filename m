Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2FWQhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 12:37:25 -0400
Received: by bkcji2 with SMTP id ji2so2283417bkc.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 09:37:23 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/3] ir-keytable: Smarter keytable location handling
Date: Sat, 23 Jun 2012 18:36:44 +0200
Message-Id: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patchset will improve the keytable location handling of
ir-keytable. In controst to the default install location
(/etc/rc_keymaps) Debian and Ubuntu installed the shipped
keymaps into /lib/udev/rc_keymaps (just like keyboard keymaps
are installed into /lib/udev/keymaps). If a keymap needs to
be modified it's supposed to go into /etc/rc_keymaps.

The current ir-keytable program knows only about a single default
keytable directory. This patchset makes ir-keytable aware of a
system and user keytable directory. The user directory is searched
first, followed by a the system directory if no file was found.

Mauro, are you OK with committing?

Thanks,
Gregor

Gregor Jasny (3):
  keytable: Make udev rules dir configurable
  keytable: Preinstall keytables relative to sysconfdir
  keytable: first search table in userdir, then in systemdir

 configure.ac               |   15 +++++++++++----
 utils/keytable/Makefile.am |    8 ++++----
 utils/keytable/keytable.c  |   30 +++++++++++++++++++++---------
 3 files changed, 36 insertions(+), 17 deletions(-)

-- 
1.7.10

