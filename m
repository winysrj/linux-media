Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42236 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab1AMQtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 11:49:11 -0500
Date: Thu, 13 Jan 2011 17:48:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
Message-ID: <20110113174814.12c2ea5d@endymion.delvare>
In-Reply-To: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
References: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 13 Jan 2011 11:34:42 -0500, Andy Walls wrote:
> How should clock stretches by slaves be handled using i2c-algo-bit?

It is already handled. But hdpvr-i2c doesn't use i2c-algo-bit. I2C
support is done with USB commands instead. Maybe the hardware
implementation doesn't support clock stretching by slaves. Apparently
it doesn't support repeated start conditions either, so it wouldn't
surprise me.

-- 
Jean Delvare
