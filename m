Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cnc.isely.net ([64.81.146.143])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <isely@isely.net>) id 1LN7rR-0000hZ-Kw
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 16:40:54 +0100
Date: Wed, 14 Jan 2009 09:40:16 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: "A. F. Cano" <afc@shibaya.lonestar.org>
In-Reply-To: <20090102043426.GA17583@shibaya.lonestar.org>
Message-ID: <Pine.LNX.4.64.0901140933390.28841@cnc.isely.net>
References: <20090102043426.GA17583@shibaya.lonestar.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How is the support of the OnAir Creator these days?
Reply-To: Mike Isely <isely@pobox.com>
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

On Thu, 1 Jan 2009, A. F. Cano wrote:

> Hi,
> 
> I posted a quite detailed query 2 years ago (how time flies!).  At the
> time there were problems.  Mike Krufky (if I remember correctly) gave
> a detailed report of the status at the time.
> 
> It's been a while and I was wondering what progress there has been
> in supporting the OnAir Creator usb hdtv tuner.  I'm fine-tuning and
> configuring debian lenny on a  new HD (kernel  2.6.26) and I'm wondering
> if I'm finally safe getting this unit, or will I still have an
> expensive paperweight?
> 
> If it still doesn't work properly (I'm willing to do some testing
> and report back, but only if it useable to some degree), what other
> supported units are comparable these days?
> 
> Thanks.
> 
> A.

The OnAir Creator should be fully working (analog and digital) via the 
pvrusb2 driver.

There is one hiccup left for setting it up, which you got into in 
another reply: firmware.  The fwextract.pl script used with the pvrusb2 
driver doesn't yet know how to extract that device's encoder firmware.  
There is a separate manual (and much trickier) procedure that should 
work.  If you've gotten through that, I'd like to use those results to 
train the fwextract.pl script.  Please e-mail me offline and I'll fill 
you in.  By the way, unlike similar Hauppauge devices (e.g. HVR-1950), 
this device gets its FX2 firmware from an internal ROM.  Thus the only 
firmware file needed is for the encoder for use in analog mode - but 
because of a funky device behavior you also need this for digital mode.  
Read on...

Note: Mike Krufky had attempted long ago to get at least the digital 
side of this device to work, but he was thwarted for a long time by a 
problem with the device simply "not starting".  When we began working 
together on this support in the pvrusb2 driver (where analog + digital 
support would be possible), we discovered that the device won't reliably 
work in digital mode until it has been briefly started at least once in 
analog mode.  The pvrusb2 driver takes care of this internally - and 
since Krufky's driver had no way to handle analog mode, his initial 
attempt was doomed from the get-go.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
