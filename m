Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Lwh28-0007VI-Pi
	for linux-dvb@linuxtv.org; Wed, 22 Apr 2009 20:18:58 +0200
Message-ID: <49EF5F85.2040909@iki.fi>
Date: Wed, 22 Apr 2009 21:18:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Stuart <mailing-lists@enginuities.com>
References: <200903140506.00723.mailing-lists@enginuities.com>
	<200904020043.48389.mailing-lists@enginuities.com>
	<49D3ECE4.4030008@iki.fi>
	<200904221726.00028.mailing-lists@enginuities.com>
In-Reply-To: <200904221726.00028.mailing-lists@enginuities.com>
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

terve Stuart,
I am very thankful to research you have done according to this issue.

Stuart wrote:
> Hi Antti,
> 
> You may recall discussing this a while ago, I've been looking in to the problem 
> with the DigitalNow TinyTwin remote control and believe I have some idea of what 
> is going on.
> 
>> I don't like to touch other than dvb-modules :o I will not apply this to
>> my tree / pull-request until whole repeating issue is clear. Why it
>> comes and why it does not occur every machine.
> 
> I tried a number of things which made no difference until I tried to use the 
> device with uhci_hcd rather than ehci_hcd. With uhci_hcd there was a 0.27s delay 
> between key press and release rather than 17.5s with ehci_hcd.
> 
> I posted a question on linux-usb (which can be found here: 
> http://thread.gmane.org/gmane.linux.usb.general/16749) to work out why this 
> difference was occurring. Alan kindly pointed out that there is probably some 
> buggy firmware as the device appears to set bInterval for the endpoint 
> descriptor to 16 regardless of bus speed. This means using uchi_hcd it should be 
> polled at 16ms and using ehci_hcd it should be polled at 4096ms (however 
> ehci_hcd clips this to 1024ms).
> 
> It seems that the latest firmware version 4.95.0 has a strange 17x delay in it 
> (16ms x 17 = 272ms or ~0.27s and 1024ms x 17 = 17408ms or ~17.5s). I've found 
> that Windows should have a polling interval of 32 uframes or 4ms for a high 
> speed device with 6 <= bInterval <= 255. With a 17x delay this becomes 68ms 
> which is still small enough to not be a problem.
> 
> I've also noticed that there are spurious presses (not reported as events, 
> spurious interrupt transfers) seen in both Windows and Linux with the 4.95.0 
> firmware.
> 
> Using the older firmware (4.65.0, 4.71.0 and 4.73.0) all seem to behave better 
> (not perfectly, but better). They still have a buggy bInterval value where the 
> full speed value is used for high speed as well (which is masked under Windows) 
> however this can be worked around in hid-quirks.c.
> 
> So, I guess my questions are, is there a revised firmware fixing any of this? Is 
> there any information about the device firmware to possibly work out what the 
> firmware is doing and fix it? Is it possible to get information from the 
> manufacturer? Is there a contact address I could get in contact with to find 
> out?

4.95.0 is the newest firmware - I just looked about one month back some 
drivers (also newest AF9015 vendor released one) and almost all have 
that firmware. I have ~same stick (AzureWave) as you have and Fedora 10 
x86 and same fw. It is strange that this repeating issue does not affect 
  me :o I have seen this problem earlier, but don't remember which hw, 
fw and Fedora version was running.
I think hw is very much used Intel 8051 based, it could be nice to see 
decompile from various firmwares. I tried that before but without 
success - probably I don't have experience needed to set-up decompiler 
parameters.
Probably I can try to ask manufacturer also fix for fw, don't know 
what's their response because AF9015 is old chipset and AF9035 is 
current one.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
