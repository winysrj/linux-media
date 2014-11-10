Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60040 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbaKJUqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 15:46:00 -0500
Message-ID: <1415652356.21229.31.camel@x220>
Subject: Re: [GIT PULL for v3.18-rc1] media updates
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 21:45:56 +0100
In-Reply-To: <1413793905.16435.6.camel@x220>
References: <20141009141849.137e738d@recife.lan>
	 <1413793905.16435.6.camel@x220>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 2014-10-20 at 10:31 +0200, Paul Bolle wrote:
> This became commit 38a073116525 ("[media] omap: be sure that MMU is
> there for COMPILE_TEST").
> 
> As I reported in
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/82299
> it adds an (optional) test for a Kconfig symbol HAS_MMU. There's no
> such symbol. So that test will always fail. Did you perhaps mean
> simply "MMU"?

This typo is still present in both next-20141110 and v3.18-rc4. And I've
first reported it nearly two months ago. I see two fixes:
    1) s/HAS_MMU/MMU/
    2) s/ || (COMPILE_TEST && HAS_MMU)//

Which would you prefer?


Paul Bolle

