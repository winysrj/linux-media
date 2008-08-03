Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1KPaot-0005Y9-1a
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 12:28:13 +0200
Message-ID: <005901c8f553$8af7de90$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: "Antti Palosaari" <crope@iki.fi>,
	"Markus Oliver Hahn" <markus.o.hahn@gmx.de>,
	"Arthur Konovalov" <artlov@gmail.com>, <linux-dvb@linuxtv.org>
References: <008401c8ebe5$4e09ea90$450011ac@ad.sytec.com>	<003001c8ecb2$57b93af0$7501010a@ad.sytec.com><003401c8ee3d$7f98b870$7501010a@ad.sytec.com><488C5B02.4080506@gmail.com>
	<005901c8f45a$7b869270$7501010a@ad.sytec.com>
Date: Sun, 3 Aug 2008 21:27:13 +1200
MIME-Version: 1.0
Subject: Re: [linux-dvb] THINGS ARE LOOKING UP!!682Mhz problem withTT-1501
	driver inv4l-dvb
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

>>>>> I have patched the v4l-dvb driver with Sigmund Augdal's changes to
>>>>> support
>>>>> C-1501.  I can't get channels to work on all but one frequency -
>>>>> 682Mhz.
>>>>> Frequencies which work:  578, 586, 594, 602, 610, 626, 634, 642, 666,
>>>>> 674
>>>>> Mhz.
>>
>> You are not alone with this problem.
>> I haven't signal on two more frequencies: 322 and 386 MHz
>>
>> AK
>
> Is this a hardware problem?  Has anyone tried it on a Windows machine??

I was mucking around with some patches to dvb_ca_en50221.c and saa7146_i2c.c 
which introduce some 'msleep(1)' delays when communicating with the CAM, and 
in the process firmed up some of the cable connections, and I'm now getting 
a picture on some 682Mhz channels.  Looks like it might have been mostly an 
electrical problem.

I am getting some new weird problems with occasional no audio when I tune to 
a channel, but this might yet be signal, VDR or vdr-xine.  Will keep you 
posted!


Thanks

Simon 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
