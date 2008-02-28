Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JUpXp-0000u0-H5
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 21:39:57 +0100
Received: from [192.168.1.70] (ashley.powercraft.nl [84.245.7.46])
	by ashley.powercraft.nl (Postfix) with ESMTP id D96231C814
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 21:39:53 +0100 (CET)
Message-ID: <47C71C18.90607@powercraft.nl>
Date: Thu, 28 Feb 2008 21:39:52 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] v4l-dvb-experimental will not compile on debian sid
	2.6.24-1-686
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

cd $HOME
hg clone http://mcentral.de/hg/~mrec/v4l-dvb-experimental
cd v4l-dvb-experimental
make
sudo make install

v4l-dvb-experimental will not compile on debian sid 2.6.24-1-686

If you guys need more information i will sent it to the list.

Kind regards,

Jelle

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
