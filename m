Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [81.2.121.150] (helo=mail.firshman.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@firshman.co.uk>) id 1JWgAe-0001js-Eb
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 00:03:44 +0100
Received: from macbook.intra ([192.168.211.179])
	by mail.firshman.co.uk with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63) (envelope-from <ben@firshman.co.uk>) id 1JWgAZ-0004jo-ES
	for linux-dvb@linuxtv.org; Tue, 04 Mar 2008 23:03:36 +0000
Message-Id: <C34A2B56-5B39-4BE4-BACD-4E653F61FB03@firshman.co.uk>
From: Ben Firshman <ben@firshman.co.uk>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47C4661C.4030408@philpem.me.uk>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Tue, 4 Mar 2008 23:03:34 +0000
References: <47A98F3D.9070306@raceme.org>
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>	<1202330097.4825.3.camel@anden.nu>
	<47AB1FC0.8000707@raceme.org>	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

I am quite disappointed to report that one of my tuners has just died  =

this evening. No error messages to speak of.

Ben

On 26 Feb 2008, at 19:18, Philip Pemberton wrote:

> Patrik Hansson wrote:
>> Just wanted to say that I=B4m experiencing the same.
>> Using latest rev (the one with patches merged) + unknown remote key  =

>> patch.
>> Ubuntu 7.10
>>
>> Also having a lot of "prebuffer timeout 10 times" i the middle of  =

>> shows.
>
> I think I might have a workaround... On Mythbuntu or one of the many  =

> Ubuntu
> variants, this seems to work:
>
> 1)  Run:
>       lsmod |grep usbcore
>
> 2)  If step 1 produced any output that started with 'usbcore', then  =

> usbcore is
> loaded as a module. Perform step 3a. Otherwise, step 3b.
>
> 3a) Create a text file called /etc/modprobe.d/local-dvb (the name is  =

> fairly
> irrelevant). Insert one line of text into it:
>       options usbcore autosuspend=3D-1
>     Now go to step 4.
>
> 3b) Your kernel has usbcore built in. That means you have to modify  =

> the kernel
> command line...
>     Edit /boot/grub/menu.lst (you'll need to sudo to do this).  =

> Search for
> this line:
> # defoptions=3Dquiet splash
>     Amend it to read:
> # defoptions=3Dquiet splash usbcore.autosuspend=3D-1
>     It's meant to be commented out, so leave the hash at the  =

> beginning of the
> line alone... Save and exit, then run ...
> sudo update grub
>     Ubuntu will regenerate grub.conf, using the new kernel command  =

> line. Off
> to step 4 you go!
>
>     If you're using a non-Debian distro (e.g. Fedora), do the same  =

> thing but
> edit the 'kernel' line instead. It might read:
> kernel          /boot/vmlinuz-2.6.24-8-generic root=3DLABEL=3D/ ro quiet  =

> splash
>     Change it to:
> kernel          /boot/vmlinuz-2.6.24-8-generic root=3DLABEL=3D/ ro quiet  =

> splash
> usbcore.autosuspend=3D-1
>
> 4)  Reboot your PC.
>
> This is a bit long-winded, but saves a kernel recompile, and a ton  =

> of messing
> around recompiling kernels when Ubuntu do another release.
>
> I'm working on what I consider to be a better fix, which involves  =

> using the
> kernel's Quirks function to disable USB suspend just for the DiBcom
> controllers. That is, the kernel won't try and suspend them at all...
>
> Thanks,
> -- =

> Phil.                         |  (\_/)  This is Bunny. Copy and  =

> paste Bunny
> lists@philpem.me.uk           | (=3D'.'=3D) into your signature to help  =

> him gain
> http://www.philpem.me.uk/     | (")_(") world domination.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
