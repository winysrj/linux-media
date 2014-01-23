Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50040 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaAWO31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 09:29:27 -0500
Received: by mail-we0-f176.google.com with SMTP id t61so1245278wes.35
        for <linux-media@vger.kernel.org>; Thu, 23 Jan 2014 06:29:26 -0800 (PST)
Received: from [192.168.0.104] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id kr10sm22731098wjc.22.2014.01.23.06.29.21
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 23 Jan 2014 06:29:24 -0800 (PST)
Message-ID: <52E1273F.90207@googlemail.com>
Date: Thu, 23 Jan 2014 14:29:19 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com> <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse> <52DECF44.1070609@googlemail.com> <52DEDFCB.6010802@googlemail.com> <20140122115334.GA14710@minime.bse> <52DFC300.8010508@googlemail.com> <20140122135036.GA14871@minime.bse> <52E00AD0.2020402@googlemail.com> <20140123132741.GA15756@minime.bse>
In-Reply-To: <20140123132741.GA15756@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/01/14 13:27, Daniel Glöckner wrote:
> On Wed, Jan 22, 2014 at 06:15:44PM +0000, Robert Longbottom wrote:
>> On 22/01/14 13:50, Daniel Glöckner wrote:
>>> This is strange. There are 7 different IRQs assigned to that card but
>>> PCI slots only have 4. According to the pictures each 878A gets one of
>>> these. The .0 and .1 functions of a 878A must always share the same IRQ.
>
> It seems the .1 functions still show the IRQ assigned by the BIOS, while
> the .0 functions had their IRQ reassigned when a driver was bound.
> The .1 IRQ would probably have been reassigned as well if you tried
> to use the audio driver. I don't think this is the problem.
>
> Can you try to load bttv with irq_debug=1?
> This should generate a lot of output.

Yep, /var/log/messages output below.  I rmmod'd bttv, loaded it up 
again, and started up xawtv tv against /dev/video0

Thanks,
Rob.

Jan 23 14:19:40 quad lircd-0.9.0[3479]: removed client
Jan 23 14:19:40 quad lircd-0.9.0[3479]: closing '/dev/input/event0'
Jan 23 14:20:01 quad cron[17963]: (root) CMD (test -x 
/usr/sbin/run-crons && /usr/sbin/run-crons )
Jan 23 14:20:01 quad cron[17967]: (robert) CMD 
(/home/robert/dev/routerMonitor/routerMonitor)
Jan 23 14:23:16 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 23 14:23:29 quad sudo:   robert : TTY=pts/1 ; PWD=/home/robert/tmp ; 
USER=root ; COMMAND=/bin/ls
Jan 23 14:23:29 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 23 14:23:29 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 23 14:23:40 quad sudo:   robert : TTY=pts/1 ; PWD=/home/robert/tmp ; 
USER=root ; COMMAND=/bin/tail /var/log/messages -f
Jan 23 14:23:40 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 23 14:24:08 quad sudo:   robert : TTY=pts/1 ; PWD=/home/robert/tmp ; 
USER=root ; COMMAND=/sbin/rmmod bttv
Jan 23 14:24:08 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 23 14:24:08 quad kernel: [154521.943793] bttv: 7: unloading
Jan 23 14:24:08 quad kernel: [154521.944153] bttv: 6: unloading
Jan 23 14:24:08 quad kernel: [154521.944277] bttv: 5: unloading
Jan 23 14:24:08 quad kernel: [154521.944390] bttv: 4: unloading
Jan 23 14:24:08 quad kernel: [154521.944496] bttv: 3: unloading
Jan 23 14:24:08 quad kernel: [154521.944608] bttv: 2: unloading
Jan 23 14:24:08 quad kernel: [154521.944720] bttv: 1: unloading
Jan 23 14:24:08 quad kernel: [154521.944827] bttv: 0: unloading
Jan 23 14:24:08 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 23 14:24:15 quad sudo:   robert : TTY=pts/1 ; PWD=/home/robert/tmp ; 
USER=root ; COMMAND=/sbin/modprobe bttv irq_debug=1
Jan 23 14:24:15 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 23 14:24:15 quad kernel: [154529.428818] bttv: driver version 0.9.19 
loaded
Jan 23 14:24:15 quad kernel: [154529.428824] bttv: using 8 buffers with 
2080k (520 pages) each for capture
Jan 23 14:24:15 quad kernel: [154529.429451] bttv: Bt8xx card found (0)
Jan 23 14:24:15 quad kernel: [154529.429474] bttv: 0: Bt878 (rev 17) at 
0000:02:0c.0, irq: 16, latency: 32, mmio: 0xd5000000
Jan 23 14:24:15 quad kernel: [154529.429518] bttv: 0: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 23 14:24:15 quad kernel: [154529.465408] bttv: 0: tuner type unset
Jan 23 14:24:15 quad kernel: [154529.465726] bttv: 0: registered device 
video0
Jan 23 14:24:15 quad kernel: [154529.465832] bttv: 0: registered device vbi0
Jan 23 14:24:15 quad kernel: [154529.465862] bits: FMTCHG* HSYNC OFLOW 
  NUML => 625
