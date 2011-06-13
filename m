Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:35215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1FMNHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 09:07:23 -0400
Message-ID: <4DF60B72.5020509@infradead.org>
Date: Mon, 13 Jun 2011 10:06:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: balbi@ti.com
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com> <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu> <20110610183452.GV31396@legolas.emea.dhcp.ti.com> <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu> <20110613090517.GE3633@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110613090517.GE3633@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-06-2011 06:05, Felipe Balbi escreveu:
> Hi,
> 
> On Fri, Jun 10, 2011 at 05:43:06PM -0500, Theodore Kilgore wrote:
>>> there's nothing in the USB spec that says you need different product IDs
>>> for different modes of operation. No matter if it's still or webcam
>>> configuration, the underlying function is the same: capture images using
>>> a set of lenses and image sensor.
>>
>> True, true. But I will add that most of these cameras are Class 255, 
>> Subclass 255, Protocol 255 (Proprietary, Proprietary, Proprietary).
> 
> well, if the manufacturer doesn't want to implement UVC for whatever
> reason, it's his call ;-)

This argument is bogus.

UVC were implemented too late. There are lots of chipsets that are not UVC-compliant,
simply because there were no UVC at the time those chipsets were designed.

Still today, newer devices using those chipsets are still at the market.

This is the same as saying that we should not support USB 1.1 or USB 2.0
because they're not fully USB 3.0 compliant.

Mauro.
