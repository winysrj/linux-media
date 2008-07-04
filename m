Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <george.smith@arcor.de>) id 1KEiML-00025v-13
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 12:17:45 +0200
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net
	[151.189.8.18])
	by mail-in-10.arcor-online.net (Postfix) with ESMTP id 6FE201F5133
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 12:17:41 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id 43D9C5BDF6
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 12:17:41 +0200 (CEST)
Received: from webmail12.arcor-so.net (webmail12.arcor-online.net
	[151.189.8.64])
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id 1EFB527EC4
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 12:17:41 +0200 (CEST)
Message-ID: <3588741.1215166661087.JavaMail.ngmail@webmail12.arcor-so.net>
Date: Fri, 4 Jul 2008 12:17:41 +0200 (CEST)
From: george.smith@arcor.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Failed to open demux device /dev/dvb/adapter0/demux0
	for filter
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

While recording (in mythtv) with a dvb-t usb stick, I'm getting error messages like the following about once per second:

PIDInfo(0): Failed to open demux device /dev/dvb/adapter0/demux0 for filter on pid 0x44c

The stick in question is from Yakumo, I read that there is an identical stick from Freecom. It is recognized as:

14aa:0221 AVerMedia (again) or C&E

The recordings are fine. One thing that seems strange about the stick is that a scan takes many times longer than with my other dvb-t usb sticks (2040:7070 Hauppauge), though as a newbie I don't really know what to expect here.

Any ideas what the problem could be or what I should check?

Thanks,

George

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
