Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from u15184586.onlinehome-server.com ([82.165.244.70])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@metrofindings.com>) id 1KqpqR-0006nj-Vn
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 15:58:27 +0200
From: Mark Kimsal <mark@metrofindings.com>
To: linux-dvb@linuxtv.org
Date: Fri, 17 Oct 2008 09:57:39 -0400
References: <200810160925.51556.mark@metrofindings.com>
	<37219a840810160811s2c2eff4cve7ac47f93de2eb0c@mail.gmail.com>
In-Reply-To: <37219a840810160811s2c2eff4cve7ac47f93de2eb0c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810170957.39975.mark@metrofindings.com>
Subject: Re: [linux-dvb] [PATCH] Add syntek corp device to au0828
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


On Thursday 16 October 2008 11:11:39 am you wrote:
> On Thu, Oct 16, 2008 at 9:25 AM, Mark Kimsal <mark@metrofindings.com> wrote:
[snip]
>
> Mark,
>
> I thought this stick had an MT2130 inside -- looks like you've got
> another revision with a TDA18271... very interesting :-)
>
> You say that ATSC works -- does it work on more than just one channel?
>  If ATSC works, then QAM should work as well.  NTSC is not yet
> supported in the Linux driver.
>
> Can you show me the dmesg output when the driver loads?  Also, can you
> give me the exact name of the device (from the retail package) ?
>
> Regards,
>
> Mike


Yes, more than one channel works.  I do see the module TDA18721 loaded along 
with a couple other.  Again, I'm not 100% sure that this is the woodbury, but 
it works.  I can scan channels, I've watched 4-5 stations.  It seems to 
kernel oops every once in a while on very static-y stations.

I just upgraded to 2.6.27 and it doesn't work anymore.  Modprobing au0828 does 
not load up any other modules like the tda18721 and does not create 
a /dev/dvb folder.  This is a problem with the latest hg tip of v4l-dvb.


dmesg from 2.6.27 (not working):
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: New USB device found, idVendor=05e1, idProduct=0400
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: USB 2.0 Video Capture Controller
usb 1-2: Manufacturer: Syntek Semiconductor
au0828 driver loaded
usbcore: registered new interface driver au0828
usbcore: registered new interface driver snd-usb-audio

dmesg from 2.6.24 (working):
usb 1-2: new high speed USB device using ehci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
au0828: i2c bus registered
tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a 
Hauppauge eeprom.
hauppauge_eeprom: warning: unknown hauppauge model #0
hauppauge_eeprom: hauppauge eeprom: model=0
tda18271 1-0060: creating new instance
TDA18271HD/C2 detected @ 1-0060
DVB: registering new adapter (au0828)
DVB: registering frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
Registered device AU0828 [Hauppauge Woodbury]


As per my other email (sabrent/auvitek unknown usb device) I'm not entirely 
sure of the brand name.  The Web store lists it as "sabrent".  lsusb says 
it's "syntek", but Windows and the device manager says it's an "auvitek".  
The box has literally no brand name.  The only "brand" looking things are 
just acronyms like NTSC and ATSC.  The windows .inf file for the driver is 
littered with the words "auvitek international", "copyright auvitek" and the 
like....

Although I didn't buy the device, the first brand name that I identified would 
be "auvitek".  Sabrent was only found after back tracking to the the retailer 
and seeing the product page.  I don't think that "Syntek" is the proper 
coporation for the usb vendor ID of 05e1.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
