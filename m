Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33023 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 06:42:03 -0500
Message-ID: <4EC25008.4020804@iki.fi>
Date: Tue, 15 Nov 2011 13:42:00 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Claus Olesen <ceolesen@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e and 520e
References: <CAGa-wNMx7DhppkBQNowuXBKwitkU3tCQYLzNJuhqx=ZcytcjVQ@mail.gmail.com>
In-Reply-To: <CAGa-wNMx7DhppkBQNowuXBKwitkU3tCQYLzNJuhqx=ZcytcjVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2011 01:14 PM, Claus Olesen wrote:
> PCTV 290e usb stick - locking issue
> ===================================
> The locking issue with the 290e is not resolved as of
> yesterdays auto update to kernel 3.1.1-1.fc16.i686.PAE on Fedora 16.
> The symptoms are that no usb stick is usable unless the em28xx_dvb
> module is manually unloaded and the 290e unplugged in that order.

It is fixed to 3.2. I have had 3.2 few days and it works as it should. 
Thanks for the  Chris Rankin for fixing that long time and annoying 
em28xx driver bug!

> PCTV 290e usb stick - dvb-c support
> ===================================
> dvb-c is supported by the 290e (although not advertised)
> according to stevekerrison.com/290e/, my tests with dvbviewer on windows and
> dmesg on my Fedora 16 as follows (3rd line from the bottom)

> [   80.031343] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
> (DVB-T/T2))...
> [   80.031579] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...

> but not by the latest kernel 3.1.1-1.fc16.i686.PAE of Fedora 16
> as the command
> find /dev/dvb
> outputs

> /dev/dvb/adapter0/frontend1
> /dev/dvb/adapter0/frontend0
> showing all the index-0 (dvb-t) devices but mostly no index-1 (dvb-c) devices
>
> Does anyone know of an intent to add support for dvb-c from the PCTV
> 290e? in the near future?

There is two frontends, frontend0 for DVB-T/T2 and frontend1 for DVB-C 
(as the logs says too).

> PCTV 520e usb stick - dvb-c support
> ===================================
> The 520e supports dvb-c in addition to dvb-t.
> Does anyone know of an intent to add support for (dvb-c in particular
> from) the 520e? in the near
> future?

It should be rather easy stuff and I am also interested. But I have no 
time currently nor device (have some other ~similar devices waiting here 
too).

> PCTV 290e and 520e usb sticks - compared
> ========================================
> The 520e applies tda18271 according to
> www.mail-archive.com/linux-media@vger.kernel.org/msg38091.html
> as also applied by the 290e hinting perhaps that the 290e and 520e are
> very alike.
>
> Does that mean that dvb-c support if added for the 520e also will apply to the
> 290e? thereby making the 290e a better deal as it also supports dvb-t2?

If you need DVB-C then it maybe better to get some other stick than 
290e. Using it for DVB-C is out-of-specs.

regards
Antti
-- 
http://palosaari.fi/
