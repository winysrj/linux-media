Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47845 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1KJI0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 03:26:15 -0500
Date: Thu, 10 Nov 2011 09:26:06 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C
 register
Message-ID: <20111110092606.37fe3c45@endymion.delvare>
In-Reply-To: <4EBA6BC0.7080405@redhat.com>
References: <4EB9C13A.2060707@iki.fi>
	<4EBA4E3D.80105@redhat.com>
	<20111109113740.4b345130@endymion.delvare>
	<4EBA6BC0.7080405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 09 Nov 2011 10:02:08 -0200, Mauro Carvalho Chehab wrote:
> Em 09-11-2011 08:37, Jean Delvare escreveu:
> > Speaking of struct i2c_client, I seem to remember that the dvb
> > subsystem doesn't use it much at the moment. This might be an issue if
> > you intend to get the generic code into i2c-core, as most helper
> > functions rely on a valid i2c_client structure by design.
> 
> Yes, DVB uses the low level I2C ops. I don't see any reason why not
> changing it to use struct i2c_client (well, except that such change
> would require lots of changes and tests).

The "lots of changes and tests" part is indeed the problem. Furthermore
I clearly remember discussing this with Michael a couple years ago
(during the i2c device driver model rework) and telling him I would
never force DVB to make use of i2c_client if they did not want to. I
gave my word, taking it back now would be unfair. Well at least the new
i2c model would make it possible, this wasn't the case before, but this
is such a huge amount of work that I certainly don't want to push this
on anyone.

-- 
Jean Delvare
