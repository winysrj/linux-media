Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43128 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaKCIvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 03:51:38 -0500
Date: Mon, 3 Nov 2014 06:51:32 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 12/14] [media] cx231xx: use dev_info() for extension
 load/unload
Message-ID: <20141103065132.15d6498e@recife.lan>
In-Reply-To: <54566AB5.3020803@iki.fi>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
	<58369096f1fee7d71942eae7a40db6d7c1c368bf.1414929816.git.mchehab@osg.samsung.com>
	<54566AB5.3020803@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 02 Nov 2014 19:32:37 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> 
> 
> On 11/02/2014 02:32 PM, Mauro Carvalho Chehab wrote:
> > Now that we're using dev_foo, the logs become like:
> >
> > 	usb 1-2: DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
> > 	usb 1-2: Successfully loaded cx231xx-dvb
> > 	cx231xx: Cx231xx dvb Extension initialized
> >
> > It is not clear, by the logs, that usb 1-2 name is an alias for
> > cx231xx. So, we also need to use dvb_info() at extension load/unload.
> >
> > After the patch, it will print:
> > 	usb 1-2: Cx231xx dvb Extension initialized
> >
> > With is coherent with the other logs.
> 
> 
> That is not correct as wrong device pointer passed to dev_. Go cx231xx 
> usb driver probe function and add following test log to see how is 
> should look like:
> dev_info(&intf->dev, "Hello World\n");

I changed the probe to be:

static int cx231xx_usb_probe(struct usb_interface *interface,
                             const struct usb_device_id *id)
{
        struct usb_device *udev;
	...
        struct usb_interface_assoc_descriptor *assoc_desc;

        udev = usb_get_dev(interface_to_usbdev(interface));
        ifnum = interface->altsetting[0].desc.bInterfaceNumber;

        dev_info(&interface->dev, "intf Hello World\n");
        dev_info(&udev->dev, "udev Hello World\n");

The result is:

[54915.036082] cx231xx 1-2:1.2: intf Hello World
[54915.036090] usb 1-2: udev Hello World
[54915.036163] cx231xx 1-2:1.3: intf Hello World
[54915.036171] usb 1-2: udev Hello World
[54915.036197] cx231xx 1-2:1.4: intf Hello World
[54915.036204] usb 1-2: udev Hello World
[54915.036228] cx231xx 1-2:1.5: intf Hello World
[54915.036234] usb 1-2: udev Hello World
[54915.036258] cx231xx 1-2:1.6: intf Hello World
[54915.036264] usb 1-2: udev Hello World

Devices with multiple interfaces seem to have intf->dev filled with
a different device than udev->dev. The cx231xx is likely the most
complex device we have at media, as it has lots of interfaces, each
with lots of alternates, plus its 3 I2C physical buses and one I2C
mux internally.

I may work on a patch that would be storing intf->dev into
cx231xx dev struct. That's probably the easiest way for this
device.

Do you have any other idea?

Regards,
Mauro
