Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:36940 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbcLEPuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 10:50:17 -0500
Message-ID: <1480953002.16064.7.camel@v3.sk>
Subject: Re: [PATCH] [media] usbtv: add a new usbid
From: Lubomir Rintel <lkundrak@v3.sk>
To: Icenowy Zheng <icenowy@aosc.xyz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Federico Simoncelli <fsimonce@redhat.com>
Date: Mon, 05 Dec 2016 16:50:02 +0100
In-Reply-To: <20161205184757.lrn0cE4H@smtp3p.mail.yandex.net>
References: <20161205184757.lrn0cE4H@smtp3p.mail.yandex.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-12-05 at 23:47 +0800, Icenowy Zheng wrote:
> 2016年12月5日 19:49于 Lubomir Rintel <lkundrak@v3.sk>写道：
> > 
> > On Sun, 2016-12-04 at 22:59 +0800, Icenowy Zheng wrote: 
> > > 
> > > 04.12.2016, 22:00, "Icenowy Zheng" <icenowy@aosc.xyz>: 
> > > > A new usbid of UTV007 is found in a newly bought device. 
> > > > 
> > > > The usbid is 1f71:3301. 
> > > > 
> > > > The ID on the chip is: 
> > > > UTV007 
> > > > A89029.1 
> > > > 1520L18K1 
> > > > 
> > > 
> > > Seems that my device come with more capabilities. 
> > > 
> > > I tested it under Windows, and I got wireless Analog TV 
> > > and FM radio functions. (An antenna is shipped with my device) 
> > > 
> > > Maybe a new radio function is be added, combined with the 
> > > new USB ID. 
> > > 
> > > But at least Composite AV function works well with current usbtv 
> > > driver and XawTV. 
> > 
> > Well, someone with the hardware would need to capture the traffic
> > from 
> > the Windows driver (and ideally also extend the driver). Would you
> > mind 
> > giving it a try? 
> 
> How to do it?
> 
> Use wireshark?

Yes, wireshark is okay. I've been using that one.

Another good option I discovered recently is usb_capture from usbsniff
package.

> > Do you have a link to some further details about the device you
> > got? 
> > Perhaps if it's available cheaply from dealextreme or somewhere I
> > could 
> > take a look too. 
> 
> I bought directly from Taobao (I'm in China).

Do you happen to have a link?

Lubo
