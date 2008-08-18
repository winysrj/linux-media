Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KVCDY-0001pV-0b
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 23:24:49 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	AD14818001CC
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 21:24:09 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Robert Golding" <robert.golding@gmail.com>
Date: Tue, 19 Aug 2008 07:24:09 +1000
Message-Id: <20080818212409.9CAEFBE4078@ws1-9.us4.outblaze.com>
Cc: LinuxTV DVB list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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



> 
> On another note, is it the 'cx23885' that controls 'analog' (aka
> Winfast 107d:66xx series) as well on this card?  Or another chip I
> don't know about?
> 
> The FM Radio would use the 'analog' chip too, wouldn't it?  I was
> given to understand that the cx23885 was a newer version of the
> Conexant 'bt878' continuum, is that correct?
> 
> --
> Regards,	Robert


The cx23885 can control the 'analog' however I think most of the work is performed by the cx23417.

This is all I know about the analog side at the moment. And at least for the next month as a have returned my card to get repaired/replaced due to the SubVendor and SubProduct ids not displaying reliably (in Linux and in Windows).

Feel free to keep digging, if you find anything useful please share (like a patch to get it working...).

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
