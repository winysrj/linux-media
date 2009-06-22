Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:60762 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFVFNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 01:13:46 -0400
Message-ID: <4A3F130D.1020909@linuxtv.org>
Date: Mon, 22 Jun 2009 07:13:49 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: LinuxTv <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] @Sky Pilot, Neotion Pilot, Checksum hacking
References: <200906212002.55867.JuergenUrban@gmx.de>
In-Reply-To: <200906212002.55867.JuergenUrban@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Juergen Urban wrote:
> Now I've a problem with the 1-byte-checksum calculation. Each message 
> which I send to the device has a checksum (last byte). I don't know how to 
> calculate the checksum.
> Did someone know how to reverse engineer a 1-byte-checksum?
> Did someone see these type of messages before?
> Did someone detect any algorithm in the checksum values?
> 
> Here are examples:
> 
> static unsigned char ep03_msg109[] = {
> 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> 	0x01, 0xd0, 0x1e, 0x01, 0x00,
> 	0xca /* Checksum */
> };
> 
> static unsigned char ep03_msg110[] = {
> 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> 	0x01, 0xd0, 0x1f, 0x01, 0x00,
> 	0xcb /* Checksum */
> };
> 
> In the above example the checksum is incremented by one and there is also one 
> byte incremented by one in the payload (0x1e -> 0x1f and 0xca -> 0xcb). this 
> seems to be a simple addition.
> 
> static unsigned char ep03_msg111[] = {
> 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> 	0x01, 0xd0, 0x20, 0x01, 0x00,
> 	0xf4 /* Checksum */
> };

It's a simple XOR of all bytes with an initial value of 0x84.

unsigned int calc_cs(const unsigned char *buf, unsigned int n)
{
        unsigned int i, cs = 0x84;

        for (i = 0; i < n; i++)
                cs ^= buf[i];

        return cs;
}

Regards,
Andreas