Jan 23 14:24:15 quad kernel: [154529.469419] bttv: Bt8xx card found (1)
Jan 23 14:24:15 quad kernel: [154529.469436] bttv: 1: Bt878 (rev 17) at 
0000:02:0d.0, irq: 17, latency: 32, mmio: 0xd5002000
Jan 23 14:24:15 quad kernel: [154529.469472] bttv: 1: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 23 14:24:15 quad kernel: [154529.470638] tveeprom 3-0050: Huh, no 
eeprom present (err=-6)?
Jan 23 14:24:15 quad kernel: [154529.470643] bttv: 1: tuner type unset
Jan 23 14:24:15 quad kernel: [154529.470829] bttv: 1: registered device 
video1
Jan 23 14:24:15 quad kernel: [154529.470921] bttv: 1: registered device vbi1
Jan 23 14:24:15 quad kernel: [154529.470949] bits: FMTCHG* HSYNC OFLOW 
  NUML => 625
Jan 23 14:24:15 quad kernel: [154529.474377] bttv: Bt8xx card found (2)
Jan 23 14:24:15 quad kernel: [154529.474395] bttv: 2: Bt878 (rev 17) at 
0000:02:0e.0, irq: 18, latency: 32, mmio: 0xd5004000
Jan 23 14:24:15 quad kernel: [154529.474431] bttv: 2: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 23 14:24:15 quad kernel: [154529.475537] tveeprom 4-0050: Huh, no 
eeprom present (err=-6)?
Jan 23 14:24:15 quad kernel: [154529.475541] bttv: 2: tuner type unset
Jan 23 14:24:15 quad kernel: [154529.475601] bttv: 2: registered device 
video2
Jan 23 14:24:15 quad kernel: [154529.475631] bttv: 2: registered device vbi2
Jan 23 14:24:15 quad kernel: [154529.475661] bits: FMTCHG* HSYNC OFLOW 
  NUML => 625
Jan 23 14:24:15 quad kernel: [154529.479240] bttv: Bt8xx card found (3)
Jan 23 14:24:15 quad kernel: [154529.479261] bttv: 3: Bt878 (rev 17) at 
0000:02:0f.0, irq: 19, latency: 32, mmio: 0xd5006000
Jan 23 14:24:15 quad kernel: [154529.479287] bttv: 3: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 23 14:24:15 quad kernel: [154529.480602] tveeprom 5-0050: Huh, no 
eeprom present (err=-6)?
Jan 23 14:24:15 quad kernel: [154529.480605] bttv: 3: tuner type unset
Jan 23 14:24:15 quad kernel: [154529.480780] bttv: 3: registered device 
video3
Jan 23 14:24:15 quad kernel: [154529.480897] bttv: 3: registered device vbi3
Jan 23 14:24:15 quad kernel: [154529.480927] bits: FMTCHG* HSYNC OFLOW 
  NUML => 625
Jan 23 14:24:15 quad kernel: [154529.484519] bttv: Bt8xx card found (4)
Jan 23 14:24:15 quad kernel: [154529.484539] bttv: 4: Bt878 (rev 17) at 
0000:03:04.0, irq: 17, latency: 32, mmio: 0xd5100000
Jan 23 14:24:15 quad kernel: [154529.484574] bttv: 4: detected: IVC-200 
[card=102], PCI subsystem ID is 0000:a155
Jan 23 14:24:15 quad kernel: [154529.484576] bttv: 4: using: IVC-200 
[card=102,autodetected]
Jan 23 14:24:15 quad kernel: [154529.484744] bttv: 4: tuner absent
Jan 23 14:24:15 quad kernel: [154529.484892] bttv: 4: registered device 
video4
Jan 23 14:24:15 quad kernel: [154529.485476] bttv: 4: registered device vbi4
Jan 23 14:24:15 quad kernel: [154529.485498] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.485507] bits: FMTCHG* HSYNC OFLOW 
  NUML => 625
Jan 23 14:24:15 quad kernel: [154529.486182] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.487665] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.496016] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.497036] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.499118] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.499812] bttv: Bt8xx card found (5)
Jan 23 14:24:15 quad kernel: [154529.499831] bttv: 5: Bt878 (rev 17) at 
0000:03:05.0, irq: 18, latency: 32, mmio: 0xd5102000
Jan 23 14:24:15 quad kernel: [154529.499868] bttv: 5: detected: IVC-200 
[card=102], PCI subsystem ID is 0001:a155
Jan 23 14:24:15 quad kernel: [154529.499870] bttv: 5: using: IVC-200 
[card=102,autodetected]
Jan 23 14:24:15 quad kernel: [154529.500209] bttv: 5: tuner absent
Jan 23 14:24:15 quad kernel: [154529.500430] bttv: 5: registered device 
video5
Jan 23 14:24:15 quad kernel: [154529.500623] bttv: 5: registered device vbi5
Jan 23 14:24:15 quad kernel: [154529.500645] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.501820] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.501871] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.511019] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.512012] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.512177] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.513053] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:15 quad kernel: [154529.514693] bttv: Bt8xx card found (6)
Jan 23 14:24:15 quad kernel: [154529.514713] bttv: 6: Bt878 (rev 17) at 
0000:03:06.0, irq: 19, latency: 32, mmio: 0xd5104000
Jan 23 14:24:15 quad kernel: [154529.514753] bttv: 6: detected: IVC-200 
[card=102], PCI subsystem ID is 0002:a155
Jan 23 14:24:15 quad kernel: [154529.514757] bttv: 6: using: IVC-200 
[card=102,autodetected]
Jan 23 14:24:15 quad kernel: [154529.514997] bttv: 6: tuner absent
Jan 23 14:24:15 quad kernel: [154529.515074] bttv: 6: registered device 
video6
Jan 23 14:24:15 quad kernel: [154529.515120] bttv: 6: registered device vbi6
Jan 23 14:24:15 quad kernel: [154529.515141] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.516408] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.516958] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.526015] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.527013] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.527017] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.527051] bits: VSYNC* HSYNC
Jan 23 14:24:15 quad kernel: [154529.529472] bttv: Bt8xx card found (7)
Jan 23 14:24:15 quad kernel: [154529.529491] bttv: 7: Bt878 (rev 17) at 
0000:03:07.0, irq: 16, latency: 32, mmio: 0xd5106000
Jan 23 14:24:15 quad kernel: [154529.529534] bttv: 7: detected: IVC-200 
[card=102], PCI subsystem ID is 0003:a155
Jan 23 14:24:15 quad kernel: [154529.529538] bttv: 7: using: IVC-200 
[card=102,autodetected]
Jan 23 14:24:15 quad kernel: [154529.529758] bttv: 7: tuner absent
Jan 23 14:24:15 quad kernel: [154529.530220] bttv: 7: registered device 
video7
Jan 23 14:24:15 quad kernel: [154529.530269] bttv: 7: registered device vbi7
Jan 23 14:24:15 quad kernel: [154529.530291] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.531515] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.531913] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 23 14:24:15 quad kernel: [154529.541013] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.542016] bttv: PLL set ok
Jan 23 14:24:15 quad kernel: [154529.542019] bttv: PLL set ok
Jan 23 14:24:15 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 23 14:24:23 quad kernel: [154536.869097] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.886535] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad lircd-0.9.0[3479]: accepted new client on 
/var/run/lirc/lircd
Jan 23 14:24:23 quad lircd-0.9.0[3479]: initializing '/dev/input/event0'
Jan 23 14:24:23 quad kernel: [154536.906316] bits: FMTCHG* HSYNC OFLOW 
  NUML => 525
