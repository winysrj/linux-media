Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68] helo=smtp1.bethere.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett1@onetel.com>) id 1JSBUe-0007Hi-7Q
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 14:29:44 +0100
Message-Id: <501D4953-DD8E-41E3-A6AE-4610F42EB780@onetel.com>
From: Tim Hewett <tghewett1@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 21 Feb 2008 13:28:09 +0000
Cc: Tim Hewett <tghewett1@onetel.com>
Subject: [linux-dvb] Technisat Skystar HD2 success
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

The Technisat Skystar HD2 card (Azurewave AD SP400 clone) has now been  
used successfully with the current mantis tree.

It is necessary to use szap to set DVB-S2 mode first, even if the  
transponder you want is DVB-S (discovered by chance). If this isn't  
done then it does not lock on to the frequency.

So you do the following:

szap -r -p -l UNIVERSAL -t 2 -a <card> <channel>

CTRL-C that after it has settled, then:

szap -r -p -l UNIVERSAL -t 0 -a <card> <channel>

Then (leaving the above line running) you can do:

cat /dev/dvb/adaptor<n>/dvr0 > file.mpg

and it then records error-free video.

As mentioned previously you need to change linux/drivers/media/dvb/ 
mantis/mantis_vp1041.h before building the drivers. Change the line:

#define MANTIS_VP_1041_DVB_S2   0x0031

to

#define MANTIS_VP_1041_DVB_S2   0x0001

This will let the driver detect the card properly on bootup due to its  
different subsystem IDs, otherwise the frontend isn't registered.

HTH,

Tim.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
