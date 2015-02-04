Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cvg.de ([62.153.82.30]:59098 "EHLO mail.cvg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161032AbbBDRyZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 12:54:25 -0500
From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mt9p031: fixed calculation of clk_div
References: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
	<2403470.jYcXEMRiZi@avalon>
Date: Wed, 04 Feb 2015 18:54:08 +0100
In-Reply-To: <2403470.jYcXEMRiZi@avalon> (Laurent Pinchart's message of "Wed,
	04 Feb 2015 19:19:45 +0200")
Message-ID: <lya90ty33z.fsf@ensc-virt.intern.sigma-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

>> and the upper limit is '63' (value uses 6:0 register bits).
>
> And this I don't. You can encode numbers from 0 to 127 on 7 bits.

yes; you are right (original '64' was correct because sensor allows only
dividers of a power-of-two).

>> -		mt9p031->clk_div = max_t(unsigned int, div, 64);
>> +		mt9p031->clk_div = min_t(unsigned int, div, 63);


Enrico
