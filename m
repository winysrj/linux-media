Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38311 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119Ab2KMO5b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 09:57:31 -0500
Date: Tue, 13 Nov 2012 06:58:09 -0800
From: Greg KH <greg@kroah.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	michael hartup <michael.hartup@gmail.com>,
	linux-rpi-kernel@lists.infradead.org
Subject: Re: Regarding bulk transfers on stk1160
Message-ID: <20121113145809.GA15029@kroah.com>
References: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 10:56:48AM -0300, Ezequiel Garcia wrote:
> Hello,
> 
> A user (Michael Hartup in Cc) wants to use stk1160 on low power, low
> cost devices (like raspberrypi).
> 
> At the moment raspberrypi can't stream using isoc urbs due to problems
> with usb host driver (dwc-otg)
> preventing it from achieving the required throughput.
> For instance, on my rpi setup I can stream (using dd) at 16MB/s; but
> at least 20 MB/s are required.
> 
> Having read that bulk transfers may work better with rpi usb driver, I
> decided to try to implement
> those at stk1160. However, I later discovered stk1160 doesn't have any
> bulk endpoint (see lsusb below).
> (I'm no expert, but I assume lack of bulk endpoint means I can't use
> bulk urbs, right?).

Correct, you need to fix the rpi host controller driver in order to make
this work properly.  Please push back on the developers of that hardware
so we can get the specs to write a proper driver for it.

Or better yet, buy a board with a working USB port, like a BeagleBone or
the like :)

Sorry, there's really nothing we can do here,

greg k-h
