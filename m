Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Kj28a-0004rk-20
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 03:28:53 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: "Mitchell, J.G." <jgm11@leicester.ac.uk>
In-Reply-To: <8477EDDA0355EC429DA077A1FB414E2E1C5FF01D23@EXC-MBX1.cfs.le.ac.uk>
References: <8477EDDA0355EC429DA077A1FB414E2E1C5FF01D23@EXC-MBX1.cfs.le.ac.uk>
Date: Fri, 26 Sep 2008 03:23:46 +0200
Message-Id: <1222392226.4589.49.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Leadtek DTV1000s Development Help
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


Am Freitag, den 26.09.2008, 02:02 +0100 schrieb Mitchell, J.G.:
> Hello Everyone,
> 
> I bought this card some months back now and I did a bit of research to find out to my dissapointment that it is not supported under Linux. However, I am about to embark on an Embedded Systems Engineering degree and I thought that maybe, developing a device driver for this card would be a good start? Now I have found that this card incorporates the SAA7130, TDA10048 and TDA18271.
> 
> I currently run ArchLinux and have some programming experience, I am reading a couple of books at the moment such as Programming Embedded Systems and C Programming (K&R) so I have a good base to work from and can refer to the books if i need some technical help.
> 
> At the moment I am at a loss to where to start, would somebody be able to point me in the right direction to start working on this project?
> 
> Regards,
> Jack.
> 

Hi Jack,

you have some new combinations here.

To load the saa7134 with i2c_scan=1 could be a start.

"modinfo saa7134"

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
