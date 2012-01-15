Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33695 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2AOVhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:37:09 -0500
Received: by bkas6 with SMTP id s6so187116bka.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 13:37:08 -0800 (PST)
Message-ID: <4F134701.9000105@googlemail.com>
Date: Sun, 15 Jan 2012 22:37:05 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: v4l-utils migrated to autotools
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm Gregor the Debian (and thus Ubuntu) Maintainer of v4l-utils. I took
the challenge to convert the Makefile based build system into an
autotools one. This weekend I polished the last bits and submitted my
changes.

If you build v4l-utils from source, please clean your tree via "git
clean" after the pull. Then make sure you have autotools, libtool and
pkg-config installed. Bootstrap the autotools environment by calling
"autoreconf -vfi". The rest is the usual configure && make && make install.

Thanks,
Gregor
