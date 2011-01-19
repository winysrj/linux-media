Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:21069 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1ASPA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 10:00:28 -0500
Date: Wed, 19 Jan 2011 15:59:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Message-ID: <20110119155932.08d080b7@endymion.delvare>
In-Reply-To: <1295205650.2400.27.camel@localhost>
References: <1295205650.2400.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Sun, 16 Jan 2011 14:20:49 -0500, Andy Walls wrote:
> 3. I hear from Jean, or whomever really cares about ir-kbd-i2c, if
> adding some new fields for struct IR_i2c_init_data is acceptable.
> Specifically, I'd like to add a transceiver_lock mutex, a transceiver
> reset callback, and a data pointer for that reset callback.
> (Only lirc_zilog would use the reset callback and data pointer.)

Adding fields to these structures is perfectly fine, if you need to do
that, just go on.

But I'm a little confused about the names you chose,
"ir_transceiver_lock" and "transceiver_lock". These seem too
TX-oriented for a mutex that is supposed to synchronize TX and RX
access. It's particularly surprising for the ir-kbd-i2c driver, which
as far as I know only supports RX. The name "xcvr_lock" you used for
lirc_zilog seems more appropriate.

-- 
Jean Delvare
