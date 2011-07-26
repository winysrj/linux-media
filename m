Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55242 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1GZNFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 09:05:31 -0400
Received: by ewy4 with SMTP id 4so395221ewy.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 06:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j0mck9$vh4$1@dough.gmane.org>
References: <AANLkTinprP=o6_TnPjj1ieZAp27qmW-nuWHq04dN1oVp@mail.gmail.com>
	<AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com>
	<j0m9s7$e9j$1@dough.gmane.org>
	<CAGoCfizFA75Lyyx49EEJO9n5Smw1trBX7Azdu1iYrAqpYnDE8g@mail.gmail.com>
	<j0mck9$vh4$1@dough.gmane.org>
Date: Tue, 26 Jul 2011 09:05:28 -0400
Message-ID: <CAGoCfiwiqFkQ_zixgfEB7O19t1nTStJS+8RgfNAbXW3EzTaAuA@mail.gmail.com>
Subject: Re: driver problem: cx231xx error -71 with Hauppauge USB live2 on
 Ubuntu 11.04, netbook edition
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Doychin Dokov <root@net1.cc>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 26, 2011 at 8:40 AM, Doychin Dokov <root@net1.cc> wrote:
> I find only the Sunday fix for the power ramp issue, which states it's for a
> problem caused by the config hz being different of 100. Is this the patch
> you point me to, and do you think it's the solution in my case?
>
> # cat /boot/config-2.6.38-10-server | grep CONFIG_HZ
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100

There were actually two patches sent over the weekend, but the power
ramp issue was only for people who had CONFIG_HZ set to 1000.  In your
case, you only need the first patch.

See the email with subject: "[PATCH] Fix regression introduced which
broke the Hauppauge USBLive 2" for the patch you need.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
