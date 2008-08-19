Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KVIJ3-0001hc-Nu
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 05:54:54 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	C0096180193F
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 03:54:18 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
Cc: "linux dvb" <linux-dvb@linuxtv.org>
Date: Tue, 19 Aug 2008 13:54:18 +1000
Message-Id: <20080819035418.B3DD747808F@ws1-5.us4.outblaze.com>
Subject: Re: [linux-dvb] DViCO FusionHDTV7 Express
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


> ----- Original Message -----
> From: "Tim Lucas" 
> To: stev391 at email.com
> Subject: DViCO FusionHDTV7 Express
> Date: Mon, 18 Aug 2008 22:33:40 -0400 (EDT)
> 
> 
> I have been searching online for support for this card and it looks like you have written some 
> stuff for it.  I am running mythbuntu 8.04 which does not yet include support for this card.  I 
> am a linux novice so I was wondering if you could help me add the appropriate files that will 
> add support for the card.  I am a linux novice (I'm good at apt-get install, but no so much at 
> building my own kernel) so I need a little bit of hand holding.  Any help you could provide 
> would be appreciated.
> 
> Side question.  I thought I might have seen something about only support for digital on this 
> card, not analog.  I am in an apartment complex that uses an antiquated (very large) satellite 
> system.  It is listed with schedules direct, but I am not sure if it is digital or analog.
> 
> 	--Tim

Tim,

The support that I added in was for a the DViCO DVB-T Dual Express, not the FusionHDTV7.

However there may be good news for you...
If your card is the FusionHDTV7 Dual Express there is support for this card in the main tree (only one DVB tuner at the moment). This may not help you as you stated that you needed analog support.

The easiest way for you to get the newest DVB drivers is to go to this webpage:
http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu-804/

You may need to install some firmware as well (you can tell if you need to get the firmware by an error message in the syslog [accessed by typing "dmesg" in a terminal], this error will only show up after you try to scan or tune to a channel.  If you need firmware goto:
http://www.steventoth.net/linux/xc5000/
and follow the instructions inside the files (extract.sh and readme.txt).

Give that a go then come back, with any issues to the mailing list.

Perhaps you could create a wiki page on: http://linuxtv.org/wiki/index.php
with all the relevant information on it, for an example checkout: http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express
And if you do make the page, update this page while you are at it: http://linuxtv.org/wiki/index.php/DViCO
and also: http://linuxtv.org/wiki/index.php/ATSC_PCIe_Cards

Regards,

Stephen.

P.S. If you have received my email address from the linux dvb mailing list please include it in the cc field so that everybody can learn about this as well.




-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
