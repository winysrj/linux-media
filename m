Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gaealink.net ([207.244.155.134] helo=smtp.gaealink.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joe@julianfamily.org>) id 1KlPd6-0006mb-55
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 16:58:13 +0200
Received: from localhost (unknown [127.0.0.1])
	by smtp.gaealink.net (Postfix) with ESMTP id 418423D0009
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 14:58:03 +0000 (UTC)
Received: from smtp.gaealink.net ([127.0.0.1])
	by localhost (gaealink.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T1HoavYqP8eQ for <linux-dvb@linuxtv.org>;
	Thu,  2 Oct 2008 07:58:01 -0700 (PDT)
Received: from smtp.julianfamily.org (c-76-121-237-87.hsd1.wa.comcast.net
	[76.121.237.87])
	by smtp.gaealink.net (Postfix) with ESMTP id 9DA013D0003
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 07:58:01 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
	by smtp.julianfamily.org (Postfix) with ESMTP id 4682C67EB2
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 14:58:01 +0000 (UTC)
Received: from smtp.julianfamily.org ([127.0.0.1])
	by localhost (strabo2.julianfamily.org [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id GrB-o0V4TAS0 for <linux-dvb@linuxtv.org>;
	Thu,  2 Oct 2008 07:57:56 -0700 (PDT)
Received: from [192.168.2.101] (questor.julianfamily.org [192.168.2.101])
	by smtp.julianfamily.org (Postfix) with ESMTP id 8FC8D67EA8
	for <linux-dvb@linuxtv.org>; Thu,  2 Oct 2008 07:57:56 -0700 (PDT)
Message-ID: <48E4E175.90403@julianfamily.org>
Date: Thu, 02 Oct 2008 07:57:57 -0700
From: Joe Julian <joe@julianfamily.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR2250 / HVR2200 / SAA7164 status
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

Steven Toth wrote:

    As you know, I'm writing a driver for the SAA7164 chipset, for the
    HVR2200 DVB-T and HVR2250 ATSC/QAM products.

    People have been asking for status, here's where I am.

    Do I have anything to share with people yet? Not yet.

      

    The basic driver framework is done. Firmware is loading, I can
    talking to the silicon through the proprietary PCIe ring buffer
    interface. I2C is working, eeprom and tuner/demod access is done.
    The HVR2250 is responding to azap commands, the tuners and demods
    are locking, snr looks pretty good... it's going to be a popular
    board for people. The HVR2200 (DVB-T Version) should also worked
    with tzap, it's untested and I can't comment on SNR at this stage. I
    need to add the DMA/buffering code, this is the missing pieces
    before a first public release. When I have anything to share I'll
    put up a tree and post a 'testers required' message here. 


We're a couple episodes into this fall television season and I'm missing 
my shows. ;)

Having another month down, I wanted to send a friendly nudge your 
direction, Steve, to see how this is progressing.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
