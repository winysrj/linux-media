Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:23120 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZC2No1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 09:44:27 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1631612ywb.1
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 06:44:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090329124251.GF637@aniel>
References: <patchbomb.1238329154@aniel> <20090329124251.GF637@aniel>
Date: Sun, 29 Mar 2009 09:44:25 -0400
Message-ID: <412bdbff0903290644s3c70d5e7rfd4182f55650ead0@mail.gmail.com>
Subject: Re: [PATCH 5 of 6] au0828: use usb_interface.dev for
	v4l2_device_register
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 29, 2009 at 8:42 AM, Janne Grunau <j@jannau.net> wrote:
>

Hello Janne,

I'm not against this change, but you should also get rid of the "i"
variable and the au0828_instance list (since the v4l2_device.name was
the only purpose for both).

Also, your subject didn't really match the function of the patch.  Had
I not looked at the patch itself, I would have only thought you were
changing the v4l2_device_register().

Please put me on the CC: for anything related to au0828 analog
support, since I authored the code in question.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
