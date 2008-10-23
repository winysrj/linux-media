Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1KspyK-00047R-2G
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 04:30:50 +0200
Message-ID: <48FFE1B1.80403@rogers.com>
Date: Wed, 22 Oct 2008 22:30:09 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] Add syntek corp device to au0828
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

Mark Kimsal wrote:

> mkrufky wrote:
> > can you give me the exact name of the device (from the retail package) ?
> As per my other email (sabrent/auvitek unknown usb device) I'm not
> entirely
> sure of the brand name.  The Web store lists it as "sabrent".  lsusb says 
> it's "syntek", but Windows and the device manager says it's an "auvitek".  
> The box has literally no brand name.  The only "brand" looking things are 
> just acronyms like NTSC and ATSC.  The windows .inf file for the driver is 
> littered with the words "auvitek international", "copyright auvitek" and the 
> like....
>
> Although I didn't buy the device, the first brand name that I identified would 
> be "auvitek".  Sabrent was only found after back tracking to the the retailer 
> and seeing the product page.  I don't think that "Syntek" is the proper 
> coporation for the usb vendor ID of 05e1.

http://www.linuxtv.org/wiki/index.php/Sabrent_TV-USBHD



mkrufky wrote:

> I thought this stick had an MT2130 inside -- looks like you've got
> another revision with a TDA18271... very interesting :-)


I believe that the AnyTV sticks, from Shenzhen Forward Video, are configured with the MT213x part too. 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
