Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65298 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3E3TuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 15:50:13 -0400
Received: by mail-bk0-f49.google.com with SMTP id 6so361569bkj.36
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 12:50:11 -0700 (PDT)
Message-ID: <51A7AD71.4010403@gmail.com>
Date: Thu, 30 May 2013 21:50:09 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Torsten Seyffarth <t.seyffarth@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: Cinergy TStick RC rev.3 (rtl2832u) only 4 programs
References: <51A73A88.9000601@gmx.de> <51A76FCA.3010803@gmail.com> <51A78CA5.5040502@gmx.de>
In-Reply-To: <51A78CA5.5040502@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.05.2013 19:30, Torsten Seyffarth wrote:

> Thanks for the answer so far.
> I actually updated the media modules from git but this didn't help.
> Messing around with the kernel is nothing I feel very comfortable with,
> yet. ;-)

Kernel won't bite you. :)

> But if I understand the linked discussion correctly it wouldn't help
> anyway. According to that the tuner is the problem and there is no
> solution at the moment. What I do not understand is, why did it work
> with the older kernel and the Ambrosa driver? Does it include a
> different driver for the e4000?

You've used the original driver provided by Realtek, 'dvb-usb-rtl2832'.
You are currently using GPL'd, 'dvb_usb_v2', 'dvb_usb_rtl28xxu' and
'e4000' designed by Antti & Thomas.


poma


