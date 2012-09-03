Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2ICS1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 14:27:52 -0400
Received: by bkwj10 with SMTP id j10so2314521bkw.19
        for <linux-media@vger.kernel.org>; Mon, 03 Sep 2012 11:27:50 -0700 (PDT)
Message-ID: <5044F69E.9030901@googlemail.com>
Date: Mon, 03 Sep 2012 20:27:42 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Subject: Re: gspca_pac7302 driver broken ?
References: <5043943E.2090802@googlemail.com> <CALF0-+UqPu3Pw74XCtFwfZHOp_WS775y77xmEXisnbx8pzG2ew@mail.gmail.com>
In-Reply-To: <CALF0-+UqPu3Pw74XCtFwfZHOp_WS775y77xmEXisnbx8pzG2ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.09.2012 22:08, schrieb Ezequiel Garcia:
> Hi Frank,
>
> On Sun, Sep 2, 2012 at 2:15 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> Hi,
>>
>> can anyone who owns such a device confirm that the gspca_pac7302 driver
>> (kernel 3.6.0-rc1+) is fine ?
>>
> It's working here with latest media-tree kernel.
>
> Driver Info:
> 	Driver name   : gspca_pac7302
> 	Card type     : USB Camera (093a:2625)
> 	Bus info      : usb-0000:00:12.0-1
> 	Driver version: 3.6.0
> 	Capabilities  : 0x85000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x05000001
> 		Video Capture
> 		Read/Write
> 		Streaming
>
> Hope this helps,
> Ezequiel.

Ok, thank you for testing.
Then this device must be somehow different. :(
The driver seems to be "straight-forward", it basically writes static
sequences to registers and doesn't check things like chip ids etc.
So I guess it's time again for USB-sniffing...

Regards,
Frank



