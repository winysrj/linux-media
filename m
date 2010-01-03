Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:47544 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0ACUfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 15:35:45 -0500
Received: by fxm25 with SMTP id 25so8253227fxm.21
        for <linux-media@vger.kernel.org>; Sun, 03 Jan 2010 12:35:43 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 3 Jan 2010 21:35:43 +0100
Message-ID: <7b41dd971001031235h2ce1fb30v5b20356bd2c9961f@mail.gmail.com>
Subject: czap needs #define _GNU_SOURCE
From: klaas de waal <klaas.de.waal@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The czap utility (dvb-apps/util/szap/czap.c) cannot scan the channel
configuration file when compiled on Fedora 12 with gcc-4.4.2.
Problem is tha the "sscanf" function uses the "%a[^:]" format
specifier. According to "man sscanf" you need to define _GNU_SOURCE if
you want this to work because it is a gnu-only extension.
Adding a first line "#define _GNU_SOURCE" to czap.c and recompiling
solves the problem.

Cheers,
Klaas
