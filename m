Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KUZ8f-0002xw-KD
	for linux-dvb@linuxtv.org; Sun, 17 Aug 2008 05:41:13 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	4535C180094A
	for <linux-dvb@linuxtv.org>; Sun, 17 Aug 2008 03:40:33 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: vf16 <rvf16@yahoo.gr>
Date: Sun, 17 Aug 2008 13:40:30 +1000
Message-Id: <20080817034031.0BF79104F0@ws1-3.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CX23885 based AVerMedia AVerTV Hybrid Express Slim
 tv card
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

> Hello again.
> No one seems to be interested in my attempts so i must be doing
> something wrong.
> I find hard to locate where i can add a wiki about this card, and a
> simple howto for trying to make this card work.
> It may be my mistake but i find all that i have red insufficient to
> understand how to continue.
> 
> Anyway after thorough examination of the vista driver i ended up in this
> section :
> ;-----------------------------------------------
> ; XC3028 + Afa9013
> ;-----------------------------------------------
> %CX23885.HC81R%=CX23885.HC81_C,
> PCI\VEN_14F1&DEV_8852&SUBSYS_D9391461    ;PCI-e     XCeive_L+FM+Afa9013
> (this is my model : AVer Media AVerTV Hybrid Express Slim HC81R HC81_C)
> 
> After googling around i found the following :
> CX23885 = PCI Express Video and Broadcast Audio Decoder
> http://www.conexant.com/products/entry.jsp?id=393
> http://www.conexant.com/servlets/DownloadServlet/PBR-200865-004.pdf?docid=866&revid=4
> 
> XC3028 = Hybrid tuner
> http://www.xceive.com/technology_XC3028.htm
> http://www.xceive.com/docs/XC3028_prodbrief.pdf
> I have the L model which is same as standard just with "L"ower energy
> consumption)
> 
> Afa9013 = Demodulator
> 
> from linux lspci -n :
> 0c:00.0 0400: 14f1:8852 (rev 02)
>          Subsystem: 1461:d939
> 
> I can find no xc3028 module in the v4l tree and absolutely nothing on
> the Afa9013.
> Please confirm the above are tuner and demodulator chips respectively
> and show me where i can create a wiki with the above info, my dmesg info
> and my card pictures.
> 
> Thank you.
> Regards.

vf16,

The xc3028 is indeed a tuner, the driver module you need for it is the "tuner_xc2028" (note the number is 2028), this also supports the 3028.

For an idea of what you need to do to get this card working, have a look in:
http://linuxtv.org/hg/~stoth/v4l-dvb/
In particular the patch to Add support for the Leadtek Winfast PxDVR 3200 H, this is one that I recently wrote to get the DVB on this card working.

The afa9013 is indeed a demodulator,  however it appears to be currently unsupported.  See this wiki page:
http://www.linuxtv.org/wiki/index.php/Afatech_AF9015

You can create a wiki page at: http://www.linuxtv.org/wiki/index.php
To create a page you need to create a log in, then do a search for the page name, (i.e. "AVerMedia AVerTV Hybrid Express Slim") and click create page.  I think there might be pro formers on what the page should look like somewhere...  To get an idea on what you need to type in click edit on another similar page, such as:
http://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express
The images should be uploaded using the "Upload file" in menu on the left when you are logged in.

Also once you  have created the page update: 
http://www.linuxtv.org/wiki/index.php/AVerMedia
with the link to page and the relevant details, and similar for this one (and others you think are relevant): 
http://www.linuxtv.org/wiki/index.php/DVB-T_PCMCIA_Cards

I hope this helps and hopefully soon the AFA9013 will be supported (I'm not involved in the development of this).

Well that is my two bits of advice,

Regards,
Stephen

-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
