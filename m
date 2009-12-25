Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59661 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZLYQNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 11:13:48 -0500
Received: by ewy19 with SMTP id 19so252146ewy.21
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 08:13:47 -0800 (PST)
Date: Fri, 25 Dec 2009 17:13:43 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TAXI <taxi@a-city.de>
cc: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
In-Reply-To: <4B34DF2C.4030203@a-city.de>
Message-ID: <alpine.DEB.2.01.0912251652120.5481@ybpnyubfg.ybpnyqbznva>
References: <4B33F4CA.7060607@a-city.de> <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva> <4B34961D.6060207@a-city.de> <alpine.DEB.2.01.0912251529470.5481@ybpnyubfg.ybpnyqbznva> <4B34DF2C.4030203@a-city.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Dec 2009, TAXI wrote:

> BOUWSMA Barry schrieb:
> > Now rebuild the kernel or the dvb_usb_cxusb module, reboot or load
> > the new module, and try it and see if it is better.

> Great job, it works!
> 
> Thank you so much :)
> Should we try the isoc transfer now?

Yes.

I wish I could find a clean patch that I used in the past -- but
it is hidden on a disk...  somewhere...  somewhere...

I may have to send an untested patch.  Boy, I wish I could copy
and paste with my mouse  :-)


Here is some source code which I have from 2005, with the ISOC
parameters that used to be used...


	.generic_bulk_ctrl_endpoint = 0x01,
	/* parameter for the MPEG2-data transfer */
	.urb = {
		.type = DVB_USB_ISOC,
		.count = 5,
		.endpoint = 0x02,
		.u = {
			.isoc = {
				.framesperurb = 32,
				.framesize = 940,
				.interval = 5,
			}
		}
	},

	.num_device_descs = 1,
	.devices = {
		{   "Medion MD95700 (MDUSBTV-HYBRID)",



The idea is to fit this into the cxusb_medion_properties that
is probably near line 900 of your present source, plus or minus
however many changes there have been in the past five kernel
releases since my 2.6.27-rc4.

These are the lines which now look much like  .type = USB_BULK,
and so on.


THIS IS NOT A CHANGE WHICH NORMAL USERS SHOULD TRY TO MAKE.
IT WILL ONLY WORK FOR THE ORIGINAL UN-MODDED MEDION 95700.

Of course, you will first want to
$  mv -iv cxusb.c  cxusb.c-bulk-hack
$  cp -pvi  cxusb.c-DIST  cxusb.c
then make your changes to the unchanged original cxusb.c


In a later patch which I have intended to be compatible for all
users, I have this set somewhere else, with lines similar to


+#else
+/* XXX try to switch to using ISOC instead of BULK */
+/* XXX debug */		err("attempting to use isoc transfers on alt6 ep");
+			props->adapter->stream.type = USB_ISOC;
+			props->adapter->stream.u.isoc.framesperurb = 32;
+			props->adapter->stream.u.isoc.framesize = 940;
+			props->adapter->stream.u.isoc.interval = 5;
+
+#endif /* XXX HACK */


But this patch is very messy, and I must clean it up before I
can even think of posting it to the list...


I hope this can get you started, as I continue to search for a
simple patch which does the above, but correctly.


batty bouwsma
