Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44783 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965564Ab3DTCq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 22:46:56 -0400
Received: from [82.128.187.254] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UTNpG-0004Xz-4v
	for linux-media@vger.kernel.org; Sat, 20 Apr 2013 05:46:54 +0300
Message-ID: <51720176.9080400@iki.fi>
Date: Sat, 20 Apr 2013 05:46:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: v4l-utils build problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am unable to build that. It is Fedora 17 box. Any idea what is missing?

Here is the error:

[crope@localhost v4l-utils]$ autoreconf -vfi
autoreconf: Entering directory `.'
autoreconf: running: autopoint --force
autoreconf: running: aclocal --force -I m4
autoreconf: configure.ac: tracing
autoreconf: running: libtoolize --copy --force
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `build-aux'.
libtoolize: copying file `build-aux/ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
autoreconf: running: /usr/bin/autoconf --force
autoreconf: running: /usr/bin/autoheader --force
autoreconf: running: automake --add-missing --copy --force-missing
Makefile.am:4: AM_GNU_GETTEXT used but `po' not in SUBDIRS
autoreconf: Leaving directory `.'
[crope@localhost v4l-utils]$ configure
bash: configure: command not found...
[crope@localhost v4l-utils]$


regards
Antti
-- 
http://palosaari.fi/
