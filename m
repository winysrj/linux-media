Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59250 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaKBPti (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 10:49:38 -0500
Received: by mail-pd0-f174.google.com with SMTP id p10so10056983pdj.19
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 07:49:38 -0800 (PST)
Message-ID: <5456528D.6080304@gmail.com>
Date: Mon, 03 Nov 2014 00:49:33 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v4] v4l-utils/libdvbv5: add gconv module for the text
 conversions of ISDB-S/T.
References: <1414761224-32761-8-git-send-email-tskd08@gmail.com> <1414842019-15975-1-git-send-email-tskd08@gmail.com> <54563CE4.2080103@googlemail.com>
In-Reply-To: <54563CE4.2080103@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> I would really prefer if you could use the autotools toolchain
> (autoconf, automake, libtool) to produce the two gconv modules. You
> might be able to have a look at the v4l-plugins Makefiles in this project.

As the upstream glibc does not use autotools,
I looked through the Makefiles there and they were too complex for me
to convert to the simple version for just building out-of-tree modules.
So the current Makefile is pretty premitive.
But I'll try to investigate it again.

> In the existing Makefile I miss an install target.

Those modules are not intended to be installed,
instead GCONV_PATH is set to the directory at runtime.

> Did you write the whole gconv module by yourself? Please clarify
> copyright. Because libdvbv5 is useable without the gconv modules I would
> move them into /contrib rather than /lib.

the work was done by myself but it is based on the other existing
modules (iso-2022-jp-3 and iso_6937).
I'd like to assign copyrights to FSF as written in a file header,
as I intend to contribute them to the upstream glibc.

> Are you aware of any other software that ships gconv modules? I'd like
> to take a look how it got packaged for distributions.

Unfortunately I don't know one,
and that's why those gconv modules are so badly packaged;)

--
Akihiro

