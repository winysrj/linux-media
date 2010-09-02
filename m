Return-path: <mchehab@localhost>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <linuxtv@nzbaxters.com>) id 1Or6Np-00051n-8T
	for linux-dvb@linuxtv.org; Thu, 02 Sep 2010 11:47:01 +0200
Received: from auth-1.ukservers.net ([217.10.138.154])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Or6No-00053s-5y; Thu, 02 Sep 2010 11:47:01 +0200
Received: from wlgl04017 (203-97-171-185.cable.telstraclear.net
	[203.97.171.185])
	by auth-1.ukservers.net (Postfix smtp) with SMTP id F358E358CE0
	for <linux-dvb@linuxtv.org>; Thu,  2 Sep 2010 10:41:19 +0100 (BST)
Message-ID: <18E0093FE11547919964DEE095F65439@telstraclear.tclad>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 2 Sep 2010 21:41:14 +1200
MIME-Version: 1.0
Subject: [linux-dvb] TT Budget C-1501 with Alphacrypt - write errors
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@localhost>
List-ID: <linux-dvb@linuxtv.org>

I'm running 2x TT-C1501 cards with 2x Alphacrypt CAMs running 3.19 with VDR. 
I'm running 2.6.33.5-124.fc13.x86_64 kernel.

Mostly they work well and decode multi channels just fine.  But 
intermittantly (a few times a day) one the CAMs can't be written to and drop 
to "CAM Ready" under VDR, needing a reset before they'll start working 
again.  It's happenning to both, but never at the same time.

In VDR I'm getting this read error from dvbci.c:
void cDvbCiAdapter::Write(const uint8_t *Buffer, int Length)
{
  if (Buffer && Length > 0) {
     if (safe_write(fd, Buffer, Length) != Length)
        esyslog("ERROR: can't write to CI adapter on device %d: %m", 
device->DeviceNumber());
     }
}


It's driving me mad, and I'm looking at a way of automatically resetting the 
CAMs just to keep things running.

Any suggestions on why the CAMs would lock up?  Any suggestions on debugs I 
can run to diagnose?


Thanks
Simon 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
