Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1L4KW6-0002nC-E6
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 20:21:11 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1393226fga.25
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 11:21:07 -0800 (PST)
Message-ID: <37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
Date: Sun, 23 Nov 2008 14:21:07 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Bob Cunningham" <FlyMyPG@gmail.com>
In-Reply-To: <49287DCC.9040004@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <49287DCC.9040004@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
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

On Sat, Nov 22, 2008 at 4:46 PM, Bob Cunningham <FlyMyPG@gmail.com> wrote:
> Hi,
>
> I just bought an AnyTV AUTV002 USB Tuner Stick from DealExtreme.  When plugged in, lsusb provides the following:
>
>   Bus 001 Device 011: ID 05e1:0400 Syntek Semiconductor Co., Ltd
>
> A quick search revealed that the au0828 driver had recently been updated (10 Nov) to support this USB ID.
>
> Following instructions on the wiki, I obtained the latest v4l-dvb source via Mercurial, and built/installed it without error.  Next I did "modprobe au0828", and dmesg provided the following:
>
>    au0828 driver loaded
>    usbcore: registered new interface driver au0828
>
> Next I did "lsmod | grep au0828", which provides the following:
>
>   au0828                 20384  0
>   dvb_core               68673  1 au0828
>   tveeprom               14917  1 au0828
>   i2c_core               20949  4 au0828,tveeprom,nvidia,i2c_i801
>
> dmesg provides the following when the device is plugged in:
>
>   usb 1-2: new high speed USB device using ehci_hcd and address 10
>   usb 1-2: configuration #1 chosen from 1 choice
>   usb 1-2: New USB device found, idVendor=05e1, idProduct=0400
>   usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>   usb 1-2: Product: USB 2.0 Video Capture Controller
>   usb 1-2: Manufacturer: Syntek Semiconductor
>
> However, I have no /dev/dvb.  I unplugged/replugged several times, with no change.
>
> I rebooted and repeated the modprobe and the unplug/replug, with no different results.
>
> My guess is that udev isn't making the connection from the USB ID, but I'm not sure what to do about it.
>
> I'm running a fully updated FC8 on a Dell dual Xeon-HT server with kernel 2.6.26.6-49.fc8 #1 SMP.
>
> Did I miss something basic?

Bob,

A patch was submitted that adds support for a device with usb ID
05e1:0400, but it did not get merged yet.

The reason why I didn't merge the patch yet, is that there are
multiple devices out there using this USB id but they have different
internal components and no way to differentiate between the two.

If you can open up your stick and tell us what is printed on each
chip, then I can help you get yours working.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
