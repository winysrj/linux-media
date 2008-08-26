Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.linuxnewmedia.com.br ([189.14.98.138] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lsiqueira@linuxnewmedia.com.br>) id 1KY6XB-0000Ak-Qs
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 23:57:07 +0200
Received: from titan.linuxnewmedia.com.br (c95300e2.virtua.com.br
	[201.83.0.226])
	by mail.linuxnewmedia.com.br (Postfix) with ESMTP id 6EAD629B679
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 18:56:58 -0300 (BRT)
Received: from localhost (localhost [127.0.0.1])
	by titan.linuxnewmedia.com.br (Postfix) with ESMTP id AA5B7211F4
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 19:00:46 -0300 (BRT)
Received: from titan.linuxnewmedia.com.br ([127.0.0.1])
	by localhost (titan.linuxnewmedia.com.br [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id lZFow4JNkHx0 for <linux-dvb@linuxtv.org>;
	Tue, 26 Aug 2008 19:00:46 -0300 (BRT)
Received: from [192.168.1.152] (luciano-laptop.intra.linuxnewmedia.com.br
	[192.168.1.152])
	by titan.linuxnewmedia.com.br (Postfix) with ESMTP id 3B970211E9
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 19:00:46 -0300 (BRT)
Message-ID: <48B47C99.8040006@linuxnewmedia.com.br>
Date: Tue, 26 Aug 2008 18:58:49 -0300
From: Luciano Siqueira <lsiqueira@linuxnewmedia.com.br>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems with a Yuan USB stick
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

Hi everybody,

I'm having trouble with a USB device I bought here in Brasil. It's a 
hybrid DVB-T USB stick.

Linux recognizes it as:

ID 1164:0918 YUAN High-Tech Development Co., Ltd

As it doesn't have a related module, I just tried to change de ID in the 
module header files of the working Yuan device to mine. Then the module 
seems to work, but a firmware is still missing and the device doesn't 
work at all.

Thanks in advance.

-- 
Luciano Siqueira                 | lsiqueira@linuxnewmedia.com.br
Editor                           | Tel.:  +55 (0) 11 4082 1300
Linux New Media do Brasil Ltda.  | Fax :  +55 (0) 11 4082 1302
http://www.linuxnewmedia.com.br/ | http://www.linuxmagazine.com.br/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
