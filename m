Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chancleta@gmail.com>) id 1JSgtX-0000D6-QQ
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 00:01:33 +0100
Received: by rv-out-0910.google.com with SMTP id b22so419546rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 15:01:22 -0800 (PST)
Message-ID: <a4ac2da80802221501w2ed2d1b0wdc0cf129bc569f8e@mail.gmail.com>
Date: Sat, 23 Feb 2008 00:01:22 +0100
From: "Daniel Porres" <chancleta@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR 4000 and usb webcam working together?
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

Hi,

Im trying to get working on the same pc, mythtv over a HVR 4000 and a
usb webcam (gspca drivers) in a fresh Ubuntu 7.10. Before installing
the hvr 4000 driver the webcam works fine on /dev/video0, but when I
install hvr 4000 drivers the dev/video0 belongs now to the DVB-T
capturer and I cannot load or reinstall properly the webcam gspca
drivers.
I follow these steps in order to install hvr 4000 ->
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000

Can anyone give me some advice on how I can achive both devices working.

Thanks for your time,
Dani

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
