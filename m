Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1LwWq2-00059m-QB
	for linux-dvb@linuxtv.org; Wed, 22 Apr 2009 09:25:49 +0200
From: Stuart <mailing-lists@enginuities.com>
To: Antti Palosaari <crope@iki.fi>
Date: Wed, 22 Apr 2009 17:25:59 +1000
References: <200903140506.00723.mailing-lists@enginuities.com>
	<200904020043.48389.mailing-lists@enginuities.com>
	<49D3ECE4.4030008@iki.fi>
In-Reply-To: <49D3ECE4.4030008@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904221726.00028.mailing-lists@enginuities.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
Reply-To: linux-media@vger.kernel.org
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

Hi Antti,

You may recall discussing this a while ago, I've been looking in to the problem 
with the DigitalNow TinyTwin remote control and believe I have some idea of what 
is going on.

> I don't like to touch other than dvb-modules :o I will not apply this to
> my tree / pull-request until whole repeating issue is clear. Why it
> comes and why it does not occur every machine.

I tried a number of things which made no difference until I tried to use the 
device with uhci_hcd rather than ehci_hcd. With uhci_hcd there was a 0.27s delay 
between key press and release rather than 17.5s with ehci_hcd.

I posted a question on linux-usb (which can be found here: 
http://thread.gmane.org/gmane.linux.usb.general/16749) to work out why this 
difference was occurring. Alan kindly pointed out that there is probably some 
buggy firmware as the device appears to set bInterval for the endpoint 
descriptor to 16 regardless of bus speed. This means using uchi_hcd it should be 
polled at 16ms and using ehci_hcd it should be polled at 4096ms (however 
ehci_hcd clips this to 1024ms).

It seems that the latest firmware version 4.95.0 has a strange 17x delay in it 
(16ms x 17 = 272ms or ~0.27s and 1024ms x 17 = 17408ms or ~17.5s). I've found 
that Windows should have a polling interval of 32 uframes or 4ms for a high 
speed device with 6 <= bInterval <= 255. With a 17x delay this becomes 68ms 
which is still small enough to not be a problem.

I've also noticed that there are spurious presses (not reported as events, 
spurious interrupt transfers) seen in both Windows and Linux with the 4.95.0 
firmware.

Using the older firmware (4.65.0, 4.71.0 and 4.73.0) all seem to behave better 
(not perfectly, but better). They still have a buggy bInterval value where the 
full speed value is used for high speed as well (which is masked under Windows) 
however this can be worked around in hid-quirks.c.

So, I guess my questions are, is there a revised firmware fixing any of this? Is 
there any information about the device firmware to possibly work out what the 
firmware is doing and fix it? Is it possible to get information from the 
manufacturer? Is there a contact address I could get in contact with to find 
out?

Thanks in advance,

Stuart


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
