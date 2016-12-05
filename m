Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:35845 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbcLEL5B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 06:57:01 -0500
Message-ID: <1480938555.16064.3.camel@v3.sk>
Subject: Re: [PATCH] [media] usbtv: add a new usbid
From: Lubomir Rintel <lkundrak@v3.sk>
To: Icenowy Zheng <icenowy@aosc.xyz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Federico Simoncelli <fsimonce@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 05 Dec 2016 12:49:15 +0100
In-Reply-To: <14085351480863591@web18g.yandex.ru>
References: <20161204135943.34465-1-icenowy@aosc.xyz>
         <14085351480863591@web18g.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-12-04 at 22:59 +0800, Icenowy Zheng wrote:
> 
> 04.12.2016, 22:00, "Icenowy Zheng" <icenowy@aosc.xyz>:
> > A new usbid of UTV007 is found in a newly bought device.
> > 
> > The usbid is 1f71:3301.
> > 
> > The ID on the chip is:
> > UTV007
> > A89029.1
> > 1520L18K1
> > 
> 
> Seems that my device come with more capabilities.
> 
> I tested it under Windows, and I got wireless Analog TV
> and FM radio functions. (An antenna is shipped with my device)
> 
> Maybe a new radio function is be added, combined with the
> new USB ID.
> 
> But at least Composite AV function works well with current usbtv
> driver and XawTV.

Well, someone with the hardware would need to capture the traffic from
the Windows driver (and ideally also extend the driver). Would you mind
giving it a try?

Do you have a link to some further details about the device you got?
Perhaps if it's available cheaply from dealextreme or somewhere I could
take a look too.

Lubo
