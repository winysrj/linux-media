Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:49439 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab1H2SgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 14:36:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: usb_set_intfdata usage for two subdrivers
Date: Mon, 29 Aug 2011 19:03:15 +0200
Cc: Greg KH <greg@kroah.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <4E5ACF92.3020907@iki.fi> <20110829003617.GA8372@kroah.com> <4E5B0D7C.60003@iki.fi>
In-Reply-To: <4E5B0D7C.60003@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291903.15602.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 29. August 2011, 05:54:36 schrieb Antti Palosaari:
> On 08/29/2011 03:36 AM, Greg KH wrote:
> > On Mon, Aug 29, 2011 at 02:30:26AM +0300, Antti Palosaari wrote:
> >> I am trying to implement DVB USB device smartcard reader support
> >> using USB-serial.
> >
> > Really?  Why?  That doesn't seem to make sense, please explain more.
> 
> Since it is old style serial smartcard reader, not CCID PC/SC as new 
> readers. I see it a little bit overkill to register virtual HCI and 
> virtual CCID device though it sounds interesting.
> 
> There is already one such similar driver, iuu_phoenix, but without DVB 
> support ;) Consider situation I have iuu_phoenix integrated to USB DVB 
> device. Both using same USB enpoint, sharing hardware resources of 
> communication.

Look at struct dvb_usb_device.
It has a struct input_dev embedded. I suggest you also add a serial
device for smart cards.

	HTH
		Oliver
