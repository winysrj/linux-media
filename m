Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JptSW-0003Fe-QC
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 01:05:34 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2816622rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 26 Apr 2008 16:05:28 -0700 (PDT)
Message-ID: <d9def9db0804261605u4fd7e856h4c564f5c2fe3c0df@mail.gmail.com>
Date: Sun, 27 Apr 2008 01:05:28 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steffen Schulz" <pepe_ml@gmx.net>
In-Reply-To: <d9def9db0804261517m234e918cl2ebdfad65d9651af@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080426141433.GA14917@cbg.dyndns.org>
	<d9def9db0804261236l527b7deew67d1c9df4ea66460@mail.gmail.com>
	<20080426202638.GA27566@cbg.dyndns.org>
	<d9def9db0804261351l7cb47ad7s457f67db5b423cb2@mail.gmail.com>
	<20080426214724.GA4087@cbg.dyndns.org>
	<d9def9db0804261517m234e918cl2ebdfad65d9651af@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] crash with terratec cinergy hybrid XS [0ccd:0042]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 4/27/08, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 4/26/08, Steffen Schulz <pepe_ml@gmx.net> wrote:
> > On 080426 at 23:00, Markus Rechberger wrote:
> > > cd xc3028
> > > make
> > > insmod xc3028-tuner.ko
> > >
> > > and replug your device.
> >
> > Cool, this actually works. The driver seems very unstable though.
> > Somewhere between replugging and rmmod, in case it helps:
> >
> > xc3028 I2C read failed
> > zl10353: write to reg 62 failed (err = -71)!
> > zl10353: write to reg 5f failed (err = -71)!
> > zl10353: write to reg 71 failed (err = -71)!
> > zl10353_read_register: readreg error (reg=6, ret==-71)
> > zl10353_read_register: readreg error (reg=10, ret==-71)
> > zl10353_read_register: readreg error (reg=11, ret==-71)
> > zl10353_read_register: readreg error (reg=16, ret==-71)
> > zl10353_read_register: readreg error (reg=17, ret==-71)
> > zl10353_read_register: readreg error (reg=18, ret==-71)
> > zl10353_read_register: readreg error (reg=19, ret==-71)
> > zl10353_read_register: readreg error (reg=20, ret==-71)
> > zl10353_read_register: readreg error (reg=21, ret==-71)
> > zl10353: write to reg 62 failed (err = -71)!
>
> device node locking is uncommented in the driver, this can cause some
> troubles with newer kernels... I'll put it in within the next hour
> including powermanagement.for that device.
>

ok it is enabled for devices and kernels >=2.6.21.
also be sure that following file contains a 0 and no other value,
otherwise device node locking will be kinda useless.

$ sudo echo 0 > /sys/module/dvb_core/parameters/dvb_shutdown_timeout

Markus
> > usb 7-1.1.4: USB disconnect, address 18
>
> ok here we have a disconnect
>
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000000
> > printing eip: f8b86369 *pde = 00000000
> > Oops: 0000 [#1] SMP
> > Modules linked in: twofish twofish_common serpent blowfish des_generic
> > ecb xcbc md5 hmac em28xx_dvb em28xx xc3028_tuner dvb_core drx3973d
> > lgdt3304_demod(P) zl10353_demod videodev bridge llc nvidia(P) i2c_core
> > deflate zlib_deflate zlib_inflate crypto_hash af_key dm_snapshot
> > applesmc led_class appletouch input_polldev fuse aes_generic coretemp
> > hwmon compat_ioctl32 v4l1_compat v4l2_common usbhid snd_hda_intel
> > wlan_scan_sta ath_rate_sample snd_pcm_oss snd_mixer_oss snd_pcm
> > snd_timer snd soundcore snd_page_alloc ehci_hcd sky2 ath_pci wlan
> > ath_hal(P) uhci_hcd usbcore backlight intel_agp agpgart
> >
> > Pid: 8486, comm: rmmod Tainted: P        (2.6.24.4-mactel #3)
> > EIP: 0060:[<f8b86369>] EFLAGS: 00210206 CPU: 1
> > EIP is at dvb_unregister_device+0x19/0x60 [dvb_core]
> > EAX: 00000000 EBX: f5c6de80 ECX: f8bf7e20 EDX: 0d400000
> > ESI: f6f9ea98 EDI: f59bb000 EBP: e0c14000 ESP: e0c15f14
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> >  Process rmmod (pid: 8486, ti=e0c14000 task=f7d38570 task.ti=e0c14000)
> >  Stack: 00000000 f8b8f8dd c035b32c 00000001 c03ade57 c0154e30 e0c15f9c
> > 00000000
> >         f6f9e800 f89e824f c0154e30 f89eb2e0 00000000 00000000 f8bdf12c
> > f89eb340
> >         f8830000 f89eb340 c0154932 38326d65 645f7878 00006276 c016bfe1
> > b7f32000
> > Call Trace:
> > [<f8b8f8dd>] dvb_net_release+0x1d/0xa0 [dvb_core]
>
> this bug moreover seems to be dvb_core related... the deregistration
> of dvbnet happens before anything else gets freed in the em2880-dvb
> driver.
>
> > [<c035b32c>] wait_for_common+0x1c/0x120
> > [<c0154e30>] __try_stop_module+0x0/0x80
> > [<f89e824f>] em2880_dvb_fini+0x2f/0x100 [em28xx_dvb]
> > [<c0154e30>] __try_stop_module+0x0/0x80
> > [<f8bdf12c>] em28xx_unregister_extension+0x3c/0x80 [em28xx]
> > [<c0154932>] sys_delete_module+0x112/0x1c0
> > [<c016bfe1>] remove_vma+0x41/0x50
> > [<c016caf0>] do_munmap+0x180/0x1f0
> > [<c01053a6>] sysenter_past_esp+0x6b/0xa1
> >  =======================
> >  Code: e8 9d 54 7d c7 89 d8 83 c4 14 5b 5e 5f 5d c3 8d 76 00 85 c0 53 89
> c3
> >        74 4a 8b 50 14 c1 e2 04 0b 50 10 8b 40 0c 81 ca 00 00 40 0d <8b> 00
> >        c1 e0 06 09 c2 a1 c4 99 b9 f8 e8 36 ae 71 c7 8b 43 04 8b
> > EIP: [<f8b86369>] dvb_unregister_device+0x19/0x60 [dvb_core]  SS:ESP
> > 0068:e0c15f14
> > ---[ end trace 8105d0de6db48a92 ]---
> >
> >
> > --
> > In truth, death may be the only true freedom there is.
> > 				- Kaworu Nagisa
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
