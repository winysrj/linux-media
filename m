Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49046 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0FUPpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 11:45:43 -0400
Received: by gwaa12 with SMTP id a12so331278gwa.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 08:45:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1F0DDC.4070307@ventoso.org>
References: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
	<4C1F0DDC.4070307@ventoso.org>
Date: Mon, 21 Jun 2010 11:45:41 -0400
Message-ID: <AANLkTimnh1hG27aEdqktSHfXbIEOmirlG9ZJXDpVBQQQ@mail.gmail.com>
Subject: Re: [PATCH] af9005: use generic_bulk_ctrl_endpoint_response
From: Michael Krufky <mkrufky@kernellabs.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 2:59 AM, Luca Olivetti <luca@ventoso.org> wrote:
> En/na Michael Krufky ha escrit:
>>
>> Could somebody please test this patch and confirm that it doesn't
>> break the af9005 support?
>>
>> This patch removes the af9005_usb_generic_rw function and uses the
>> dvb_usb_generic_rw function instead, using
>> generic_bulk_ctrl_endpoint_response to differentiate between the read
>> pipe and the write pipe.
>
> Unfortunately I cannot test it (my device is broken)[*].
> At the time I wrote my own rw function because I didn't find a way to send
> on a bulk endpoint and receiving on another one (i.e. I didn't know about
> generic_bulk_ctrl_endpoint/generic_bulk_ctrl_endpoint_response or they
> weren't available at the time).
>
> [*]Actually the tuner is broken, but the usb is working fine, so maybe I can
> give it a try.


Luca,

That's OK -- I only added this "generic_bulk_ctrl_endpoint_response"
feature 4 months ago -- your driver predates that.  I am pushing this
patch to reduce the size of the kernel while using your driver to
demonstrate how to use the new feature.  I am already using it in an
out of tree driver that I plan to merge within the next few months or
so, but its always nice to optimize code that already exists with
small cleanups like this.

You don't need the tuner in order to prove the patch -- if you can
simply confirm that you are able to both read and write successfully,
that would be enough to prove the patch.  After testing, please
provide an ack in this thread so that I may include that with my pull
request.

Thanks & regards,

Mike Krufky
