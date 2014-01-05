Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56506 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaAEHI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 02:08:29 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so17195164pbc.40
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 23:08:29 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 5 Jan 2014 00:08:29 -0700
Message-ID: <CAKn+a3ssvA2TF82O99Nwmfeu0govVgYdm=4Q69Xe6S5hhtaMPg@mail.gmail.com>
Subject: Regression on nxt2004
From: Mark Goldberg <marklgoldberg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware loading fails intermittently on nxt2004 with the fedora
3.12.5-302.fc20.x86_64 kernel.

It appears that this is due to [PATCH 3.11 178/272] [media] dvb-frontends:
Don't use dynamic static allocation.

If I revert the patch for nxt200x.c it works correctly.

See https://bugzilla.redhat.com/show_bug.cgi?id=1047988 for more detail.

Mark
