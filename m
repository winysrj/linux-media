Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57147 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754681Ab1LMRlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 12:41:06 -0500
Date: Tue, 13 Dec 2011 17:41:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Antti Palosaari <crope@iki.fi>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
	linux-serial@vger.kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org,
	=?ISO-8859-1?B?Qmr4cm4=?= Mork <bjorn@mork.no>,
	James Courtier-Dutton <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?B?SXN0duFuIFbhcmFkaQ==?= <ivaradi@gmail.com>
Subject: Re: serial device name for smart card reader that is integrated to
 Anysee DVB USB device
Message-ID: <20111213174133.17189842@pyramind.ukuu.org.uk>
In-Reply-To: <4EE77DA9.9060102@iki.fi>
References: <4E8B7901.2050700@iki.fi>
	<4E8BF6DE.1010105@iki.fi>
	<201110051016.06291.oneukum@suse.de>
	<201110141932.51378.oliver@neukum.org>
	<4EE77DA9.9060102@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Anyhow, I would like now ask how to proceed. Should I export four new 
> functions as replacement of those leaving old functionality as 
> currently. Or should I change existing ones like adding new pointer for 
> struct usb_serial and use it instead of struct usb_interface when not NULL.

I think I would favour adding new ones. The new ones can be added,
debugged and then the old ones phased out afterwards if it is worth
cleaning them up. That saves having to fix everything else at the same
time.

Alan
