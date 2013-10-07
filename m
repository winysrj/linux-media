Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:55213 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3JGIiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 04:38:51 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-mips@linux-mips.org
Cc: linux-media@vger.kernel.org
References: <m3eh82a1yo.fsf@t19.piap.pl>
Date: Mon, 07 Oct 2013 10:38:49 +0200
In-Reply-To: <m3eh82a1yo.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Thu, 03 Oct 2013 16:00:47 +0200")
MIME-Version: 1.0
Message-ID: <m361t9a31i.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please forgive me my MIPS TLB ignorance.

It seems there is a TLB entry pointing to the userspace buffer at the
time the kernel pointer (kseg0) is used. Is is an allowed situation on
MIPS 24K?

buffer: len 0x1000 (first page),
	userspace pointer 0x77327000,
	kernel pointer 0x867ac000 (physical address = 0x067ac000)

TLB Index: 15 pgmask=4kb va=77326000 asid=be
       [pa=01149000 c=3 d=1 v=1 g=0] [pa=067ac000 c=3 d=1 v=1 g=0]

Should the TLB entry be deleted before using the kernel pointer (which
points at the same page)?
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
