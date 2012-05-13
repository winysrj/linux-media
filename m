Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2EMKHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 06:07:00 -0400
Received: by pbbrp8 with SMTP id rp8so4972064pbb.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 03:07:00 -0700 (PDT)
From: Mark Purcell <mark@purcell.id.au>
To: linux-media@vger.kernel.org
Subject: Fwd: Bug#669563: dvb-apps conflicts nmh
Date: Sun, 13 May 2012 20:06:53 +1000
Cc: Anders Hammarquist <iko@debian.org>,
	669563-forwarded@bugs.debian.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205132006.54839.mark@purcell.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


----------  Forwarded Message  ----------

Subject: Bug#669563: dvb-apps conflicts nmh
Date: Fri, 20 Apr 2012, 06:37:37
From: Anders Hammarquist <iko@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: dvb-apps
Version: 1.1.1+rev1457-4
Severity: normal

The most recent dvb-apps conflicts with nmh. While they contain a file
with the same name (/usr/share/man/man1/scan.1.gz), the correct solution
is not to conflict, as they do not provide even remotely similar
functionality, but rather for dvb-apps to not provide this file. (n)mh
clearly has precedence, having provided that particular command for several
decades.

-- System Information:
Debian Release: wheezy/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'stable'), (1, 'experimental')
Architecture: i386 (x86_64)

Kernel: Linux 3.0.0-1-amd64 (SMP w/4 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=sv_SE.utf-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages dvb-apps depends on:
ii  libc6       2.13-26
ii  libpng12-0  1.2.47-1
ii  libx11-6    2:1.4.4-4
ii  libzvbi0    0.2.33-4
ii  makedev     2.3.1-89
ii  udev        175-3.1
ii  zlib1g      1:1.2.6.dfsg-2

dvb-apps recommends no packages.

dvb-apps suggests no packages.

-- no debconf information




-----------------------------------------
