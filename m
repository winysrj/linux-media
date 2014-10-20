Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50959 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbaJTIbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 04:31:48 -0400
Message-ID: <1413793905.16435.6.camel@x220>
Subject: Re: [GIT PULL for v3.18-rc1] media updates
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 10:31:45 +0200
In-Reply-To: <20141009141849.137e738d@recife.lan>
References: <20141009141849.137e738d@recife.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Thu, 2014-10-09 at 14:18 -0300, Mauro Carvalho Chehab wrote:
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc1
> 
>[...]
>
> Mauro Carvalho Chehab (180):
>      [...]
>       [media] omap: be sure that MMU is there for COMPILE_TEST

This became commit 38a073116525 ("[media] omap: be sure that MMU is
there for COMPILE_TEST").

As I reported in
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/82299 it adds an (optional) test for a Kconfig symbol HAS_MMU. There's no such symbol. So that test will always fail. Did you perhaps mean simply "MMU"?


Paul Bolle

