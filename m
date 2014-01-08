Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:49583 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaAHTIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 14:08:43 -0500
Received: by mail-we0-f171.google.com with SMTP id q58so1885182wes.30
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 11:08:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABMudhQ16ZhvFcwoTdHnU4B9cjVScV4Ohh81izoQDstWsV8X_A@mail.gmail.com>
References: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
	<CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
	<CABMudhQ16ZhvFcwoTdHnU4B9cjVScV4Ohh81izoQDstWsV8X_A@mail.gmail.com>
Date: Wed, 8 Jan 2014 14:08:42 -0500
Message-ID: <CAGoCfiws5YdmiY8wYkE4_=yKSc3WxABMyUZiT22rTafs-g4SnA@mail.gmail.com>
Subject: Re: How can I find out what is the driver for device node '/dev/video11'
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: m silverstri <michael.j.silverstri@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 8, 2014 at 2:03 PM, m silverstri
<michael.j.silverstri@gmail.com> wrote:
> Thanks. I don't have the a running hardware.
> If I can only search within the code space, how can I find out which
> driver is for '/dev/video11'?
>
> Is there a config file which I can look it up?

If you don't actually have the hardware platform, then determining it
just from the source code is a huge undertaking (unless it's some well
known device which happens to always create it at that offset).

What is the hardware platform, and what is the capture device?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
