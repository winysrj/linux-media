Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JaqdL-0003Bp-Ir
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 12:02:32 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JaqdG-0006BC-ET
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 11:02:26 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id E36B01AFDB01
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 11:03:21 +0000 (GMT)
Message-ID: <47DCFE62.6020405@philpem.me.uk>
Date: Sun, 16 Mar 2008 11:02:58 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] CX88 (HVR-3000) -- strange errors in dmesg
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
   I've just noticed an absolute ton of these messages in dmesg, can anyone 
tell me what's going on, or what they mean?

[  123.404000] cx88[0]: irq pci [0x1000] brdg_err*
[  123.404000] cx88[0]: irq pci [0x1000] brdg_err*
[  123.412000] cx88[0]: irq pci [0x1000] brdg_err*
[  123.412000] cx88[0]: irq pci [0x1000] brdg_err*

(repeat ad nauseum)

Kernel 2.6.22-14-generic, Hg 11fdae6654e8 with HVR-3000 patches from 
dev.kewl.org/hauppauge merged in manually.

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
