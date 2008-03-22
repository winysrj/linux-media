Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1Jd1wZ-0001gP-Rd
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 12:31:26 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1443647fge.25
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 04:31:19 -0700 (PDT)
Message-ID: <47E4EE00.9080207@gmail.com>
Date: Sat, 22 Mar 2008 12:31:12 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200803212024.17198.christophpfister@gmail.com>
In-Reply-To: <200803212024.17198.christophpfister@gmail.com>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Christoph Pfister schrieb:
> Hi,
> 
> Can somebody please pick up those patches (descriptions inlined)?
> 
> Thanks,
> 
> Christoph

diff -r 1886a5ea2f84 -r f252381440c1 linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:29:15 2008 +0100
@@ -178,7 +178,7 @@ static int ciintf_read_cam_control(struc
  	udelay(1);

  	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 3, 1, 0, 0);
-	if ((result == -ETIMEDOUT) || ((result == 0xff) && ((address & 3) < 2))) {
+	if ((result == -ETIMEDOUT) || ((result == 0xff) && ((address & 3) == 1))) {
  		ciintf_slot_shutdown(ca, slot);
  		printk(KERN_INFO "budget-av: cam ejected 3\n");
  		return -ETIMEDOUT;


IMHO you should remove the test for 0xff . Without your patch, it wasn't possible to read 
0xff from address 0 and 1. Now it isn't possible to read 0xff from address 1.

I've described this problem some time ago: 
http://linuxtv.org/pipermail/linux-dvb/2007-July/019436.html

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
