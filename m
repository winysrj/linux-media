Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbcBANPD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 08:15:03 -0500
Subject: Re: [v4l-utils PATCH 1/2] v4l: libv4l1, libv4l2: Use $(mkdir_p)
 instead of deprecated $(MKDIR_P)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
References: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
 <1453725684-4561-2-git-send-email-sakari.ailus@linux.intel.com>
 <20160201105945.20dd5087@recife.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56AF5A4D.4020500@linux.intel.com>
Date: Mon, 1 Feb 2016 15:14:53 +0200
MIME-Version: 1.0
In-Reply-To: <20160201105945.20dd5087@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Em Mon, 25 Jan 2016 14:41:23 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> autoconf thinks $(MKDIR_P) is deprecated. Use $(mkdir_p) instead.
> 
> Did you get any troubles with the deprecated macro?
> 
> At least here (version 2.69), I don't see any error by using $(MKDIR_P).

I have the same version.

-----8<------
$ autoreconf -vfi
autoreconf: Entering directory `.'
autoreconf: configure.ac: not using Gettext
autoreconf: running: aclocal --force -I m4
autoreconf: configure.ac: tracing
autoreconf: configure.ac: AM_GNU_GETTEXT is used, but not
AM_GNU_GETTEXT_VERSION
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
configure.ac:85: warning: The 'AM_PROG_MKDIR_P' macro is deprecated, and
its use is discouraged.
configure.ac:85: You should use the Autoconf-provided 'AC_PROG_MKDIR_P'
macro instead,
configure.ac:85: and use '$(MKDIR_P)' instead of '$(mkdir_p)'in your
Makefile.am files.
autoreconf: Leaving directory `.'
-----8<------

Perhaps automake version makes a difference. I have 1.14.1 here (Ubuntu
package 1:1.14.1-2ubuntu1 from Ubuntu 14.10).

There are no errors due to this, just a warning.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
