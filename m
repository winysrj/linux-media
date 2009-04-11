Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <foceni@gmail.com>) id 1LsbI4-0004Iw-AV
	for linux-dvb@linuxtv.org; Sat, 11 Apr 2009 13:22:29 +0200
Received: by yx-out-2324.google.com with SMTP id 8so986255yxm.41
	for <linux-dvb@linuxtv.org>; Sat, 11 Apr 2009 04:22:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E04D12.5050108@ewetel.net>
References: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>
	<49DF9CB7.5080802@ewetel.net>
	<621110570904101437g5843eb21h8a0c894cc9bb48d@mail.gmail.com>
	<49E04D12.5050108@ewetel.net>
Date: Sat, 11 Apr 2009 13:22:23 +0200
Message-ID: <621110570904110422k29a6c341s44762676fed13252@mail.gmail.com>
From: Dave Lister <foceni@gmail.com>
To: Hartmut <spieluhr@ewetel.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
Reply-To: linux-media@vger.kernel.org
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

2009/4/11 Hartmut <spieluhr@ewetel.net>:
> I tried the multiproto-driver first and had not very good results. This
> driver is out for some month. I installed then the liplianin-driver via hg
> clone as shown at the following page:
>
> http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Dri=
vers
>
> That worked at once.
>
> lspci:
> 00:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
> Bridge Controller [Ver 1.0] (rev 01)
> =A0=A0=A0=A0=A0=A0=A0 Subsystem: Device 1ae4:0003
> =A0=A0=A0=A0=A0=A0=A0 Flags: bus master, medium devsel, latency 32, IRQ 17
> =A0=A0=A0=A0=A0=A0=A0 Memory at fb000000 (32-bit, prefetchable) [size=3D4=
K]
> =A0=A0=A0=A0=A0=A0=A0 Kernel driver in use: Mantis
> =A0=A0=A0=A0=A0=A0=A0 Kernel modules: mantis
>
> dmesg:
> mantis stop feed and dma
> stb6100_set_bandwidth: Bandwidth=3D51610000
> stb6100_get_bandwidth: Bandwidth=3D52000000
> stb6100_get_bandwidth: Bandwidth=3D52000000
> stb6100_set_frequency: Frequency=3D1944000
> stb6100_get_frequency: Frequency=3D1944000
> stb6100_get_bandwidth: Bandwidth=3D52000000
> mantis start feed & dma
>

Well, it seems we have the same exact card (HW revision), but it did
not work with liplianin in my setup. It works for you, that's why I
was asking about the components in your setup. I really need to know
your kernel version + its distrib. revision ("cat /proc/version") and
the revision of your working liplianin copy ("cd
your-liplianin-source; hg log | head").

My setup:
Linux version 2.6.26-1-686 (Debian 2.6.26-9) (waldi@debian.org)
liplianin-s2: 11145:2866ecb5e66b (Sun Mar 15 18:24:26 2009)

Be quite grateful if you could furnish me with this basic info. Don't
forget to "CC: linux-dvb@linuxtv.org" when replying to me. :)

Best regards,

-- =

David Lister

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
