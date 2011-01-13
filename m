Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:3177 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab1AMJrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 04:47:20 -0500
Date: Thu, 13 Jan 2011 10:46:27 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct  
 i2c_adapter.id field
Message-ID: <20110113104627.4d1607e9@endymion.delvare>
In-Reply-To: <1294276835.9672.99.camel@morgan.silverblock.net>
References: <1293587067.3098.10.camel@localhost>
	<1293587390.3098.16.camel@localhost>
	<20110105154553.546998bf@endymion.delvare>
	<4D24ABA4.5070100@redhat.com>
	<20110105225149.1145420b@endymion.delvare>
	<4D24EA81.8080205@redhat.com>
	<1294276835.9672.99.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Wed, 05 Jan 2011 20:20:35 -0500, Andy Walls wrote:
> The cx18 driver has a function scope i2c_client for reading the EEPROM,
> and there's a good reason for it.  We don't want to register the EEPROM
> with the I2C system and make it visible to the rest of the system,
> including i2c-dev and user-space tools.  To avoid EEPROM corruption,
> it's better keep communication with EEPROMs to a very limited scope.

Note that it is possible to declare a read-only EEPROM, so that
user-space has no chance to write to it. If you really don't want
user-space to touch it, the best approach is i2c_new_dummy(), because
it will mark the slave address as busy, preventing i2c-dev from
accessing it (unless the user forces access - but then he/she is
obviously on his/her own...)

The i2c_client provided by i2c_new_dummy() can be unregistered at the
end of the function which needs it, or kept for the lifetime of the
driver, as you prefer.

-- 
Jean Delvare
