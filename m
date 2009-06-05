Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57701 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFEPgk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 11:36:40 -0400
Message-ID: <4A293B89.30502@iki.fi>
Date: Fri, 05 Jun 2009 18:36:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Nikitenko <jan.nikitenko@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: AVerTV Volar Black HD: i2c oops in warm state on mips
References: <4A28CEAD.9000000@gmail.com>
In-Reply-To: <4A28CEAD.9000000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Jan,

On 06/05/2009 10:52 AM, Jan Nikitenko wrote:
> Hi,
>
> I am trying to get AverMedia AVerTV Volar Black HD (A850) usb dvb-t tuner
> running on mips32 little endian platform (to stream dvb-t from home
> router on LAN).
[..]
> DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))
>
> CPU 0 Unable to handle kernel paging request at virtual address

[..]

> Tried two mips32 little endian platforms: Broadcom BCM3302 /asus wl500gp
> router/
> and alchemy au1550 with the same result.
>
> Any ideas why this happens?

Looks like it fails when demodulator is attached - af9013_attach(). 
Unfortunately I am not familiar those Oops dumps or debugs :( And I 
don't have such hw to reproduce the problem. Is that possible that you 
can try to examine more and even fix problem?

Lets try first comment out all i2 read / write operations (reg_read, 
reg_write) from af9013_attach. Then test if any operation can be done 
without crash. All register operations from af9013 goes to the 
af9015_i2c_xfer() function. You can try to catch error from there also. 
I hope this helps you. Good luck! :)

regards
Antti
-- 
http://palosaari.fi/
