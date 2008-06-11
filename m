Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1K6Oee-00028W-C3
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 13:38:18 +0200
Message-Id: <BA86A83C-165B-44C6-908B-14F483018582@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: linux-dvb@linuxtv.org,
 michaelbeeson@gmail.com
Mime-Version: 1.0 (Apple Message framework v924)
Date: Wed, 11 Jun 2008 12:36:42 +0100
Subject: [linux-dvb] UK Freesat twin tuner USB/PCI/PCI-E
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

Mike,

No need to worry about having two of the same D-SAT device so ling as  
they are both receiving their signal from the same satellite, e.g.  
28East in your case. One will be adaptor 0 and the other will be  
adaptor 1. If they don't receive the signal from the same satellite  
(say one is on 28East and the other on 19.2East) then it might be  
difficult to identify which is which since they may not be assigned  
the same adaptor number each time the PC is booted.

FYI my system has 3 D-SAT cards (all of the same device), one DVB-S2  
card and three DVB-T USB sticks (all different types). The 2GHz AMD64  
X2 PC will happily simultaneously record an entire transponder from  
each of the satellite cards plus one channel from each of the DVB-T  
devices. The only issue is that no other activity must be allowed to  
occur on the hard disk being used for recording or else it won't keep  
up with the data rate. Two of the DVB-T sticks support recording  
entire multiplexes, but doing that would probably go beyond what the  
hard disk can cope with and I've not tried it.

|n my experience recording entire transponders is a good idea even if  
you only want one or two channels from it, because every now and again  
the BBC and ITV change the PIDs of their channels - if you record by  
specifying PIDs you may find you get no recording when the PIDs  
change. By recording the whole transponder you get everything  
regardless of PID changes, and then afterwards you can extract the  
channel(s) you want using ts2ps (from dvb-mpegtools) specifying the  
current PIDs for the channel. You need plenty of disk space to do this  
though.

Tim.

> Thanks. I see what you mean about saturating the USB bus, but I  
> would be using USB2 devices on seperate busses (AMD 780G  
> motherboard). Assuming that this works okay, nobody has voiced that  
> having two of the same device under linux is going to be a problem?  
> Thanks, Mike.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
