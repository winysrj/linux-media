Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:43405 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZFFVGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 17:06:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
Date: Sat, 6 Jun 2009 23:07:14 +0200
Cc: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Greg KH <gregkh@suse.de>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com> <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
In-Reply-To: <208cbae30906041543v583b411ah4434e66acf83fa77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906062307.14730.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 5. Juni 2009 00:43:04 schrieb Alexey Klimov:
> Is there any ideas about different behaviour of device on 32- and
> 64-bit platforms with the same usb bulk messages?
> Any input is welcome.

Are you running a 32 bit userland? If so, ioctls could be critical.
If not, the driver may not be 64bit clean. Which driver is affected?

	Regards
		Oliver

