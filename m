Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85JO7ZZ013637
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 15:24:07 -0400
Received: from smtp-out5.blueyonder.co.uk (smtp-out5.blueyonder.co.uk
	[195.188.213.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85JNumG008653
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 15:23:57 -0400
Message-ID: <48C1874B.5080502@blueyonder.co.uk>
Date: Fri, 05 Sep 2008 20:23:55 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <488C9266.7010108@blueyonder.co.uk>	
	<1217364178.2699.17.camel@pc10.localdom.local>	
	<4890BBE8.8000901@blueyonder.co.uk>	
	<1217457895.4433.52.camel@pc10.localdom.local>	
	<48921FF9.8040504@blueyonder.co.uk>	
	<1217542190.3272.106.camel@pc10.localdom.local>	
	<48942E42.5040207@blueyonder.co.uk>	
	<1217679767.3304.30.camel@pc10.localdom.local>	
	<4895D741.1020906@blueyonder.co.uk>	
	<1217798899.2676.148.camel@pc10.localdom.local>	
	<4898C258.4040004@blueyonder.co.uk>
	<489A0B01.8020901@blueyonder.co.uk>	
	<1218059636.4157.21.camel@pc10.localdom.local>	
	<489B6E1B.301@blueyonder.co.uk>	
	<1218153337.8481.30.camel@pc10.localdom.local>	
	<489D7781.8030007@blueyonder.co.uk>	
	<1218474259.2676.42.camel@pc10.localdom.local>	
	<48A8892F.1010900@blueyonder.co.uk>	
	<1219024648.2677.20.camel@pc10.localdom.local>	
	<48B44CDF.60903@blueyonder.co.uk>	
	<1219792546.2669.17.camel@pc10.localdom.local>
	<1220236507.2669.117.camel@pc10.localdom.local>
In-Reply-To: <1220236507.2669.117.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
Reply-To: ian.davidson@bigfoot.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


I am about to give up with this KWorld card as I do not have the time - 
I need to get something that works.  So 2 questions - one for a 'last 
try' and one for 'Plan B'.

Q1. Initially, the card was not recognised automatically, but under 
guidance form Hermann, forcing Linux to treat it as card=114, I was able 
to capture video.  Unfortunately, normally Black and White rather than 
colour.  I understand that  normally Linux would sniff the eeprom and 
determine the type of card from information found in there.  I have the 
.inf files that describe the various KWorld cards to that other 
operating system and I can see that the first 4 bytes of the eeprom, 
albeit swapped about (Big Endian/Little Endian) are used in that .inf to 
identify the card.  Various parameters are apparently put into the 
Registry, depending on the card type and I thought I would compare the 
parameters for my card with the parameters for the 'Real 114'.  I assume 
that there is a file somewhere which says "If the eeprom says 'xxxx' 
then the card is type 'n'".  Where can I see that file which identifies 
the card type?

Q2. Assuming that I am unable to make any difference, I will need to use 
a different card - and hopefully, one that is supported.  In order to 
make the current card do anything, I had to issue a couple of commands

"modprobe -vr saa7134-dvb saa7134-alsa saa7134 tuner"

"modprobe -v saa7134 card=114 i2c_scan=1"

so presumably, I would need to 'undo' the effect of those lines to let Linux auto-detect.  What do I need to do?

Ian


-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
