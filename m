Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <moore@free.fr>) id 1NYxOW-0001pW-PL
	for linux-dvb@linuxtv.org; Sun, 24 Jan 2010 09:00:29 +0100
Received: from smtp6-g21.free.fr ([212.27.42.6])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NYxOW-0005fr-31; Sun, 24 Jan 2010 09:00:28 +0100
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 90A6AE08092
	for <linux-dvb@linuxtv.org>; Sun, 24 Jan 2010 09:00:21 +0100 (CET)
Received: from [192.168.1.2] (lns-bzn-50f-62-147-234-34.adsl.proxad.net
	[62.147.234.34])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 78ED5E0808B
	for <linux-dvb@linuxtv.org>; Sun, 24 Jan 2010 09:00:19 +0100 (CET)
Message-ID: <4B5BFE14.30501@free.fr>
Date: Sun, 24 Jan 2010 09:00:20 +0100
From: Chris Moore <moore@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  Looking for original source of an old DVB tree
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

Short version:
I am looking for the original source code of a Linux DVB tree containing 
in particular
     drivers/media/dvb/dibusb/microtune_mt2060.c
and the directory
     drivers/media/dvb/dibusb/mt2060_api

Googling for microtune_mt2060.c and mt2060_api is no help.
Could anyone kindly point me in the right direction, please?

Longer version:
I am trying to get my USB DVB-T stick running on my Xtreamer.
Xtreamer uses an old 2.6.12.6 kernel heavily modified by Realtek and 
possibly also modified by MIPS.
I have the source code but it would be a tremendous effort to change to 
a recent kernel.
The DVB subtree seems to have been dirtily hacked by Realtek to support 
their frontends.
In the process they seem to have lost support for other frontends.
I have been trying to find the source code for the original version.
I have fould nothing resembling it in kernel.org, linux-mips.org and 
linuxtv.org.

TIA.

Cheers,
Chris



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
