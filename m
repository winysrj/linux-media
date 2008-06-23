Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KAmRY-0004aI-Ec
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 15:50:53 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2079517wfd.17
	for <linux-dvb@linuxtv.org>; Mon, 23 Jun 2008 06:50:42 -0700 (PDT)
Message-ID: <bb72339d0806230650s7314e892pf433f8e244cc24a1@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:50:41 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <D28FC8DB666FC448B462784151E59C05024AA87B@exbe07.intra.dlr.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <D28FC8DB666FC448B462784151E59C05024AA87B@exbe07.intra.dlr.de>
Subject: Re: [linux-dvb] Getting Avermedia AverTV E506 DVB-T to work
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

On 23/06/2008, Lukas.Orlowski@dlr.de <Lukas.Orlowski@dlr.de> wrote:
> Hi Community
>
>  I am struggling to enjoy DVB-T on my AverTV E506 PCMCIA card. It seams
>  I'm doing something terribly wrong but I cannot find the solution on my
>  own. I am grateful for any help provided.
>

  I have the AVerMedia AVerTV Hybrid+FM PCI A16D which, from what I
can see, is basically your card in PCI form. (same tuner, same demod,
same driver, same firmware, etc...)

>  What I did so far:
>
>  I'm running Gentoo with a 2.6.24-r8 kernel on my Centrino Laptop. I have
>  selected "Video for Linux" (nothing else, no cards, no frontends, no
>  chips..) as a module in my kernel configuration and compiled the
>  "v4l-dvb" drivers from the mercurial repository. I also have obtained
>  the (hopefully) correct firmware for my card.
>
>  Well when I plug the PCMCIA device in this is what dmesg shows me:
>
[snip dmesg]

  I am successfully using the same firmware your output below shows.

>  xc2028 5-0061: Loading 80 firmware images from xc3028-v27.fw, type:
>  xc2028 firmware, ver 2.7

[snip dmesg]

>
>  Analog TV works with this setup, but I have no signs of DVB-T. No
>  /dev/dvb devices are created although the module for the Zarlink tuner
>  "mt352" is autoloaded when the card is inserted.
>
[snip signoff]

If you see my dmesg output[1] I have a DVB registration after the
analogues. Perhaps the saa7134-dvb module may not be being loaded.
What does the output of `lsmod|grep saa7134` give?
See mine[2], (N.B. I'm missing saa7134-alsa which enables audio for analogue)

cheers,
Owen.

Footnotes:
--
[1] Most of my dmesg section is the same as yours, until here, note
the dvb registration. From my dmesg:
[snip]
Jun 22 17:15:07 kushiel kernel: [ 8490.726157] saa7133[0]: registered
device video0 [v4l2]
Jun 22 17:15:07 kushiel kernel: [ 8490.726178] saa7133[0]: registered
device vbi0
Jun 22 17:15:07 kushiel kernel: [ 8490.726196] saa7133[0]: registered
device radio0
Jun 22 17:15:07 kushiel kernel: [ 8490.787271] xc2028 0-0061:
attaching existing instance
Jun 22 17:15:07 kushiel kernel: [ 8490.787279] xc2028 0-0061: type set
to XCeive xc2028/xc3028 tuner
Jun 22 17:15:07 kushiel kernel: [ 8490.787284] DVB: registering new
adapter (saa7133[0])
[snip]

[2]
saa7134_dvb            25484  12
videobuf_dvb            8708  1 saa7134_dvb
dvb_core               93484  2 saa7134_dvb,videobuf_dvb
saa7134               167644  1 saa7134_dvb
compat_ioctl32         11264  1 saa7134
videodev               37504  3 tuner,saa7134,compat_ioctl32
v4l2_common            14464  2 tuner,saa7134
videobuf_dma_sg        17028  2 saa7134_dvb,saa7134
videobuf_core          23172  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             13328  1 saa7134
ir_common              45444  2 saa7134,ir_kbd_i2c
tveeprom               16900  1 saa7134
i2c_core               28544  8
mt352,saa7134_dvb,tuner_xc2028,tuner,saa7134,v4l2_common,ir_kbd_i2c,tveeprom

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
