Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56491 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab2FMXkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 19:40:12 -0400
Message-ID: <4FD924DA.5020206@iki.fi>
Date: Thu, 14 Jun 2012 02:40:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_usb_v2 [RFC] draft use delayed work.
References: <1339626433.2421.76.camel@Route3278>
In-Reply-To: <1339626433.2421.76.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2012 01:27 AM, Malcolm Priestley wrote:
> dvb_usb_v2 [RFC] use delayed work.
>
> The problem with an ordinary work queue it executes immediately.
>
> changes made
> 1. Three extra states added DVB_USB_STATE_PROBE, DVB_USB_STATE_COLD
> 	and DVB_USB_STATE_WARM.
> 2. Initialise of priv moved to probe this shouldn't really be done in the
> 	work queue.
> 3. The initial delay 200ms waits for the probe to clear.
> 4. State DVB_USB_STATE_PROBE checks for interface to be BOUND then calls the
> 	identify_state(possibly extra timeout signals needed if binding fails).
> 5. The next schedule time now increases to 500ms execution following as before
> 	with state changing accordingly.
> 6. DVB_USB_STATE_INIT uses the value of 0x7 so clears the other states.
>
> The work queue then dies forever. However, it could continue on as the remote work.

One question before I start to review those changes: as I explained 
firmware loading my earlier mail, are these changes valid any-more?

It sounds a little bit weird if I haven't meet these problems as I have 
tested those using multiple devices. af9015, anysee, ec168, au6610 and 
Cypress FX2 with warm/cold IDs.

regards
Antti
-- 
http://palosaari.fi/
