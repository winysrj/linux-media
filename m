Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1KLSWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 13:22:23 -0500
Received: by wwe5 with SMTP id 5so2705032wwe.1
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 10:22:22 -0800 (PST)
Message-ID: <4ebeb95d.e813b40a.37be.5102@mx.google.com>
Subject: Re: [PATCH 2/7] af9015 Remove call to get config from probe.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 18:22:16 +0000
In-Reply-To: <4EBE9C3C.4070201@iki.fi>
References: <4ebe96dc.d467e30a.389b.ffff8e28@mx.google.com>
	 <4EBE9C3C.4070201@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-12 at 18:18 +0200, Antti Palosaari wrote:
> On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
> > Remove get config from probe and move to identify_state.
> >
> > intf->cur_altsetting->desc.bInterfaceNumber is always expected to be zero, so there
> > no point in checking for it.
> 
> Are you sure? IIRC there is HID remote on interface 1 or 2 or so (some 
> other than 0). Please double check.
> 
> > Calling from probe seems to cause a race condition with some USB controllers.
> 
> Why?
> 
Is some other module going to claim the device?

Would it not be better use usb_set_interface to set it back to 0? 

Rather than failing it back to the user.

Regards


Malcolm

