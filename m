Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx03.syneticon.net ([78.111.66.105])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mangoo@wpkg.org>) id 1LKGhQ-0000Ei-N2
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 19:30:45 +0100
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id 53BAD36172
	for <linux-dvb@linuxtv.org>; Tue,  6 Jan 2009 19:30:41 +0100 (CET)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new,
	port 10025) with ESMTP id a7294y5DirqP for <linux-dvb@linuxtv.org>;
	Tue,  6 Jan 2009 19:30:38 +0100 (CET)
Received: from [192.168.10.145] (koln-4db4000b.pool.einsundeins.de
	[77.180.0.11]) by mx03.syneticon.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Tue,  6 Jan 2009 19:30:38 +0100 (CET)
Message-ID: <4963A330.3090903@wpkg.org>
Date: Tue, 06 Jan 2009 19:30:08 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] random "no frontend was attached"
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

I have a DVB USB device which identifies as:

# lsusb
Bus 001 Device 006: ID 04ca:f001 Lite-On Technology Corp.


Randomly, upon machine bootup, it is not detected properly ("no frontend was attached"):

usb 1-6: new high speed USB device using ehci_hcd and address 4                                                              
usb 1-6: configuration #1 chosen from 1 choice                                                                               
dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.                                                                 
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.                                              
DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)                                                                    
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'                                                            
input: IR-receiver inside an USB DVB receiver as /class/input/input6                                                         
dvb-usb: schedule remote query interval to 150 msecs.                                                                        
dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.


As a result, using DVB is impossible until I plug the device out 
and plug it in again.

This is the only solution to bring it back to life - if I remove
DVB modules and insert them again, I get:

dvb-usb: bulk message failed: -22 (1/2)                                                                                      
dvb-usb: bulk message failed: -22 (1/-150651080)                                                                             
dvb-usb: bulk message failed: -22 (1/662)                                                                                    
dvb-usb: bulk message failed: -22 (1/1024)                                                                                   
dvb-usb: bulk message failed: -22 (1/2)          


Are there any "better" solutions to that, other then re-inserting the USB device?
If not, what could be the cause of it?

I use Linux kernel 2.6.28.


-- 
Tomasz Chmielewski
http://wpkg.org

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
