Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39624 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2GDLBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 07:01:09 -0400
Received: by gglu4 with SMTP id u4so6295023ggl.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 04:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+_MOwRbsj_oa9RGRTVUwnZ0=DUqsrWyU-6bB7no3J_SA0PtFQ@mail.gmail.com>
References: <CA+_MOwRbsj_oa9RGRTVUwnZ0=DUqsrWyU-6bB7no3J_SA0PtFQ@mail.gmail.com>
Date: Wed, 4 Jul 2012 08:01:07 -0300
Message-ID: <CALF0-+XvJchgSufv7WZ4EWfS5yUS2szfK1090bs2+p8edr+=eQ@mail.gmail.com>
Subject: Re: Easycap
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Robert Walter <rolinbee@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

I've added linux-media on Cc since someone might find your
question on interest.

On Wed, Jul 4, 2012 at 3:16 AM, Robert Walter <rolinbee@gmail.com> wrote:
> I wonder if you could point me in the right direction? I bought an easy-cap
> video capture device but it doesn't look like anything I've seen before.
> The USB ID is 1b71:3002 and lsusb -v tells me the USB bridge is made by
> Fuchsia and the device name is usbtv007. I would like to know if this device
> is supported in Linux and if not, what is the preferred way to get a device
> supported.
>

There is currently no driver supporting 0x1b71 vendor id.

It seems Chinese manufacturers like to make usb capture devices
and use the name Easycap for every one of them :-)

However, since usb bridge chip is different,
a completely new driver should be written;
and unless you can get a datasheet the
only way I know to (blindly) write such driver
is with a lot of reverse engineering.

Good luck,
Ezequiel.
