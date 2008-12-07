Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andy@ziv.id.au>) id 1L9HGE-0005CL-NC
	for linux-dvb@linuxtv.org; Sun, 07 Dec 2008 11:53:17 +0100
Message-ID: <493BAAF0.9020801@ziv.id.au>
Date: Sun, 07 Dec 2008 21:22:32 +1030
From: Andy Zivkovic <andy@ziv.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mantis driver locks system (Twinhan 1034)
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

I recently got a Twinhan 1034 DVB-S card and installed it on a system 
that was running mythtv with two Nova T 500's for months without problem.

Within 2 days of installing the Twinhan 1034, the computer locked up, no 
moving picture on the TV, no sound, and wouldn't respond to the network 
(neither samba and sshd would respond).  After rebooting (pressing reset 
switch on case), system worked again for about 2 days before freezing.

I used the driver from http://jusst.de/hg/


Also, I didn't do enough homework before buying this card, as I need to 
use a irdeto CAM to view my provider's programs. It wasn't until after I 
bought the card and spent a few hours trying the card and CAM in both 
linux and Windows that I found out the mantis driver doesn't support 
CAMs. The latest I could find was a post to this list in September 
saying the maintainer was trying to get technical info from the 
manufacturer. Has there been any progress that I haven't been able to 
find with google?


Although I am a programmer, I don't think I have the knowledge or 
ability to help much, but would be willing to try if there's anything 
anyone wants me to try. For now I've taken the card out because I don't 
want to miss a recording because the computer froze, but it wouldn't 
take me long to put it back to test something.

Andy.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
