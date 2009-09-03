Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from node6.gecad.com ([193.230.245.6])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <eduard.budulea@axigen.com>) id 1MjBWW-0000Sk-Ji
	for linux-dvb@linuxtv.org; Thu, 03 Sep 2009 14:34:45 +0200
From: Eduard Budulea <eduard.budulea@axigen.com>
To: Jed <jedi.theone@gmail.com>
In-Reply-To: <4A9FAC48.90309@gmail.com>
References: <18203149.1251714450755.JavaMail.root@ctps3>	
	<4A9FAC48.90309@gmail.com>
Date: Thu, 03 Sep 2009 15:36:47 +0300
Message-Id: <1251981407.3990.82.camel@edi-desktop>
Mime-Version: 1.0
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] saa 7162 chip, recording from s-video
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Thu, 2009-09-03 at 21:45 +1000, Jed wrote:
> Hi Eduard,
> 
> This is not really helping you but I was wondering if you could
> possibly help me?
> 
> I have the QuattroS: 
> http://www.linuxtv.org/wiki/index.php/Saa7162_devices#DNTV_PCI_Express_cards
This looks like the same layout so who knows? worth a try.
> 
> It is from the same family of devices as your card, my questions are
> in-line...
> 
> ----Mensaje original----
> De: eduard.budulea@axigen.com
> Recibido: 31/08/2009 11:35
> Para: <linux-dvb@linuxtv.org>
> Asunto: [linux-dvb] saa 7162 chip, recording from s-video
> 
> Hi, I have this card:Kworld DVB-T PE310.
> On a ubuntu 9.4 system with linux 2.6.28-15-generic.
> I've managed to compile and install the drivers from:
> http://www.jusst.de/hg/saa716x/
> 
> Did you rely on the instructions in the wiki to do this? If not could
> you briefly outline what you did?
I found no wiki.
So what I did:
* take the latest bz2 from the site http://www.jusst.de/hg/saa716x/
* install the linux-headers.
* extract the bz2 in folder, let's say "saaSrc" (this is a placeholder).
* run make in saaSrc.
* it will give an error that it does not find
http://linuxtv.org/hg/v4l-dvb/file/2b49813f8482/linux/drivers/media/dvb/frontends/stv6110x_priv.h
and
http://linuxtv.org/hg/v4l-dvb/file/2b49813f8482/linux/drivers/media/dvb/frontends/stv6110x_reg.h
and
http://linuxtv.org/hg/v4l-dvb/file/2b49813f8482/linux/drivers/media/dvb/frontends/stv6110x.h
and
http://linuxtv.org/hg/v4l-dvb/file/2b49813f8482/linux/drivers/media/dvb/frontends/stv6110x.c
* put the missing files.
* and it should compile.
* make install
* now be prepare to reboot because the driver does not cleanly remove
itself on rmmod.
* modprobe the saa716x_hybrid with verbose (I've put 100) and debug
(I've put 1) and saa716x_core with debug (I've put 1).
* It will probably say nothing to the dmesg because you don't have the
card id put in the sources.
* To put in the sources you have to add a MAKE_ENTRY (@
saa716x_hybrid.c:595).

Here you see the atlantis structure.
>From what I see there are diferent config paths depending of the board.
Atlantis is the nxp reference board so I used it (cloned the MAKE_ENTY
and give the pciIds of my card).

* compile and install and do the modprobe again (now it will load the
driver but if the id is not 46 then it will report what id is that is
wrong) the id is the id of the tda 100046a chip (2 of them) at my board
it was 0xff
* the tda error print is from tda1004x.c:1361.
* I have added at the if my id also so that the error will not happen.
* compile install modprobe.
* after that I had the /dev/dvb/adapter{0,1} folders.

Hope it will work for you.

> 
> I've added my pci id to the driver list (used atlantis config
> structure)
> I also added my tda10046 (actually my chips are tda 100046A, why the
> extra 0?) id (whitch is 0xFF, not 0x46) in tda10046_attach function.
> 
> I think I understand what you're saying here, but how do I determine
> what my PCI & TDA100046A ID's are?
> And what do you mean by Atlantis Config Structure?
> 
> It kind of worked, because it has not crashed and the w_scan give
> output like is working.
> However, I don't know if in my region I have dvb-t.
> 
> I have DVB-T in my area so I can confirm that it works if you help me
> with those prior steps! :-D 
> 
> What I want is to be able to record from an s-video source.
> It should be possible with this card.
> But the card does not export a /dev/videox file (no v4l?)
> It only creates /dev/dvb/adapterx thing.
> So how can I record s-video with this card?
> 
> I am interested in testing AV-in too, so any tips there would also be
> greatly appreciated!

The idea that I have is not an easy one. Fist if the streaming is
working. I want to find out the control register that will comute the
chip from dvb stream to AV one and hopefully at /dev/dvb/adapter0/demux0
I'll get the video stream. After that I have to write a v4l2 driver to
do that.

Have fun.

> 
> 
> Most Sincerely,
> Jed
> 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
