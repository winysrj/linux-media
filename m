Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K7Uw4-0008C8-U5
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 14:32:54 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K7Uvv-0003zM-M7
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 12:32:39 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 12:32:39 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 12:32:39 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Sat, 14 Jun 2008 13:31:46 +0100
Message-ID: <4853BA32.4050606@googlemail.com>
References: <g2unka$ivi$1@ger.gmane.org> <4853B5CD.3050906@ethz.ch>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
In-Reply-To: <4853B5CD.3050906@ethz.ch>
Subject: Re: [linux-dvb] How to use a DVB FRONTEND in read only?
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

Claudio Luck wrote:
> Andrea wrote:
> 
> 
> Check for open filehandles on demux device:
> 
> root@iptv:~# ls -l /proc/*/fd/* | grep demux
> lrwx------ 1 vlc  vlc  64 2008-06-14 14:02 /proc/19876/fd/6 ->
> /dev/dvb/adapter0/demux0
> lrwx------ 1 vlc  vlc  64 2008-06-14 14:02 /proc/19892/fd/6 ->
> /dev/dvb/adapter1/demux0

I will try that, but it sounds to me a very non natural solution.
Should the dvb framework tell the clients if it is streaming or not? via an ioctl like FE_GET_INFO?

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
