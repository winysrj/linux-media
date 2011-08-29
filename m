Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33299 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab1H2CyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 22:54:20 -0400
Date: Sun, 28 Aug 2011 17:36:17 -0700
From: Greg KH <greg@kroah.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb_set_intfdata usage for two subdrivers
Message-ID: <20110829003617.GA8372@kroah.com>
References: <4E5ACF92.3020907@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5ACF92.3020907@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2011 at 02:30:26AM +0300, Antti Palosaari wrote:
> I am trying to implement DVB USB device smartcard reader support
> using USB-serial.

Really?  Why?  That doesn't seem to make sense, please explain more.

> The main problem is now that both DVB-USB and
> USB-serial uses interface data (usb_set_intfdata / usb_get_intfdata)
> for state.
> 
> Is there any common solution to resolve issue easily?

No two drivers can bind to the same USB interface, so of course they
would interfere.

Care to explain the problem in more detail to see if there is a better
way to do all of this?

greg k-h
