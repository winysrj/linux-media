Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51910 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaKBORL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:17:11 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so4549597wib.5
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 06:17:10 -0800 (PST)
Message-ID: <54563CE4.2080103@googlemail.com>
Date: Sun, 02 Nov 2014 15:17:08 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v4] v4l-utils/libdvbv5: add gconv module for the text
 conversions of ISDB-S/T.
References: <1414761224-32761-8-git-send-email-tskd08@gmail.com> <1414842019-15975-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414842019-15975-1-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this does not compile for me on my Debian Sid machine:

> make[3]: Entering directory '/home/gjasny/src/linuxtv/v4l-utils/lib/gconv'
> ld -o ARIB-STD-B24.so ARIB-STD-B24.o  -shared --version-script=gconv.map -z combreloc -rpath=/usr/lib/gconv /usr/lib/gconv/libJIS.so /usr/lib/gconv/libJISX0213.so
> ld: cannot find /usr/lib/gconv/libJIS.so: No such file or directory
> ld: cannot find /usr/lib/gconv/libJISX0213.so: No such file or directory
> Makefile:21: recipe for target 'ARIB-STD-B24.so' failed

The library is located in /usr/lib/x86_64-linux-gnu/gconv/libJIS.so.

I would really prefer if you could use the autotools toolchain
(autoconf, automake, libtool) to produce the two gconv modules. You
might be able to have a look at the v4l-plugins Makefiles in this project.

Also without using the autotools toolchain, cross compiling is broken.
Please see the INSTALL file in the root how to test.

Some ARM toolchains are not able to build shared libraries, so it would
be best to make the WITH_GCONV condition based on enable_shared, too.

In the existing Makefile I miss an install target.

Did you write the whole gconv module by yourself? Please clarify
copyright. Because libdvbv5 is useable without the gconv modules I would
move them into /contrib rather than /lib.

Are you aware of any other software that ships gconv modules? I'd like
to take a look how it got packaged for distributions.

Thanks,
Gregor
