Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751542AbZFVV7P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 17:59:15 -0400
From: Juergen Urban <JuergenUrban@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] @Sky Pilot, Neotion Pilot, Checksum hacking
Date: Mon, 22 Jun 2009 23:58:57 +0200
References: <200906212002.55867.JuergenUrban@gmx.de> <4A3F130D.1020909@linuxtv.org>
In-Reply-To: <4A3F130D.1020909@linuxtv.org>
Cc: LinuxTv <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906222358.57371.JuergenUrban@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 June 2009 07:13:49 Andreas Oberritter wrote:
> Juergen Urban wrote:
> > Now I've a problem with the 1-byte-checksum calculation. Each message
> > which I send to the device has a checksum (last byte). I don't know how
> > to calculate the checksum.
> > Did someone know how to reverse engineer a 1-byte-checksum?
> > Did someone see these type of messages before?
> > Did someone detect any algorithm in the checksum values?
> >
> > Here are examples:
> >
> > static unsigned char ep03_msg109[] = {
> > 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> > 	0x01, 0xd0, 0x1e, 0x01, 0x00,
> > 	0xca /* Checksum */
> > };
> >
> > static unsigned char ep03_msg110[] = {
> > 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> > 	0x01, 0xd0, 0x1f, 0x01, 0x00,
> > 	0xcb /* Checksum */
> > };
> >
> > In the above example the checksum is incremented by one and there is also
> > one byte incremented by one in the payload (0x1e -> 0x1f and 0xca ->
> > 0xcb). this seems to be a simple addition.
> >
> > static unsigned char ep03_msg111[] = {
> > 	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
> > 	0x01, 0xd0, 0x20, 0x01, 0x00,
> > 	0xf4 /* Checksum */
> > };
>
> It's a simple XOR of all bytes with an initial value of 0x84.
>
> unsigned int calc_cs(const unsigned char *buf, unsigned int n)
> {
>         unsigned int i, cs = 0x84;
>
>         for (i = 0; i < n; i++)
>                 cs ^= buf[i];
>
>         return cs;
> }
>
> Regards,
> Andreas
>

Thanks. I didn't thought that a simple XOR has this effect. Now I see that the 
initial value of 0x84 is same as 0x81 ^ 0x05, so the first 2 bytes are not part 
of the message. I got it working in my test application.

Best regards
Juergen Urban

