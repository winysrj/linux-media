Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33014 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaKALh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 07:37:28 -0400
Received: by mail-pa0-f50.google.com with SMTP id eu11so9319430pac.37
        for <linux-media@vger.kernel.org>; Sat, 01 Nov 2014 04:37:28 -0700 (PDT)
Message-ID: <5454C5F4.1030306@gmail.com>
Date: Sat, 01 Nov 2014 20:37:24 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 7/7] v4l-utils/libdvbv5: add gconv module for the text
 conversions of ISDB-S/T.
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com> <1414761224-32761-8-git-send-email-tskd08@gmail.com> <20141031174709.7acb58f8.m.chehab@samsung.com>
In-Reply-To: <20141031174709.7acb58f8.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年11月01日 04:47, Mauro Carvalho Chehab wrote:

> This one failed to build here:
> 
> Making all in gconv
> make[3]: Entering directory `/devel/v4l/v4l-utils/lib/gconv'
> make[3]: *** No rule to make target `all'.  Stop.

Sorry, I forgot to "git add -f Makefile".
I'll repost v4.

> I had to add two extra patches:
> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=22c4ea6ab7fdbc23e68dbfbe5056f90171e9a019
> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=2e6c685556e589d842bc059b1b1fefb8bc6df865
> 
> In order to fix Doxygen generation.

and thanks for fixing/adding the documentation.
I built the doxygen doc and confirmed that
countries.h and COUNTRY prop were properly documented.
--
Akihiro
