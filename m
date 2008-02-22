Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.orcon.net.nz ([219.88.242.51] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lennon@orcon.net.nz>) id 1JSi1W-00057o-R8
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 01:13:51 +0100
Received: from Debian-exim by mx1.orcon.net.nz with local (Exim 4.67)
	(envelope-from <lennon@orcon.net.nz>) id 1JSi1I-0001Ns-Fb
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 13:13:36 +1300
Message-ID: <1A18D3EDCF9648E5A25B195A2E4EC42A@CraigPC>
From: "Craig Whitmore" <lennon@orcon.net.nz>
To: "Daniel Porres" <chancleta@gmail.com>,
	<linux-dvb@linuxtv.org>
References: <a4ac2da80802221501w2ed2d1b0wdc0cf129bc569f8e@mail.gmail.com>
In-Reply-To: <a4ac2da80802221501w2ed2d1b0wdc0cf129bc569f8e@mail.gmail.com>
Date: Sat, 23 Feb 2008 12:50:10 +1300
MIME-Version: 1.0
Subject: Re: [linux-dvb] HVR 4000 and usb webcam working together?
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

> Im trying to get working on the same pc, mythtv over a HVR 4000 and a
> usb webcam (gspca drivers) in a fresh Ubuntu 7.10. Before installing
> the hvr 4000 driver the webcam works fine on /dev/video0, but when I
> install hvr 4000 drivers the dev/video0 belongs now to the DVB-T
> capturer and I cannot load or reinstall properly the webcam gspca
> drivers.
> I follow these steps in order to install hvr 4000 ->
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
>
> Can anyone give me some advice on how I can achive both devices working.

If you have 2 devices then the 1st one will take /dev/video0 and the next 
will take /dev/video1 usually. BTW. the /dev/video is not the DVB-T device.. 
its the Composite/Analog TV interface. What happens when you try and load 
the webcam after then HVR4000?

Thanks


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
