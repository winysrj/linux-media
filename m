Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp3.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1KB4Cz-0001zr-9A
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 10:49:04 +0200
Message-ID: <4860B4DA.10004@avalpa.com>
Date: Tue, 24 Jun 2008 10:48:26 +0200
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] OpenCaster (transport stream modder server) ver 1.0 has
	been released..
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

I'm Andrea Venturi, i've been working with my colleague Lorenzo Pallara,
since 2004, on a free DVB TS server software called JustDvb-It. Then
early this year we have been start-upping a company doing the same stuff.

So today, after some more development, we are proud to announce the
birth of OpenCaster
<http://www.avalpa.com/the-key-values/15-free-software/33-opencaster>
version 1.0, the first release after Avalpa start up.

http://www.avalpa.com/component/content/article/12-newsflash/35-opencaster-ver10-release-today-2062008


OpenCaster is still a free (free as freedom
<http://www.gnu.org/licenses/gpl-2.0.html>) software for transport
stream generation and management useful for many purposes: carousel
server, PSI table generator, datacasting, MPEG2 "poor man" playout system.

OpenCaster of course, grows on top of JustDvb-It
<http://www.cineca.tv/labs/mhplab/JustDVb-It%202.0.html>, the previous
free software we were carrying on in Cineca (kudos for them to give us
this great opportunity!)

Actually there are three main new features :

    * *TS conversion (with right PCR) of ffmpeg
      <http://ffmpeg.mplayerhq.hu/> encoded PS (PCR stamping in ffmpeg
      TS is someway  broken!)*
    * *PCR stamping for Transport Stream bitrate change*
    * *hot multplexing of many SPTS in a single MPTS*

Many more smaller ones are well embedded in the software (please read
all the description files like *Readme* and *CHANGES*)

We made a manual too, after many requests. It's a 70 page user manual
and should be useful to ramp up quickly

http://www.avalpa.com/assets/freesoft/opencaster/OpenCasterUserManual-v0.5.pdf


To get this stuff, create an account
<http://www.avalpa.com/component/user/?task=register> and then go to the
reserved area <http://www.avalpa.com/reserved-area>. Please, *it could
take some time* for the registration email to get delivered. Don't
worry, it works.

Let us know when you find a bug or some unexpected result. Write to
opencaster-support@avalpa.com

We are wide open to hear your complaints or success stories!

Bye

Andrea Venturi

 





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
