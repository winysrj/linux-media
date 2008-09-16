Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KfSge-0000Ij-R0
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 07:01:19 +0200
Message-ID: <48CF3D97.40805@linuxtv.org>
Date: Tue, 16 Sep 2008 01:01:11 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <412bdbff0809152102j4faa675cw3134efe5403020bd@mail.gmail.com>
In-Reply-To: <412bdbff0809152102j4faa675cw3134efe5403020bd@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [FIX] Use correct firmware for the ATI TV Wonder 600
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

Devin Heitmueller wrote:
> Attached is a patch to use the proper firmware for the ATI TV Wonder
> 600.  It was previously configured to use the XC3028 firmware, as I
> did not realize the device had an XC3028L until I got one myself for
> testing purposes.
> 
> This should get pushed in ASAP since the wrong firmware causes the
> device to overheat and could cause permanent damage.

I'll push this in... I like the fact that you defined the xc3028L firmware in the header -- I will also push up a patch to change the HVR1400 (cx23885 ExpressCard) to use XC3028L_DEFAULT_FIRMWARE instead of specifying the filename explicitly.

Thanks,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
