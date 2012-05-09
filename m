Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60576 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2EISCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 14:02:03 -0400
Received: by obbtb18 with SMTP id tb18so600110obb.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 11:02:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205091957.02370.linux@rainbow-software.org>
References: <4FAA57A3.2030701@skorzen.net>
	<4FAA9942.5050703@skorzen.net>
	<CALF0-+V7NW737+_AHdXF=DhOEpXMy+LBZRgrX+n0kjrTwMuXpA@mail.gmail.com>
	<201205091957.02370.linux@rainbow-software.org>
Date: Wed, 9 May 2012 15:02:02 -0300
Message-ID: <CALF0-+Wj7rzOyA-YGY5k9HJ99reUJd+DAf_w90iGdf=G9tuFBw@mail.gmail.com>
Subject: Re: Dazzle DVC80 under FC16
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Bruno Martins <lists@skorzen.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, May 9, 2012 at 2:56 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Wednesday 09 May 2012 18:54:58 Ezequiel Garcia wrote:
>> Hi,
>>
>> Also please output lsmod with your device plugged and the list of your
>> installed modules (do you know how to do this?)
>>
>> I may be wrong, but this device should be supported by usbvision module.
>
> The log show that usbvision module is loaded but fails to set altsetting to 1.
> Probably because the device has two interfaces (note that the driver is also
> initialized twice).

Yes, I've just noticed this.

Perhaps, you could try using vlc and/or mplayer (instead of cheese)
and also try to use explicit device, i.e. /dev/video1 and/or
/dev/video2.

But if the driver fails to set alternate setting, then it will never
work, right?

Hope this helps,
Ezequiel.
