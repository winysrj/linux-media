Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp5-g19.free.fr ([212.27.42.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1JuNR6-0004Fw-Eg
	for linux-dvb@linuxtv.org; Fri, 09 May 2008 09:54:38 +0200
Message-ID: <4824034D.7000700@free.fr>
Date: Fri, 09 May 2008 09:54:53 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Ingo Peukes <admin@ipnetwork.de>
References: <481ED628.4070901@ipnetwork.de> <482374BA.7040508@ipnetwork.de>
In-Reply-To: <482374BA.7040508@ipnetwork.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Cinergy T2 Kernel Oops on Linkstation Live V1
 (Marvel Orion ARM Architecture)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Ingo,

Ingo Peukes a =E9crit :
> Hello everyone...
> =

> a few days ago I bought e Pinnacle PCTV200e to try if it works with my =

> Linkstation. After getting some drivers for it from here: =

> http://ubuntuforums.org/showthread.php?t=3D511676&page=3D8
> As result I just got the same kernel oops, only triggered by the dvb_usb =

> module instead of the cinergyT2 one.
> =

Is it the same ManufacturerID/VendorID as the cinergyT2 device or did you m=
ake some adaptations to make your Pinnacle device to work with the cinergyT=
2 driver?

> Today I found a patch sent to this list on 01/20/2008 by Michele =

> Scorcia. Although it is for kernel 2.6.20.4 and written to fix a problem =

> on a mips platform the description of the problem came close to mine. So =

> I applied it to the usb-urb.c from the above archive and built the module=
s.
> After that the oops was gone and the PCTV runs without problems.
> The cinergy driver still triggers the oops but i think that's normal =

> cause it does not use the dvb-usb module and would need a separate patch.
> The new cinergyT2 driver from Tomi Orava works just fine so I give it a =

> chance instead of fixing the old one.
> Another reason for this is that I tried both receivers on my desktop =

> with the same kernel and v4l-dvb sources as I use on the Linkstation and =

> couldn't make them run both at the same time. dmesg shows no errors but
> w_scan hangs when both drivers are loaded. Either receiver alone works
> great but together none does.
> This problem does not exist with the new driver.
> =

I hope Tomi will be able to finalize his patch so we will be able to replac=
e the old one.
The old driver is monolithic and does not follow the dvb framework evolutio=
ns/bug corrections.

> =

> =

> Here's the patch I use, only difference to the one from Michele Scorcia =

> are the line numbers:
> =

Please post this patch in an email with [PATCH] in subject and with the Sig=
ned-off-by: name <email> line so that maintainers get aware of the patch, a=
nd don't miss it.
See: http://www.linuxtv.org/v4lwiki/index.php/How_to_submit_patches

Thanks
Thierry

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
