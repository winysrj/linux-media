Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37592 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbaC0Vkn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 17:40:43 -0400
Date: Thu, 27 Mar 2014 22:40:41 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: pboettcher@kernellabs.com
Cc: linux-media@vger.kernel.org
Subject: Re: dib0700 NEC scancode question
Message-ID: <20140327214041.GA21302@hardeman.nu>
References: <20140327120728.GA13748@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140327120728.GA13748@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 27, 2014 at 01:07:28PM +0100, David Härdeman wrote:
>Hi Patrick,
>
>a quick question regarding the dib0700 driver:
>
>in ./media/usb/dvb-usb/dib0700_core.c the RC RX packet is defined as:
...
>The NEC protocol transmits in the order:
...
>Does the dib0700 fw really reorder the bytes, or could the order of
>not_system and system in struct dib0700_rc_response have been
>accidentally reversed?
...
>Which, if the order *is* reversed, would mean that the scancode that
>gets defined is in reality:
>
>	keycode = poll_reply->system     << 16 |
>		  poll_reply->not_system << 8  |
>		  poll_reply->data;
>
>Which is the same as the order used in drivers/media/rc/ir-nec-decoder.c.
>
>(An order which I'm considering trying to correct, which is why I'm
s/correct/make sure it's consistent/

-- 
David Härdeman
