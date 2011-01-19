Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:38129 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1ASMlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 07:41:01 -0500
Date: Wed, 19 Jan 2011 13:40:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Message-ID: <20110119134009.1d473320@endymion.delvare>
In-Reply-To: <1295439718.2093.17.camel@morgan.silverblock.net>
References: <1295205650.2400.27.camel@localhost>
	<1295234982.2407.38.camel@localhost>
	<848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	<1295439718.2093.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011 07:21:58 -0500, Andy Walls wrote:
> For debugging, you might want to hack in a probe of address 0x70 for
> your HVR-1950, to ensure the Tx side responds in the bridge driver. 

... keeping in mind that the Z8 doesn't seem to like quick writes, so
short reads should be used for probing purpose.

-- 
Jean Delvare
