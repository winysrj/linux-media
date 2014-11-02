Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43073 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaKBJmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Nov 2014 04:42:00 -0500
Date: Sun, 2 Nov 2014 07:41:53 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: Gregor Jasny <gjasny@googlemail.com>, linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] libdvbv5, dvbv5-scan: generalize channel
 duplication check
Message-ID: <20141102074153.7cbad706@recife.lan>
In-Reply-To: <5455F9C6.4070002@gmail.com>
References: <E1XkI3i-00082l-Jd@www.linuxtv.org>
	<54556AC9.40309@googlemail.com>
	<5455F9C6.4070002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 02 Nov 2014 18:30:46 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> Hi,
> 
> After I re-checked the source,
> I noticed that dvb_scan_add_entry() also breaks API/ABI compatibility
> as well as dvb_new_freq_is_needed(), and those functions are
> marked as "ancillary functions used internally inside the library"
> in dvb-scan.h.
> So I think it would rather be better to move those funcs to a private
> header (dvb-scan-priv.h?).
> Which way should we go? ver bump/compat-soname.c/dvb-scan-priv.h ?

I would keep them exported. It shouldn't be hard to provide a backward
compatible function with the same name where the extra parameter would
be filled internally, and passed to a new function with one extra argument.

Regards,
Mauro
