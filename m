Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46332 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKBJav (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 04:30:51 -0500
Received: by mail-pd0-f169.google.com with SMTP id y10so9811803pdj.14
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 01:30:50 -0800 (PST)
Message-ID: <5455F9C6.4070002@gmail.com>
Date: Sun, 02 Nov 2014 18:30:46 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] libdvbv5, dvbv5-scan: generalize channel
 duplication check
References: <E1XkI3i-00082l-Jd@www.linuxtv.org> <54556AC9.40309@googlemail.com>
In-Reply-To: <54556AC9.40309@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After I re-checked the source,
I noticed that dvb_scan_add_entry() also breaks API/ABI compatibility
as well as dvb_new_freq_is_needed(), and those functions are
marked as "ancillary functions used internally inside the library"
in dvb-scan.h.
So I think it would rather be better to move those funcs to a private
header (dvb-scan-priv.h?).
Which way should we go? ver bump/compat-soname.c/dvb-scan-priv.h ?
--
Akihiro
