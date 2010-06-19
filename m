Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58008 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab0FSTRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 15:17:49 -0400
Received: by pwi1 with SMTP id 1so874744pwi.19
        for <linux-media@vger.kernel.org>; Sat, 19 Jun 2010 12:17:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100619185817.GA20032@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
	<AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
	<20100616205745.GA22103@linux-m68k.org>
	<AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
	<20100617200037.GA6530@linux-m68k.org>
	<AANLkTilA7_uw8memTQfyv5-YJD02HaroYmKJuSzePZBS@mail.gmail.com>
	<20100619185817.GA20032@linux-m68k.org>
Date: Sat, 19 Jun 2010 20:17:48 +0100
Message-ID: <AANLkTinWJe3dvQZ2407OZjQXNObkUb6o3n_1_nJGaePN@mail.gmail.com>
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 19, 2010 at 7:58 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> did you test the hardware with the evil OS?

I did try that with an old laptop and couldn't get it to work. So it
is quite possible it's a hardware fault.

>> Alternatively what is a well supported usb DVB-T tunner? I've also
>> bought an Avermedia Volar HX and a Gigabyte 7200 which seem to have at
>> best some half-assed out-of-tree drivers.
>
> I am using
>  idVendor=2040, idProduct=5500
>  WinTV MiniStick
>  Manufacturer: Hauppauge Computer Works
>
> works reasonably well, needs a patch to enable remote.

I see Hauppauge seems to be well supported. I may replace it with one
of those then.

Pedro
