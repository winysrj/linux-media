Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41026 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZHPQm2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 12:42:28 -0400
Message-ID: <4A8836F2.3050104@iki.fi>
Date: Sun, 16 Aug 2009 19:42:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Alistair Buxton <a.j.buxton@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Rework the RTL2831 remote control handler to reuse dibusb.
References: <3d374d00908021245g66fc66b1h66932f4844cb20b1@mail.gmail.com> <4A77562D.6060001@hoogenraad.net>
In-Reply-To: <4A77562D.6060001@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Jan

On 08/04/2009 12:27 AM, Jan Hoogenraad wrote:
> Antti Palosaari offered help in july to get the includable tree
> (front-end / back-end split) up and running. I haven't heard from him
> since, so I cc him.

I have been lazy and holidaying.
But yesterday I finally take my devel tree back to desk and got it 
working! Now it is basically split to the USB-bridge, demodulator and 
mt2060 (using Kernel mt2060 driver). There is still a lot of work to 
clean all code and implement correctly. It is now only routine work from 
callback to callback. Will continue.

Antti
-- 
http://palosaari.fi/
