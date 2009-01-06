Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LKHtL-0007Fb-5o
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 20:47:09 +0100
Received: by bwz11 with SMTP id 11so17623953bwz.17
	for <linux-dvb@linuxtv.org>; Tue, 06 Jan 2009 11:46:33 -0800 (PST)
Message-ID: <4963B4AF.3040301@gmail.com>
Date: Tue, 06 Jan 2009 20:44:47 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4963A330.3090903@wpkg.org>
In-Reply-To: <4963A330.3090903@wpkg.org>
From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: Re: [linux-dvb] random "no frontend was attached"
Reply-To: linux-dvb <linux-dvb@linuxtv.org>
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

Tomasz Chmielewski schrieb:
> I have a DVB USB device which identifies as:
> 
> # lsusb
> Bus 001 Device 006: ID 04ca:f001 Lite-On Technology Corp.
> 
> 
> Randomly, upon machine bootup, it is not detected properly ("no frontend was attached"):
> 
> usb 1-6: new high speed USB device using ehci_hcd and address 4                                                              
> usb 1-6: configuration #1 chosen from 1 choice                                                                               
> dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.                                                                 
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.                                              
> DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)                                                                    
> dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'                                                            
> input: IR-receiver inside an USB DVB receiver as /class/input/input6                                                         
> dvb-usb: schedule remote query interval to 150 msecs.                                                                        
> dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
> 
> 
> As a result, using DVB is impossible until I plug the device out 
> and plug it in again.

Does not work here.

> 
> This is the only solution to bring it back to life - if I remove
> DVB modules and insert them again, I get:
> 
> dvb-usb: bulk message failed: -22 (1/2)                                                                                      
> dvb-usb: bulk message failed: -22 (1/-150651080)                                                                             
> dvb-usb: bulk message failed: -22 (1/662)                                                                                    
> dvb-usb: bulk message failed: -22 (1/1024)                                                                                   
> dvb-usb: bulk message failed: -22 (1/2)          
> 
> 
> Are there any "better" solutions to that, other then re-inserting the USB device?
> If not, what could be the cause of it?
> 
> I use Linux kernel 2.6.28.
> 
> 

http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031165.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
