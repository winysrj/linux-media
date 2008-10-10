Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ukfsn.org ([77.75.108.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mail@thedesignshop.biz>) id 1KoGD2-0002zr-0U
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 13:31:07 +0200
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 09AB2DF35E
	for <linux-dvb@linuxtv.org>; Fri, 10 Oct 2008 12:31:02 +0100 (BST)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new,
	port 10024) with ESMTP id yB1rtaAydzxX for <linux-dvb@linuxtv.org>;
	Fri, 10 Oct 2008 12:28:59 +0100 (BST)
Received: from [10.0.1.2] (unknown [87.127.119.158])
	by mail.ukfsn.org (Postfix) with ESMTP id CCA40DF348
	for <linux-dvb@linuxtv.org>; Fri, 10 Oct 2008 12:31:01 +0100 (BST)
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <C2BB3D74-2181-4019-9BA3-128805A25931@thedesignshop.biz>
To: linux-dvb@linuxtv.org
From: Public Email <mail@thedesignshop.biz>
Date: Fri, 10 Oct 2008 12:30:58 +0100
Subject: [linux-dvb] Nova-T-500 Remote & dvb-usb-dib0700-1.20.fw
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

Hi. I have just updated to the new firmware and updated the v4l-dvb  
drivers, installed the new modules and done a cold boot.

Everything is working nicely except for the remote. Pressing any key  
once results in constant key repeats. Killing lircd and restarting it  
doesn't stop them (it just carries on repeating the key that was  
pressed before killing lircd). It isn't the remote as removing the  
battery has no effect.

It all worked fine with dvb-usb-dib0700-1.10.fw

Also dmesg is still being flooded with "dib0700: Unknown remote  
controller key:" with both firmwares and the latest drivers and there  
are several "dtv_property_cache_sync()" appearing every 5 mins too.

I am using gentoo with 2.6.24-tuxonice-r9 kernel.

Thanks
Alex

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
