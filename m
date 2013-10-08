Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:55357 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3JHKq5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Oct 2013 06:46:57 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-media@vger.kernel.org
References: <m3eh82a1yo.fsf@t19.piap.pl> <m361t9a31i.fsf@t19.piap.pl>
	<20131007142429.GG3098@linux-mips.org>
Date: Tue, 08 Oct 2013 12:46:55 +0200
In-Reply-To: <20131007142429.GG3098@linux-mips.org> (Ralf Baechle's message of
	"Mon, 7 Oct 2013 16:24:29 +0200")
MIME-Version: 1.0
Message-ID: <m3hacs82g0.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ralf Baechle <ralf@linux-mips.org> writes:

> That's fine.  You just need to ensure that there are no virtual aliases.
> One way to do so is to increase the page size to 16kB.

Checked, this thing works fine with 16 KB pages.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
