Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <danjde@msw.it>) id 1WwXrs-0007VO-Ke
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2014 16:26:41 +0200
Received: from x1.w4w.guest.it ([77.95.174.1])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-6) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1WwXrr-0000xt-3O; Mon, 16 Jun 2014 16:26:40 +0200
Received: from [185.5.61.116] (helo=[192.168.1.33])
	by x1.w4w.guest.it with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.82) (envelope-from <danjde@msw.it>) id 1WwXrl-0000Ld-7t
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2014 16:26:33 +0200
Message-ID: <539EFE93.1050009@msw.it>
Date: Mon, 16 Jun 2014 16:26:27 +0200
From: Davide Marchi <danjde@msw.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1402912801.19751.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1402912801.19751.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Usb-dvb Pinnacle PCTV 200e
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

linux-dvb-request@linuxtv.org ha scritto:
> linux-dvb-request@linuxtv.org  ha scritto:
>> >If drivers are still not in the kernel, you will have to build those mo=
dules. Here you can find a guide for that:
>> >http://ubuntuforums.org/showthread.php?t=3D1301793
> Thanks Kalman Takacs,
Hi Kalman Takacs,
I've followed the post steps, but obtain some errors on build process.

Here the output, could you give me any suggestion? :-)

thanks!


sudo dkms build -m pctv200e -v 20080520

Kernel preparation unnecessary for this kernel.  Skipping...

Building module:
cleaning build area....
make KERNELRELEASE=3D3.13.0-24-generic -C /lib/modules/3.13.0-24-generic/bu=
ild M=3D/var/lib/dkms/pctv200e/20080520/build....(bad exit status: 2)
ERROR (dkms apport): binary package for pctv200e: 20080520 not found
Error! Bad return status for module build on kernel: 3.13.0-24-generic (i68=
6)
Consult /var/lib/dkms/pctv200e/20080520/build/make.log for more information.

#cat  /var/lib/dkms/pctv200e/20080520/build/make.log

DKMS make.log for pctv200e-20080520 for kernel 3.13.0-24-generic (i686)
lun 16 giu 2014, 16.18.36, CEST
make: ingresso nella directory "/usr/src/linux-headers-3.13.0-24-generic"
   LD      /var/lib/dkms/pctv200e/20080520/build/built-in.o
   CC [M]  /var/lib/dkms/pctv200e/20080520/build/pctv200e.o
gcc: fatal error: no input files
compilation terminated.
make[1]: *** [/var/lib/dkms/pctv200e/20080520/build/pctv200e.o] Errore 4
make: *** [_module_/var/lib/dkms/pctv200e/20080520/build] Errore 2
make: uscita dalla directory "/usr/src/linux-headers-3.13.0-24-generic"
/var/lib/dkms/pctv200e/20080520/build/make.log (END)

ciao!
  =


-- =

firma

cosmogoniA <http://www.cosmogonia.org/>
noprovarenofareononfarenonc'=E8provare

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
