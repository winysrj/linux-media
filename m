Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55433 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab2AGR30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 12:29:26 -0500
Received: by obcwo16 with SMTP id wo16so2895441obc.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jan 2012 09:29:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F08385E.7050602@redhat.com>
References: <4F08385E.7050602@redhat.com>
Date: Sat, 7 Jan 2012 18:29:26 +0100
Message-ID: <CAJbz7-0HUqWttzMhQ14nQQwjyc_sO=zL0uQDMciFECPttg_o9Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
From: =?ISO-8859-2?Q?Honza_Petrou=B9?= <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro.

2012/1/7 Mauro Carvalho Chehab <mchehab@redhat.com>:
> As previously commented at the ML, I'm developing a set of tools
> using DVBv5 API. Instead of starting from something existing,
> I decided to start from scratch, in order to avoid polluting it
> with DVBv3 legacy stuff. Of course, I did some research inside
> the existing tools, in order to fill in the blanks, using the
> dvb-apps tzap as a reference for the first real application on it,
> but removing a large amount of code (file parsers, etc).
>
> They're now on a good shape, at least for my own usage ;)
>
> In order to test, you should use:
>
> git clone git://linuxtv.org/mchehab/experimental-v4l-utils.git
>
> And then run "make". the utils are inside utils/dvb.
>

Am I doing something wrong? After clone I can't find
dvb subdirectory inside utils:

[hop@localhost experimental-v4l-utils (master)]$ ll utils/
celkem 48
drwxr-xr-x 2 hop hop 4096 led  7 18:21 decode_tm6000/
drwxr-xr-x 3 hop hop 4096 led  7 18:21 keytable/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 libmedia_dev/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 libv4l2util/
-rw-r--r-- 1 hop hop  947 led  7 18:21 Makefile
drwxr-xr-x 2 hop hop 4096 led  7 18:21 qv4l2/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 rds/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-compliance/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-ctl/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-dbg/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 v4l2-sysfs-path/
drwxr-xr-x 2 hop hop 4096 led  7 18:21 xc3028-firmware/


Honza
