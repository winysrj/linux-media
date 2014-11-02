Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32917 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKBKSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 05:18:10 -0500
Received: by mail-wg0-f53.google.com with SMTP id b13so9032337wgh.26
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 02:18:09 -0800 (PST)
Message-ID: <545604DD.2080703@googlemail.com>
Date: Sun, 02 Nov 2014 11:18:05 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Akihiro TSUKADA <tskd08@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] libdvbv5, dvbv5-scan: generalize channel
 duplication check
References: <E1XkI3i-00082l-Jd@www.linuxtv.org>	<54556AC9.40309@googlemail.com>	<5455F9C6.4070002@gmail.com> <20141102074153.7cbad706@recife.lan>
In-Reply-To: <20141102074153.7cbad706@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/14 10:41, Mauro Carvalho Chehab wrote:
> Em Sun, 02 Nov 2014 18:30:46 +0900
> Akihiro TSUKADA <tskd08@gmail.com> escreveu:
> 
>> Hi,
>>
>> After I re-checked the source,
>> I noticed that dvb_scan_add_entry() also breaks API/ABI compatibility
>> as well as dvb_new_freq_is_needed(), and those functions are
>> marked as "ancillary functions used internally inside the library"
>> in dvb-scan.h.
>> So I think it would rather be better to move those funcs to a private
>> header (dvb-scan-priv.h?).
>> Which way should we go? ver bump/compat-soname.c/dvb-scan-priv.h ?
> 
> I would keep them exported. It shouldn't be hard to provide a backward
> compatible function with the same name where the extra parameter would
> be filled internally, and passed to a new function with one extra argument.

As far as I understand dvb-scan uses these functions, so they are not
that internal like intended. Providing a backward compatible function
would be the way to go.

FYI: The Ubuntu buildbot discovered the breakage:
> https://launchpad.net/~libv4l/+archive/ubuntu/development/+build/6528719/+files/buildlog_ubuntu-trusty-i386.v4l-utils_1.6.0%2Br2607-66%7Eubuntu14.04.1_FAILEDTOBUILD.txt.gz

Thanks,
-Gregor
