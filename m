Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <the.teasdales@yahoo.com.au>) id 1Ktg8w-0006Mu-Lu
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 12:13:17 +0200
From: The Teasdales <the.teasdales@yahoo.com.au>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.1.1224496801.4350.linux-dvb@linuxtv.org>
References: <mailman.1.1224496801.4350.linux-dvb@linuxtv.org>
Date: Sat, 25 Oct 2008 21:12:31 +1100
Message-Id: <1224929551.22105.1.camel@rob-desktop>
Mime-Version: 1.0
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 45, Issue 25
Reply-To: the.teasdales@yahoo.com.au
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

> Message: 14
> Date: Mon, 20 Oct 2008 14:43:34 +1100
> From: Rob Teasdale <the.teasdales@yahoo.com.au>
> Subject: [linux-dvb] Asus MyCinema U3000 mini
> To: linux-dvb@linuxtv.org
> Message-ID: <1224474214.6898.13.camel@rob-desktop>
> Content-Type: text/plain
> 
> Hi all,
> 
> I am relatively new to linux and I have been trying to get my USB tuner
> to work in ubuntu (kernel 2.6.24-21-generic).  According to my searches
> this tuner should be supported in this kernel however it is not working.
> 
> Oct 20 11:39:04 rob-desktop kernel:
> [ 6942.035771] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c:
> timeout initializing reports
> Oct 20 11:39:04 rob-desktop kernel: [ 6942.035917] input: ASUS  U3000
> as /devices/pci0000:00/0000:00:03.3/usb4/4-7/4-7:1.1/input/input8
> Oct 20 11:39:04 rob-desktop kernel: [ 6942.063272]
> input,hiddev96,hidraw0: USB HID v1.11 Keyboard [ASUS  U3000 ] on
> usb-0000:00:03.3-7
> 
> and also
> 
> rob@rob-desktop:~$ lsusb
> Bus 004 Device 006: ID 0b05:1713 ASUSTek Computer, Inc. 
> ...
> 
> As can be seen the vendor id is correct, however the device id is
> different to that on the linuxtv
> wiki(http://www.linuxtv.org/wiki/index.php/Asus_My-Cinema-U3000_Mini). I
> would assume that this would cause problems and needs to be resolved, I
> am just not sure how and would appreciate any assistance. I think that
> this problem is leading to my device being recognised as a keyboard?
> 
> I would really like to get this device working, and would appreciate any
> pointers as to how to get this device working.  
> 
> Cheers
> Rob

Hi all,

After reading around and some more research I have recompiled v4l-dvb
for my devices id.  I was excited to find that my device was now recognised however I still appear to have a conflict.

My systems logs are: 

dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in cold state, will try to load a firmware
/build/buildd/linux-2.6.24/drivers/hid/usbhid/hid-core.c: timeout initializing reports
input: ASUS  U3000 as /devices/pci0000:00/0000:00:1d.7/usb7/7-2/7-2:1.1/input/input15
input,hiddev96,hidraw2: USB HID v1.11 Keyboard [ASUS  U3000 ] on usb-0000:00:1d.7-2

It would appear that I now have a conflict with another header but I am
completely stuck here.  If anybody can point me in the right direction I
would be extremely grateful!

Cheers Rob


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
