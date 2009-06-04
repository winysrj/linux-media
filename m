Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZFDW5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 18:57:44 -0400
Date: Thu, 4 Jun 2009 15:53:49 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
Message-ID: <20090604225349.GA8453@suse.de>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com> <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 05, 2009 at 02:43:04AM +0400, Alexey Klimov wrote:
> Is there any ideas about different behaviour of device on 32- and
> 64-bit platforms with the same usb bulk messages?

No, there should be no difference.

Have you run usbmon to look at the data on the wire?

thanks,

greg k-h
