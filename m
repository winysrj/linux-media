Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1Jd3XO-00058I-D7
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 14:13:31 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1471509fge.25
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 06:13:27 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 14:13:24 +0100
References: <200803212024.17198.christophpfister@gmail.com>
	<47E4EE00.9080207@gmail.com>
In-Reply-To: <47E4EE00.9080207@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803221413.24352.christophpfister@gmail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Am Samstag 22 M=E4rz 2008 schrieb e9hack:
> Christoph Pfister schrieb:
> > Hi,
> >
> > Can somebody please pick up those patches (descriptions inlined)?
> >
> > Thanks,
> >
> > Christoph
>
> diff -r 1886a5ea2f84 -r f252381440c1
> linux/drivers/media/dvb/ttpci/budget-av.c ---
> a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 08:04:55 2008 -0300
> +++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:29:15 2008
> +0100 @@ -178,7 +178,7 @@ static int ciintf_read_cam_control(struc
>   	udelay(1);
>
>   	result =3D ttpci_budget_debiread(&budget_av->budget, DEBICICAM, addres=
s &
> 3, 1, 0, 0); -	if ((result =3D=3D -ETIMEDOUT) || ((result =3D=3D 0xff) &&=
 ((address
> & 3) < 2))) { +	if ((result =3D=3D -ETIMEDOUT) || ((result =3D=3D 0xff) &&
> ((address & 3) =3D=3D 1))) { ciintf_slot_shutdown(ca, slot);
>   		printk(KERN_INFO "budget-av: cam ejected 3\n");
>   		return -ETIMEDOUT;
>
>
> IMHO you should remove the test for 0xff . Without your patch, it wasn't
> possible to read 0xff from address 0 and 1. Now it isn't possible to read
> 0xff from address 1.

Address 1 is the status register; bits 2-5 are reserved according to en5022=
1 =

and should be zero, so this case is less problematic with regards to 0xff =

checking.

On second thoughts it's probably better to remove the check altogether, =

because a) budget-av isn't here to check standards conformance - the higher =

layers know better how to deal with the content and b) who should care if t=
he =

other status bits work correctly ;)

> I've described this problem some time ago:
> http://linuxtv.org/pipermail/linux-dvb/2007-July/019436.html

Argh, would have saved some work for me ...

> -Hartmut

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