Jan 23 14:24:23 quad kernel: [154536.906457] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.919968] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.933400] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.946894] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.960337] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.973831] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154536.987282] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.000775] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.014219] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.027715] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.041158] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.054653] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.068097] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.081594] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.095037] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.108533] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.121977] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.135472] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.148916] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.162412] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.175856] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.189351] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.202795] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.216291] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.229736] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.243230] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.256674] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.270170] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.283614] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.297109] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.310554] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.324049] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.337495] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.350990] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.364433] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.377929] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.391373] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:23 quad kernel: [154537.404868] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:23 quad kernel: [154537.418312] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:23 quad kernel: [154537.431808] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:23 quad kernel: [154537.432012] bttv: 0: timeout: drop=0 
irq=44/44, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.445253] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.458748] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.472192] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.485688] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.499132] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.512628] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.526071] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.539567] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.553010] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.566506] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.579952] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.593447] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.606891] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.620386] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.633829] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.647325] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.660770] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.674266] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.687710] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.701206] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.714649] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:23 quad kernel: [154537.728145] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.741589] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.755084] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.768528] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.782024] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.795468] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.808964] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.822407] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.835903] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.849350] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.862843] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.876288] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.889782] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.903228] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154537.916725] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154537.930167] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154537.933017] bttv: 0: timeout: drop=0 
irq=81/81, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.943663] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.957108] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.970602] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.984046] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154537.997542] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.010986] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.024482] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.037926] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.051421] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.064867] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.078361] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.091805] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.105301] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.118745] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.132240] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.145684] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.159181] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.172624] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.186120] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.199563] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.213059] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.226503] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.239999] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.253444] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.266939] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.280383] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.293879] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.307323] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.320818] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.334262] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.347758] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.361201] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.374698] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.388141] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.401637] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154538.415081] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154538.428577] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:24 quad kernel: [154538.435017] bttv: 0: timeout: drop=0 
irq=118/118, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.442020] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.455517] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.468962] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.482458] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.495902] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.509395] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.522840] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.536336] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.549780] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.563275] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.576721] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.590216] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.603659] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.617157] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.630600] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.644094] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.657538] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.671033] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.684479] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.697974] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.711418] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:24 quad kernel: [154538.724914] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.738358] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.751854] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.765298] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.778794] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.792237] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.805734] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.819176] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.832672] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.846116] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.859612] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.873055] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.886552] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.899996] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154538.913492] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154538.926935] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154538.936017] bttv: 0: timeout: drop=0 
irq=155/155, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.940431] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.953875] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.967371] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.980815] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154538.994310] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.007755] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.021251] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.034695] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.048190] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.061638] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.075130] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.088574] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.102068] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.115520] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.129011] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.142451] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.155947] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.169390] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.182886] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.196331] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.209826] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.223271] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.236765] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.250211] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.263708] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.277152] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.290647] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.304091] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.317587] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.331030] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.344526] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.357970] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.371465] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.384911] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.398405] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154539.411850] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154539.425346] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:25 quad kernel: [154539.437019] bttv: 0: timeout: drop=0 
irq=192/192, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.438790] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.452286] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.465730] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.479225] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.492670] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.506165] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.519609] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.533105] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.546549] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.560043] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.573489] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.586985] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.600428] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.613924] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.627369] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.640864] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.654307] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.667804] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.681247] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.694742] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.708186] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.721682] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:25 quad kernel: [154539.735125] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.748621] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.762065] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.775562] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.789002] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.802501] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.815945] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.829441] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.842885] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.856381] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.869825] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.883320] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.896765] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154539.910259] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154539.923704] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154539.937199] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154539.938022] bttv: 0: timeout: drop=0 
irq=230/230, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.950645] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.964140] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.977583] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154539.991079] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.004522] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.018018] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.031462] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.044959] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.058403] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.071900] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.085342] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.098838] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.112281] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.125778] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.139222] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.152717] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.166160] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.179657] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.193100] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.206596] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.220040] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.233536] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.246982] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.260476] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.273922] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.287415] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.300860] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.314355] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.327799] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.341295] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.354740] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.368234] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.381678] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.395174] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.408619] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154540.422113] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154540.435558] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:26 quad kernel: [154540.439018] bttv: 0: timeout: drop=0 
irq=267/267, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.449055] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.462499] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.475995] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.489438] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.502933] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.516378] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.529873] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.543318] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.556813] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.570257] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.583753] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.597196] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.610693] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.624136] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.637632] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.651077] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.664571] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.678015] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.691510] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.704956] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.718451] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:26 quad kernel: [154540.731896] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.745390] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.758835] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.772329] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.785774] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.799269] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.812714] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.826209] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.839654] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.853149] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.866594] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.880089] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.893532] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.907028] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154540.920473] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154540.933969] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154540.940019] bttv: 0: timeout: drop=0 
irq=304/304, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.947413] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.960908] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.974351] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154540.987848] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.001292] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.014787] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.028231] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.041727] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.055171] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.068667] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.082110] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.095607] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.109050] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.122546] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.135991] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.149486] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.162929] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.176426] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.189870] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.203365] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.216809] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.230306] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.243750] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.257245] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.270689] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.284185] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.297628] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.311123] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.324568] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.338063] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.351507] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.365002] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.378452] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.391944] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.405386] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154541.418881] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154541.432325] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:27 quad kernel: [154541.441018] bttv: 0: timeout: drop=0 
irq=341/341, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.445821] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.459265] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.472766] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.486205] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.499700] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.513144] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.526642] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.540085] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.553582] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.567026] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.580521] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.593965] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.607460] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.620906] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.634401] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.647844] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.661339] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.674784] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.688280] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.701725] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.715220] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:27 quad kernel: [154541.728663] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.742159] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.755603] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.769098] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.782542] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.796037] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.809484] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.822979] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.836423] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.849920] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.863362] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.876860] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.890306] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.903798] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154541.917241] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154541.930738] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154541.942011] bttv: 0: timeout: drop=0 
irq=378/378, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.944187] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.957676] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.971121] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.984616] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154541.998060] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.011556] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.025001] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.038495] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.051940] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.065436] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.078880] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.092375] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.105820] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.119314] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.132759] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.146256] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.159699] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.173193] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.186638] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.200133] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.213578] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.227073] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.240518] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.254012] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.267457] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.280953] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.294397] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.307893] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.321337] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.334833] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.348277] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.361772] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.375216] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.388712] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.402157] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154542.415651] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154542.429096] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154542.442591] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:28 quad kernel: [154542.443020] bttv: 0: timeout: drop=0 
irq=416/416, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.456036] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.469531] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.482976] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.496471] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.509915] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.523410] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.536855] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.550349] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.563794] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.577290] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.590734] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.604229] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.617674] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.631169] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.644613] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.658108] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.671553] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.685048] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.698492] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.711989] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:28 quad kernel: [154542.725432] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.738928] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.752372] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.765867] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.779313] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.792808] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.806252] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.819749] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.833191] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.846687] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.860131] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.873626] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.887071] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.900566] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.914009] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154542.927507] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154542.940950] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154542.944017] bttv: 0: timeout: drop=0 
irq=453/453, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.954447] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.967889] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.981385] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154542.994832] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.008325] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.021769] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.035264] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.048708] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.062204] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.075648] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.089143] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.102588] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.116083] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.129528] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.143023] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.156467] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.169963] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.183407] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.196902] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.210347] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.223842] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.237286] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.250782] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.264226] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.277721] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.291165] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.304661] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.318106] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.331601] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.345045] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.358541] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.371985] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.385480] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.398925] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.412421] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154543.425865] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154543.439361] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:29 quad kernel: [154543.445018] bttv: 0: timeout: drop=0 
irq=490/490, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.452805] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.466299] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.479744] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.493239] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.506685] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.520179] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.533623] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.547118] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.560562] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.574058] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.587503] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.600999] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.614442] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.627938] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.641389] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.654878] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.668319] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.681815] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.695259] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.708755] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.722199] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:29 quad kernel: [154543.735695] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.749139] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.762635] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.776080] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.789577] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.803019] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.816516] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.829961] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.843456] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.856901] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.870394] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.883839] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.897335] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.910779] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154543.924275] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154543.937720] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154543.946019] bttv: 0: timeout: drop=0 
irq=527/527, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.951214] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.964658] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.978154] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154543.991597] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.005093] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.018538] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.032033] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.045478] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.058973] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.072416] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.085912] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.099356] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.112853] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.126296] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.139793] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.153235] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.166732] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.180176] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.193671] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.207115] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.220611] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.234055] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.247550] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.260994] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.274491] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.287936] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.301431] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.314874] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.328370] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.341815] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.355309] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.368754] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.382248] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.395693] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.409189] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154544.422633] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154544.436127] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:30 quad kernel: [154544.447016] bttv: 0: timeout: drop=0 
irq=564/564, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.449573] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.463071] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.476514] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.490010] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.503453] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.516948] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.530392] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.543887] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.557332] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.570827] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.584271] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.597767] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.611211] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.624707] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.638151] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.651646] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.665090] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.678586] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.692029] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.705526] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.718970] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:30 quad kernel: [154544.732465] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.745911] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.759408] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.772849] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.786343] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.799787] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.813282] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.826726] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.840222] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.853666] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.867162] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.880606] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.894101] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.907545] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154544.921043] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154544.934486] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154544.947981] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154544.948010] bttv: 0: timeout: drop=0 
irq=602/602, risc=146da000, bits: OFLOW
Jan 23 14:24:31 quad kernel: [154544.961426] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.974924] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154544.988369] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.001863] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.015307] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.028802] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.042247] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.055743] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.069188] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.082682] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.096125] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.109622] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.123068] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.136560] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.150005] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.163500] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.176945] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.190441] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.203884] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.217379] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.230824] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.244320] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.257765] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.271259] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.284704] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.298199] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.311645] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.325139] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.338583] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.352078] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.365524] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.379026] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.392463] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.405959] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.419401] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154545.432898] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154545.446343] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:31 quad kernel: [154545.449019] bttv: 0: timeout: drop=0 
irq=639/639, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.459838] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.473280] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.486779] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.500227] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.513718] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.527165] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.540657] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.554100] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.567598] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.581043] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.594537] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.607982] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.621476] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.634921] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.648421] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.661861] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.675355] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.688799] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.702294] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.715742] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:31 quad kernel: [154545.729234] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.742679] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.756175] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.769619] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.783113] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.796559] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.810053] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.823499] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.836999] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.850440] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.863933] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.877378] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.890872] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.904333] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.917813] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154545.931254] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154545.944749] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154545.950009] bttv: 0: timeout: drop=0 
irq=676/676, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.958195] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.971689] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.985135] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154545.998628] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.012074] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.025568] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.039014] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.052511] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.065955] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.079450] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.092897] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.106394] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.119835] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.133331] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.146775] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.160271] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.173714] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.187210] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.200655] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.214149] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.227600] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.241091] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.254533] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.268029] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.281473] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.294982] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.308416] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.321910] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.335353] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.348847] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.362291] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.375789] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.389233] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.402728] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.416171] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154546.429667] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154546.443111] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:32 quad kernel: [154546.451010] bttv: 0: timeout: drop=0 
irq=713/713, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.456610] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.470050] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.483547] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.496991] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.510487] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.523931] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.537426] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.550875] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.564368] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.577810] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.591305] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.604749] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.618248] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.631689] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.645184] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.658628] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.672123] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.685568] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.699064] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.712509] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:32 quad kernel: [154546.726003] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.739753] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.752948] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.766388] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.779884] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.793328] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.806824] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.820269] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.833761] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.847205] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.860701] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.874145] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.887641] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.901086] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.914582] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154546.928024] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154546.941520] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154546.954009] bttv: 0: timeout: drop=0 
irq=750/750, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.954972] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.968460] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.981906] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154546.995401] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.008844] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.022339] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.035786] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.049279] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.062724] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.076218] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.089663] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.103159] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.116602] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.130099] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.143541] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.157037] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.170482] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.183979] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.197422] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.210923] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.224362] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.237857] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.251301] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.264796] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.278240] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.291736] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.305180] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.318676] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.332119] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.345617] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.359059] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.372555] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.386000] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.399495] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.412938] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154547.426435] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154547.439879] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154547.453373] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:33 quad kernel: [154547.455009] bttv: 0: timeout: drop=0 
irq=788/788, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.466819] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.480313] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.493758] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.507253] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.520698] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.534192] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.547638] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.561133] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.574577] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.588072] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.601517] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.615012] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.628457] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.641952] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.655397] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.668897] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.682336] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.695831] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.709275] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.722772] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:33 quad kernel: [154547.736217] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.749711] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.763155] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.776650] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.790095] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.803591] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.817034] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.830533] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.843975] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.857469] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.870914] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.884410] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.897857] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.911349] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.924793] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154547.938291] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154547.951736] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154547.956010] bttv: 0: timeout: drop=0 
irq=825/825, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.965230] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.978673] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154547.992169] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.005612] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.019107] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.032552] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.046046] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.059491] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.072987] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.086432] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.099927] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.113372] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.126872] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.140312] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.153807] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.167250] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.180747] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.194198] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.207683] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.221128] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.234623] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.248067] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.261564] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.275008] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.288503] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.301947] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.315443] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.328889] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.342384] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.355829] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.369323] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.382769] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.396264] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.409708] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.423203] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154548.436647] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154548.450143] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:34 quad kernel: [154548.457010] bttv: 0: timeout: drop=0 
irq=862/862, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.463588] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.477082] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.490527] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.504022] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.517467] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.530962] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.544406] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.557902] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.571346] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.584849] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.598286] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.611780] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.625226] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.638721] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.652164] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.665661] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.679104] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.692600] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.706044] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.719540] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:34 quad kernel: [154548.732985] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.746479] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.759926] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.773419] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.786864] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.800359] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.813803] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.827298] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.840745] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.854241] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.867685] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.881178] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.894623] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.908119] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.921564] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154548.935058] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154548.948503] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154548.958009] bttv: 0: timeout: drop=0 
irq=899/899, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.962000] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.975442] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154548.988939] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.002382] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.015877] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.029324] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.042817] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.056260] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.069759] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.083201] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.096695] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.110140] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.123637] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.137080] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.150578] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.164020] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.177515] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.190960] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.204455] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.217899] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.231396] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.244840] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.258334] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.271778] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.285278] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.298719] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.312215] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.325659] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.339155] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.352599] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.366094] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.379537] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.393033] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.406479] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.419973] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154549.433419] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154549.446914] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:35 quad kernel: [154549.459010] bttv: 0: timeout: drop=0 
irq=936/936, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.460356] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.473855] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.487299] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.500792] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.514238] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.527733] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.541181] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.554671] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.568120] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.581612] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.595057] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.608550] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.621995] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.635493] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.648934] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.662431] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.675876] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.689369] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.702814] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.716310] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:35 quad kernel: [154549.729755] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.743249] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.756693] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.770189] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.783634] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.797129] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.810576] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.824070] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.837512] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.851012] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.864455] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.877947] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.891392] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.904887] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.918333] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154549.931826] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154549.945272] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154549.958767] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154549.960010] bttv: 0: timeout: drop=0 
irq=974/974, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.972211] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.985705] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154549.999150] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.012646] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.026092] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.039586] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.053030] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.066528] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.079971] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.093464] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.106908] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.120406] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.133849] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.147344] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.160788] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.174283] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.187728] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.201225] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.214668] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.228163] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.241608] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.255103] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.268547] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.282043] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.295487] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.308982] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.322428] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.335922] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.349367] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.362863] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.376305] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.389806] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.403246] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.416742] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.430186] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154550.443696] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154550.457125] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:36 quad kernel: [154550.461012] bttv: 0: timeout: drop=0 
irq=1011/1011, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.470623] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.484063] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.497558] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.511002] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.524498] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.537942] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.551437] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.564881] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.578379] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.591825] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.605324] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.618766] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.632260] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.645705] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.659199] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.672644] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.686137] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.699583] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.713082] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:36 quad kernel: [154550.726524] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.740021] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.753462] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.766958] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.780402] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.793898] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.807342] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.820836] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.834282] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.847776] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.861224] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.874717] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.888160] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.901656] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.915100] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.928595] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154550.942040] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154550.955535] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154550.962009] bttv: 0: timeout: drop=0 
irq=1048/1048, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.968979] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.982477] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154550.995919] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.009414] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.022859] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.036354] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.049801] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.063293] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.076737] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.090233] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.103679] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.117173] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.130618] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.144112] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.157559] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.171055] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.184496] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.197993] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.211437] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.224932] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.238376] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.251872] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.265316] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.278811] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.292256] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.305751] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.319200] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.332691] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.346135] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.359630] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.373075] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.386571] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.400016] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.413510] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.426956] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154551.440449] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154551.453894] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:37 quad kernel: [154551.463014] bttv: 0: timeout: drop=0 
irq=1085/1085, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.467388] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.480833] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.494332] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.507773] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.521268] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.534714] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.548208] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.561653] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.575148] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.588593] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.602090] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.615534] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.629030] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.642473] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.655966] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.669411] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.682908] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.696351] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.709846] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.723292] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:37 quad kernel: [154551.736785] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.750232] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.763726] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.777171] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.790666] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.804111] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.817607] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.831051] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.844545] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.857991] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.871486] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.884930] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.898427] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.911869] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.925363] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154551.938810] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154551.952306] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154551.965017] bttv: 0: timeout: drop=0 
irq=1122/1122, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.965748] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.979243] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154551.992689] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.006184] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.019629] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.033124] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.046567] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.060061] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.073509] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.087002] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.100447] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.113941] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.127389] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.140883] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.154326] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.167821] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.181266] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.194762] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.208207] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.221702] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.235146] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.248642] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.262087] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.275580] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.289025] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.302519] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.315963] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.329459] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.342903] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.356399] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.369843] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.383338] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.396783] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.410280] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.423723] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154552.437219] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154552.450662] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154552.464157] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:38 quad kernel: [154552.466014] bttv: 0: timeout: drop=0 
irq=1160/1160, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.477604] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.491097] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.504542] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.518039] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.531482] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.544977] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.558422] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.571917] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.585361] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.598857] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.612300] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.625797] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.639239] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.652737] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.666183] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.679677] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.693132] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.706618] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.720057] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:38 quad kernel: [154552.733552] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.746996] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.760492] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.773936] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.787432] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.800876] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.814371] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.827815] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.841314] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.854759] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.868254] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.881698] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.895194] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.908638] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.922135] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.935581] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154552.949075] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154552.962518] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154552.967011] bttv: 0: timeout: drop=0 
irq=1197/1197, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.976012] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154552.989459] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.002952] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.016396] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.029893] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.043337] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.056831] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.070279] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.083770] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.097216] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.110711] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.124158] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.137650] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.151095] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.164591] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.178035] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.191531] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.204975] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.218470] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.231914] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.245410] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.258858] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.272349] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.285792] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.299289] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.312734] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.326227] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.339673] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.353169] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.366612] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.380108] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.393555] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.407047] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.420493] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.433989] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154553.447432] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154553.460927] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:39 quad kernel: [154553.468017] bttv: 0: timeout: drop=0 
irq=1234/1234, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.474371] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.487867] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.501313] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.514806] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.528252] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.541747] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.555191] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.568685] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.582131] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.595625] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.609070] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.622565] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.636009] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.649504] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.662949] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.676447] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.689890] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.703386] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.716830] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:39 quad kernel: [154553.730325] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.743770] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.757264] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.770708] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.784204] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.797647] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.811143] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.824587] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.838085] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.851527] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.865022] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.878467] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.891968] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.905407] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.918902] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.932345] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154553.945842] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154553.959286] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154553.969013] bttv: 0: timeout: drop=0 
irq=1271/1271, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.972780] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.986225] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154553.999722] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.013166] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.026660] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.040104] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.053599] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.067048] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.080540] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.093985] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.107482] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.120923] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.134420] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.147864] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.161359] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.174802] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.188301] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.201744] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.215243] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.228682] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.242178] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.255621] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.269117] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.282561] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.296058] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.309501] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.322997] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.336442] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.349936] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.363382] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.376877] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.390320] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.403819] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.417261] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.430756] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154554.444201] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154554.457695] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:40 quad kernel: [154554.470021] bttv: 0: timeout: drop=0 
irq=1308/1308, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.471139] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.484635] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.498083] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.511579] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.525021] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.538515] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.551960] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.565454] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.578899] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.592394] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.605838] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.619334] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.632777] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.646273] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.659717] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.673212] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.686660] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.700153] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.713596] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:40 quad kernel: [154554.727092] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.740537] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.754034] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.767477] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.780973] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.794416] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.807911] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.821356] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.834852] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.848296] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.861793] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.875238] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.888731] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.902176] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.915672] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.929115] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154554.942627] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154554.956054] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154554.969548] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154554.971015] bttv: 0: timeout: drop=0 
irq=1346/1346, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.982995] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154554.996490] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.009935] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.023430] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.036876] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.050369] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.063813] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.077307] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.090751] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.104249] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.117692] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.131187] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.144632] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.158127] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.171572] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.185067] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.198510] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.212011] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.225451] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.238946] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.252390] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.265887] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.279329] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.292826] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.306269] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.319766] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.333209] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.346705] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.360149] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.373645] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.387089] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.400584] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.414029] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.427523] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.440968] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154555.454464] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154555.467908] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:41 quad kernel: [154555.472009] bttv: 0: timeout: drop=0 
irq=1383/1383, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.481403] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.494848] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.508344] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.521788] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.535283] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.548728] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.562224] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.575669] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.589165] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.602607] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.616104] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.629546] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.643044] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.656487] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.669982] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.683427] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.696922] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.710367] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.723860] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:41 quad kernel: [154555.737305] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.750800] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.764245] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.777740] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.791185] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.804681] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.818124] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.831619] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.845065] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.858561] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.872004] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.885501] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.898946] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.912442] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.925884] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.939381] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154555.952823] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154555.966321] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154555.973008] bttv: 0: timeout: drop=0 
irq=1420/1420, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.979763] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154555.993262] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.006701] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.020200] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.033645] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.047139] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.060581] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.074078] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.087523] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.101021] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.114462] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.127957] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.141402] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.154896] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.168343] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.181842] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.195280] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.208775] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.222222] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.235717] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.249162] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.262656] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.276101] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.289594] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.303038] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.316535] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.329978] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.343473] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.356921] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.370415] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.383858] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.397354] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.410799] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.424293] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.437737] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154556.451234] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154556.464679] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:42 quad kernel: [154556.474010] bttv: 0: timeout: drop=0 
irq=1457/1457, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.478174] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.491617] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.505115] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.518560] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.532054] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.545496] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.558992] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.572439] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.585931] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.599376] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.612873] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.626315] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.639810] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.653254] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.666750] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.680194] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.693690] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.707134] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.720630] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:42 quad kernel: [154556.734073] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.747572] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.761015] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.774510] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.787953] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.801450] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.814893] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.828389] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.841832] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.855330] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.868773] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.882270] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.895717] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.909208] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.922651] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.936149] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154556.949591] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154556.963088] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154556.975017] bttv: 0: timeout: drop=0 
irq=1494/1494, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.976531] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154556.990030] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.003474] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.016974] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.030412] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.043909] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.057352] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.070847] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.084290] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.097786] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.111232] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.124725] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.138170] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.151665] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.165109] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.178604] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.192057] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.205545] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.218989] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.232484] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.245928] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.259424] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.272869] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.286364] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.299811] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.313303] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.326748] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.340242] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.353687] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.367181] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.380627] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.394124] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.407566] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.421062] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.434508] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154557.448002] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154557.461445] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154557.474940] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:43 quad kernel: [154557.477020] bttv: 0: timeout: drop=0 
irq=1532/1532, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.488385] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.501883] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.515328] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.528820] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.542266] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.555761] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.569205] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.582704] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.596144] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.609640] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.623083] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.636580] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.650024] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.663518] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.676963] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.690458] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.703903] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.717398] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:43 quad kernel: [154557.730843] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.744337] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.757782] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.771277] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.784722] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.798216] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.811661] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.825157] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.838600] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.852097] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.865540] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.879036] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.892481] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.905976] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.919419] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.932916] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.946361] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154557.959855] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154557.973299] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154557.981020] bttv: 0: timeout: drop=0 
irq=1569/1569, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154557.986795] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.000239] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.013735] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.027181] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.040677] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.054120] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.067618] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.081058] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.094554] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.107999] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.121493] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.134940] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.148434] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.161877] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.175372] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.188818] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.202313] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.215757] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.229253] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.242696] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.256193] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.269637] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.283133] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.296577] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.310072] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.323517] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.337014] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.350458] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.363951] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.377395] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.390892] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.404340] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.417831] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.431275] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.444770] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154558.458215] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154558.471710] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:44 quad kernel: [154558.482016] bttv: 0: timeout: drop=0 
irq=1606/1606, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.485155] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.498651] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.512095] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.525591] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.539041] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.552529] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.565974] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.579470] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.592913] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.606411] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.619853] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.633348] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.646793] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.660289] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.673734] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.687228] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.700673] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.714167] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:44 quad kernel: [154558.727613] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.741107] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.754552] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.768050] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.781491] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.794987] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.808431] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.821925] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.835371] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.848866] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.862310] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.875805] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.889252] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.902746] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.916189] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.929684] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.943129] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154558.956625] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154558.970068] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154558.983020] bttv: 0: timeout: drop=0 
irq=1643/1643, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.983567] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154558.997017] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.010504] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.023948] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.037446] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.050888] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.064384] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.077830] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.091322] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.104768] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.118266] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.131707] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.145203] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.158646] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.172144] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.185588] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.199082] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.212528] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.226022] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.239467] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.252961] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.266406] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.279901] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.293345] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.306841] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.320286] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.333780] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.347226] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.360722] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.374165] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.387659] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.401103] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.414600] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.428043] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.441539] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154559.454982] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154559.468496] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154559.481924] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:45 quad kernel: [154559.484008] bttv: 0: timeout: drop=0 
irq=1681/1681, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.495418] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.508864] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.522358] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.535801] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.549298] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.562743] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.576237] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.589683] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.603179] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.616621] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.630116] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.643561] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.657061] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.670502] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.683997] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.697440] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.710937] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.724382] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:45 quad kernel: [154559.737876] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.751320] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.764818] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.778259] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.791755] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.805200] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.818694] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.832138] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.845633] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.859078] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.872574] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.886019] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.899517] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.912959] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.926456] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.939899] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.953393] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154559.966842] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154559.980334] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154559.985022] bttv: 0: timeout: drop=0 
irq=1718/1718, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154559.993780] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.007274] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.020718] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.034214] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.047658] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.061155] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.074599] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.088092] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.101536] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.115031] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.128476] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.141971] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.155416] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.168913] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.182356] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.195849] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.209295] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.222791] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.236234] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.249729] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.263175] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.276671] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.290116] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.303610] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.317052] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.330548] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.343994] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.357489] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.370932] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.384428] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.397874] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.411372] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.424812] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.438309] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.451751] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154560.465250] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154560.478695] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:46 quad kernel: [154560.486022] bttv: 0: timeout: drop=0 
irq=1755/1755, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.492189] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.505632] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.519127] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.532573] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.546068] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.559510] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.573007] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.586453] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.599946] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.613392] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.626887] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.640330] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.653825] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.667269] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.680765] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.694210] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.707706] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.721149] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:46 quad kernel: [154560.734645] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.748094] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.761585] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.775029] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.788523] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.801970] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.815463] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.828907] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.842403] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.855848] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.869343] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.882786] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.896282] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.909729] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.923223] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.936667] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.950162] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154560.963606] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154560.977103] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154560.989015] bttv: 0: timeout: drop=0 
irq=1792/1792, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154560.990546] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.004044] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.017485] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.030980] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.044425] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.057922] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.071365] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.084860] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.098304] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.111802] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.125246] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.138741] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.152184] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.165681] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.179127] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.192619] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.206068] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.219558] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.233005] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.246500] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.259943] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.273440] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.286883] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.300378] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.313825] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.327321] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.340762] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.354263] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.367702] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.381197] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.394642] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.408137] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.421580] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.435076] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.448521] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154561.462016] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154561.475461] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154561.488956] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:47 quad kernel: [154561.490021] bttv: 0: timeout: drop=0 
irq=1830/1830, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.502401] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.515896] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.529339] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.542834] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.556279] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.569775] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.583219] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.596715] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.610158] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.623654] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.637099] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.650595] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.664040] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.677534] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.690980] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.704473] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.717934] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:47 quad kernel: [154561.731413] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.744858] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.758353] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.771797] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.785293] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.798737] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.812232] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.825680] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.839172] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.852618] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.866113] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.879556] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.893054] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.906495] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.919990] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.933435] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.946930] bits: VSYNC* HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.960376] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:48 quad kernel: [154561.973872] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:48 quad kernel: [154561.987314] bits: VSYNC* HSYNC OFLOW FBUS
Jan 23 14:24:48 quad kernel: [154561.991020] bttv: 0: timeout: drop=0 
irq=1867/1867, risc=146da000, bits: HSYNC OFLOW
Jan 23 14:24:48 quad kernel: [154561.991847] bttv: 0: reset, reinitialize
Jan 23 14:24:48 quad kernel: [154562.493009] bttv: 0: timeout: drop=0 
irq=1867/1867, risc=146da000, bits: VSYNC HSYNC OFLOW FBUS
Jan 23 14:24:48 quad kernel: [154562.493224] bits: FMTCHG* VSYNC HSYNC 
OFLOW FBUS   NUML => 625
Jan 23 14:24:49 quad kernel: [154562.994015] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:49 quad kernel: [154563.496010] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:50 quad kernel: [154563.997020] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:50 quad kernel: [154564.498018] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:51 quad kernel: [154564.999023] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:51 quad kernel: [154565.500024] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:52 quad kernel: [154566.001014] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:52 quad kernel: [154566.502016] bttv: 0: timeout: drop=0 
irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
Jan 23 14:24:52 quad lircd-0.9.0[3479]: removed client
Jan 23 14:24:52 quad lircd-0.9.0[3479]: closing '/dev/input/event0'
Jan 23 14:25:01 quad cron[18695]: (robert) CMD 
(/home/robert/dev/routerMonitor/routerMonitor)


