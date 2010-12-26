Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:36399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0LZLlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 06:41:23 -0500
Message-ID: <4D1729DB.80406@infradead.org>
Date: Sun, 26 Dec 2010 09:41:15 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: TechnoTrend CT-3650 IR support
References: <4D170785.1070306@canonical.com>
In-Reply-To: <4D170785.1070306@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi David,

Em 26-12-2010 07:14, David Henningsson escreveu:
> Hi Linux-media,
> 
> As a spare time project I bought myself a TT CT-3650, to see if I could get it working. Waling Dijkstra did write a IR & CI patch for this model half a year ago, so I was hopeful. (Reference: http://www.mail-archive.com/linux-media@vger.kernel.org/msg19860.html )
> 
> Having tested the patch, the IR is working (tested all keys via the "evtest" tool), however descrambling is NOT working.
> 
> Waling's patch was reviewed but never merged. So I have taken the IR part of the patch, cleaned it up a little, and hopefully this part is ready for merging now. Patch is against linux-2.6.git.

Could you please rebase it to work with the rc_core support? I suspect that you
based it on a kernel older than .36, as the dvb_usb rc struct changed.

The better is to base it over the latest V4L/DVB/RC development git, available at:
	http://git.linuxtv.org/media_tree.git

Basically, the keyboard map, if not already available, should be at:
	/driver/media/rc/keymaps/

And the rc description should be something like:

.rc.core = {
			.rc_interval      = DEFAULT_RC_INTERVAL,
			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
			.rc_query         = dib0700_rc_query_old_firmware,
			.allowed_protos   = RC_TYPE_RC5 |
					    RC_TYPE_RC6 |
					    RC_TYPE_NEC,
			.change_protocol = dib0700_change_protocol,
		},

There are a few dvb drivers already converted to the new way (like dib0700).

Cheers,
Mauro.
