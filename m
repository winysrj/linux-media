Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43005 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533AbaJaPYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:24:51 -0400
Received: by mail-pd0-f175.google.com with SMTP id y13so7487076pdi.34
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 08:24:50 -0700 (PDT)
Message-ID: <5453A9BE.7060806@gmail.com>
Date: Sat, 01 Nov 2014 00:24:46 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 6/7] v4l-utils/libdvbv5: don't discard config-supplied
 parameters
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com> <1414323983-15996-7-git-send-email-tskd08@gmail.com> <20141027151104.427630df.m.chehab@samsung.com>
In-Reply-To: <20141027151104.427630df.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I withdrew this patch as it's meaningless.

Originally I mis-understood that when dvbv5-scan was run
with "-G" option, the props in channel config file that
are not specified in dvb-v5-std.c::sys_foo_props[] were
once loaded to "parms" structure to be scanned,
but later discarded in dvb_fe_get_parms()
(without experiments/tests :P ).

I noticed that there's no effect in this patch by experiments,
and non "sys_foo_props[]"-defined props are discarded at
its read in the first place.
sorry to have bothered you with the meaningless patch.
maybe it was because I had a cold recently;)
--
Akihiro
