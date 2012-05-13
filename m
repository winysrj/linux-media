Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59533 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2EMKLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 06:11:51 -0400
Received: by dady13 with SMTP id y13so4771522dad.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 03:11:50 -0700 (PDT)
From: Mark Purcell <mark@purcell.id.au>
To: linux-media@vger.kernel.org
Subject: Fwd: Bug#606728: dvbscan: Infinite loop parsing arguments
Date: Sun, 13 May 2012 20:11:43 +1000
Cc: Vincent Pelletier <plr.vincent@gmail.com>,
	606728-forwarded@bugs.debian.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gj4rPc/lL/fZIsr"
Message-Id: <201205132011.44898.mark@purcell.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_gj4rPc/lL/fZIsr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit


----------  Forwarded Message  ----------

Subject: Bug#606728: dvbscan: Infinite loop parsing arguments
Date: Sat, 11 Dec 2010, 21:13:08
From: Vincent Pelletier <plr.vincent@gmail.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: dvb-apps
Version: 1.1.1+rev1355-1
Severity: normal
Tags: patch

How to reproduce:
  dvbscan -out raw - some_file
Result:
  dvbscan process taking 100% of cpu.

Cause:
  Argument parser doesn't increment argument position when
encountering -out parameter, so it loops forever on parsing -out.

-- System Information:
Debian Release: squeeze/sid
  APT prefers unstable
  APT policy: (500, 'unstable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.36vin0 (SMP w/2 CPU cores)
Locale: LANG=C, LC_CTYPE=C (charmap=ANSI_X3.4-1968)
Shell: /bin/sh linked to /bin/dash

Versions of packages dvb-apps depends on:
ii  libc6                         2.11.2-7   Embedded GNU C Library: Shared 
lib
ii  udev                          164-2      /dev/ and hotplug management 
daemo

dvb-apps recommends no packages.

dvb-apps suggests no packages.

-- no debconf information

-----------------------------------------

--Boundary-00=_gj4rPc/lL/fZIsr
Content-Type: text/x-diff;
  charset="us-ascii";
  name="dvbscan.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dvbscan.c.diff"

LS0tIGR2YnNjYW4uYy5vcmcJMjAxMC0xMi0xMSAxMTowMDoyMi4wMDAwMDAwMDAgKzAxMDAKKysr
IGR2YnNjYW4uYwkyMDEwLTEyLTExIDExOjAwOjA1LjAwMDAwMDAwMCArMDEwMApAQCAtMjI1LDYg
KzIyNSw3IEBACiAJCQlvdXRwdXRfZmlsZW5hbWUgPSBhcmd2W2FyZ3BvcysyXTsKIAkJCWlmICgh
c3RyY21wKG91dHB1dF9maWxlbmFtZSwgIi0iKSkKIAkJCQlvdXRwdXRfZmlsZW5hbWUgPSBOVUxM
OworCQkJYXJncG9zKz0zOwogCQl9IGVsc2UgewogCQkJaWYgKChhcmdjIC0gYXJncG9zKSAhPSAx
KQogCQkJCXVzYWdlKCk7Cg==
--Boundary-00=_gj4rPc/lL/fZIsr--




