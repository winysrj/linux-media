Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab2ARMn2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:43:28 -0500
Message-ID: <4F16BE69.8090908@redhat.com>
Date: Wed, 18 Jan 2012 10:43:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net>
In-Reply-To: <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-01-2012 10:31, Rémi Denis-Courmont escreveu:
> On Wed, 18 Jan 2012 10:19:24 -0200, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Not sure if it is possible, but it would be great if the build output
>> would be less verbose. libtool adds a lot of additional (generally
> useless)
>> messages, with makes harder to see the compilation warnings in the
>> middle of all those garbage.
> 
> These days, automake has a silent mode that looks much like a kernel
> compilation.
> 

Thanks for pointing it! I've enabled this with this
small patch.

Regards,
Mauro.

commit 69378dc5285a5bac78e1e57cce34cc9af3855d52
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jan 18 10:41:26 2012 -0200

    autotools: allow enabling the silent-rules
    
    With this change, it is now possible to do:
    	$ make V=0
    or
    	$ ./configure --enable-silent-rules
    
    in order to be less verbose.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/configure.ac b/configure.ac
index 48428d1..6d3e76a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -36,6 +36,7 @@ AC_CONFIG_FILES([Makefile
 AM_INIT_AUTOMAKE([1.9 no-dist-gzip dist-bzip2 -Wno-portability]) # 1.10 is needed for target_LIBTOOLFLAGS
 
 AM_MAINTAINER_MODE
+AM_SILENT_RULES
 
 # Checks for programs.
 AC_PROG_CXX
