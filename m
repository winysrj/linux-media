Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48476 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab0FRN2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jun 2010 09:28:39 -0400
Received: by pvg6 with SMTP id 6so455956pvg.19
        for <linux-media@vger.kernel.org>; Fri, 18 Jun 2010 06:28:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100617200037.GA6530@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com>
	<AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com>
	<20100616205745.GA22103@linux-m68k.org>
	<AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com>
	<20100617200037.GA6530@linux-m68k.org>
Date: Fri, 18 Jun 2010 14:28:38 +0100
Message-ID: <AANLkTilA7_uw8memTQfyv5-YJD02HaroYmKJuSzePZBS@mail.gmail.com>
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
From: =?UTF-8?Q?Pedro_C=C3=B4rte=2DReal?= <pedro@pedrocr.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 17, 2010 at 9:00 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> berr is supposed to be the bit error rate. The values displayed here appear to be
> bogus - then again I am not familiar with this particular driver so maybe just the
> error reporting is bogus. The w_scan results also look pretty bad.
>
> Newest kernel is allways worth a try.

I have tried a git snapshot of Linus' 2.6.35 kernel. Is there another
non-mainline tree I should try?

Would it help to get some kind of dvbsnoop log of this? I've tried
doing "dvbsnoop  -s pidscan" and "dvbsnoop 0" but didn't get anything
that seemed valid.

Alternatively what is a well supported usb DVB-T tunner? I've also
bought an Avermedia Volar HX and a Gigabyte 7200 which seem to have at
best some half-assed out-of-tree drivers.

Pedro
