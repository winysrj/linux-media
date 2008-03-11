Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JZ2XB-00016W-2B
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 12:20:50 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id 8D3DCD88130
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 12:19:35 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080311110707.GA15085@mythbackend.home.ivor.org>
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
Date: Tue, 11 Mar 2008 11:20:01 +0000
Message-Id: <1205234401.7463.10.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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


On Tue, 2008-03-11 at 11:07 +0000, ivor@ivor.org wrote:
> Not sure if this helps or adds that much to the discussion... (I think
> this was concluded before)
> But I finally switched back to kernel 2.6.22.19 on March 5th (with
> current v4l-dvb code) and haven't had any problems with the Nova-t 500
> since. Running mythtv with EIT scanning enabled.
> 
> Looking in the kernel log I see a single mt2060 read failed message on
> March 6th and 9th and a single mt2060 write failed on March 8th. These
> events didn't cause any problems or cause the tuner or mythtv to fail
> though.

ah. 

So this begs the question:

What changed between 2.6.22 and 2.6.24? huh... funny, heh?

So, if 2.6.24 is finger pointed, I'm interested in a solution, as I have
a planned upgrade to it in about a month's time.

Nico




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
