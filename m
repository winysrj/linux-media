Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:36171 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab3JDIGs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Oct 2013 04:06:48 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-mips@linux-mips.org
Cc: linux-media@vger.kernel.org
References: <m3eh82a1yo.fsf@t19.piap.pl>
Date: Fri, 04 Oct 2013 10:06:45 +0200
In-Reply-To: <m3eh82a1yo.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Thu, 03 Oct 2013 16:00:47 +0200")
MIME-Version: 1.0
Message-ID: <m3a9ipa296.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm debugging a problem with a SOLO6110-based H.264 PCI video encoder on
> Atheros AR7100-based (MIPS, big-endian) platform.

BTW this CPU obviously has VIPT data cache, this means a physical page
with multiple virtual addresses (e.g. mapped multiple times) may and
will be cached multiple times.

AR7100 = arch/mips/ath79.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
