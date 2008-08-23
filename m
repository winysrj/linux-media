Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KWo5H-0003gV-Mz
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 10:02:57 +0200
Received: by rv-out-0506.google.com with SMTP id b25so851696rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 01:02:50 -0700 (PDT)
Message-ID: <bb72339d0808230102q2815cd4et21e756ee70620ae2@mail.gmail.com>
Date: Sat, 23 Aug 2008 18:02:50 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <420693.85765.qm@web28410.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <420693.85765.qm@web28410.mail.ukl.yahoo.com>
Subject: Re: [linux-dvb] hybrid cards/stick experience on Ubuntu?
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

2008/8/23 Lars Oliver Hansen <lolh@ymail.com>:
> Hi,
>
> I could imagine it's not a welcome question but I'm looking for a new DVB-T
> / Composite Analog TV cardbus card or usb card and I'm writing here to ask
> for your experiences with such cards on Ubuntu 8.04. Currently I own an
> AVerMedia E506R yet whatever I did with whoevers help, I didn't get it to
> run properly on Ubuntu 8.04 and I'm against risking my otherwise perfect
> installation with a vanilla kernel as I've got not much Linux experience.
> Problems with my E506R: sometimes it gets powered on on boot, sometimes it
> doesn't. If it gets powered on, tvtimes video is vertically wavy. There is
> no sound due to saa7134-alsa troubles. I'm using mrecs experimental dvb-t
> driver.
>
> Thus: what's your experience with hybrid tv cards under Ubuntu 8.04? Which
> work out-of-the-box, which require a new v4l-dvb package and which require
> some else fiddling ?
>
> Thanks for your help!
>
> Lars
>

Hey,
I'm currently using an AVerMedia Hybrid+FM A16D[1] under Ubuntu 8.04 64bit.
The digital side works great, the analogue side tunes and displays but
I have the same issue with the saa7134-alsa module.  There is a
workaround for the alsa trouble[2], but it involves recompiling the
kernel and modules which not everyone is comfortable doing. It will
also mean going through the process on each kernel update.  Hopefully
Intrepid will resolve this by default.

cheers,
Owen.

Footnotes
--
[1] http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid+FM_PCI
[2] https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/212960

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
