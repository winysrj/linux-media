Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47723 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2HDRFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2012 13:05:11 -0400
Received: by yenl2 with SMTP id l2so1689990yen.19
        for <linux-media@vger.kernel.org>; Sat, 04 Aug 2012 10:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501D4535.8080404@lockie.ca>
References: <501D4535.8080404@lockie.ca>
Date: Sat, 4 Aug 2012 14:05:10 -0300
Message-ID: <CALF0-+XBjpo3zSg0gTYwFEtTt-biJPb=LMYpMaq3wv8qNp++qA@mail.gmail.com>
Subject: Re: boot slow down
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello James,

On Sat, Aug 4, 2012 at 12:52 PM, James <bjlockie@lockie.ca> wrote:
> There's a big pause before the 'unable'
>
> [    2.243856] usb 4-1: Manufacturer: Logitech
> [   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw
>
>
> I have a cx23885
> cx23885[0]: registered device video0 [v4l2]
>
> Is there any way to stop it from trying to load the firmware?
> What is the firmware for, analog tv? Digital works fine and analog is useless to me.
>

I'm not sure what that firmware is for, but if you're certain you don't need it
then I'd suggest you try to blacklist cx25840 module, or just erase it.

This way cx23885 won't be able to load cx25840, and therefore the load
the firmware.
(I  think cx23885 won't fail to load if cx25840 is not available).

> I assume it is timing out there.
>

I guess that the firmware file is not present, could you check that?.
In that case, why is not present?

Hope this helps,
Ezequiel.
