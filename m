Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42769 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab2FTQml (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 12:42:41 -0400
Message-ID: <4FE1FD7B.4050108@iki.fi>
Date: Wed, 20 Jun 2012 19:42:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: How to make bug report
References: <p4v2b9-nd7.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <p4v2b9-nd7.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2012 09:40 AM, Marx wrote:
> Hello
> I have four DVB cards:
> DVB-S2:
> -Pinnacle PCTV SAT HDTV 452E PRO USB (main kernel support)
> -Terratec Cinergy S2 USB HD v.2
> -Prof Revolution DVB-S2 8000 PCIe
> DVB-T:
> -AF9015 noname USB (main kernel support)
>
> on AMD Brazos platform (Asrock E350M1) with Debian (lately with 3.4
> kernel).
>
> While I could be able to make all of them working via different drivers
> (media-build, patches, vendor drivers, Igor Liplianin's repo, yavdr dkms
> package etc) none of this card works stable (unlike Twinhan PCI I had
> previously). Prof hangs system, Pinnacle doesn't work with DVB-S2,
> Terratec records streams partially unplayable, AF9015 stops working
> after and hour or so etc. Often I see errors of I2C subsystem.

As author of the AF9015 I would like to see some of those errors. And 
your driver version. Use latest v4l-dvb if possible as I have changed it 
very much recently.

> While I'm in process of testing it on different hardware (laptop) I
> would like to know if it's good place to write about dvb drivers bugs.
> Or maybe should I write directly to developer? or write bugs in
> Debian/kernel bugzilla or sth similair?
> How to properly report bugs? What kernel should I use, which driverset?
> What logs to attach (kernel.log)? how to enable debug options (if needed)?

Maybe best to contact driver author directly and CC this mailing list.

> I think it's rather unusual all of cards doesn't work, so I suspect that
> there can be something wrong with my system. Maybe you, as skilled
> developers, can direct me what can be wrong, what can I test?

regards
Antti

-- 
http://palosaari.fi/


