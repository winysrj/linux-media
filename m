Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ianliverton.co.uk>) id 1JZDu4-0005G5-QF
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 00:29:09 +0100
Received: from aamtaout01-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout01-winn.ispmail.ntl.com with ESMTP id
	<20080311233049.RDX16169.mtaout01-winn.ispmail.ntl.com@aamtaout01-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 23:30:49 +0000
Received: from molly.ianliverton.co.uk ([80.1.111.25])
	by aamtaout01-winn.ispmail.ntl.com with ESMTP id
	<20080311233138.SQBX219.aamtaout01-winn.ispmail.ntl.com@molly.ianliverton.co.uk>
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 23:31:38 +0000
Received: from [192.168.1.65] (helo=ians)
	by molly.ianliverton.co.uk with esmtp (Exim 4.69)
	(envelope-from <linux-dvb@ianliverton.co.uk>) id 1JZDtU-0007cX-45
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 23:28:28 +0000
From: "Ian Liverton" <linux-dvb@ianliverton.co.uk>
To: <linux-dvb@linuxtv.org>
Date: Tue, 11 Mar 2008 23:30:16 -0000
Message-ID: <009101c883cf$dfe25480$4101a8c0@ians>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova T-500 detection problem
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

> You will need to edit 
> 
> linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h

Genius!  Thank you very much!  I changed line 127 from

#define USB_PID_HAUPPAUGE_NOVA_T_500		0x9941

To

#define USB_PID_HAUPPAUGE_NOVA_T_500		0x9940

and it worked perfectly.

> A proper dev should probably confirm.

If you need any more information on this card to make it supported "out of
the box", let me know!

Thanks again,

Ian 

Internal Virus Database is out-of-date.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.21.4 - Release Date: 03/03/2008 00:00
 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
