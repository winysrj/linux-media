Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41854 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2DBPvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 11:51:38 -0400
Received: by bkcik5 with SMTP id ik5so2636646bkc.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 08:51:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F79BDCF.3070405@mlbassoc.com>
References: <4F799A99.9010209@mlbassoc.com>
	<CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com>
	<4F799F4F.9020606@mlbassoc.com>
	<CA+2YH7uesV_085_-LyKCm8zuEROy_6FRQg8XkiRsHubdTXF8ig@mail.gmail.com>
	<4F79AA43.3070109@mlbassoc.com>
	<CA+2YH7sWJr8oBnPssoQkOAA+7sB+Y=1kYD3Qhacb-56NJFjQgg@mail.gmail.com>
	<4F79BDCF.3070405@mlbassoc.com>
Date: Mon, 2 Apr 2012 17:51:36 +0200
Message-ID: <CA+2YH7uj7+qs-0PapfVEaHNFRQ=KHFSmLMHg60AYKbTQod-=eQ@mail.gmail.com>
Subject: Re: OMAP3ISP won't start
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 2, 2012 at 4:55 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-04-02 08:38, Enrico wrote:
>>> Attached.
>>
>>
>> I just had a quick look and it seems everything is there, i can't test
>> it right now but when i did test a mainline 3.3 kernel with my patches
>> i had to use the "nohlt" kernel parm. If i'm not wrong without that
>> param i had the same error, you can give it a try.
>
>
> Hurray, that does work.

Laurent, this is an old problem that i noticed some time ago [1] but
apparently things are getting worse.

The situation now is:

kernel 3.2 without cpu_idle: no need for nohlt
kernel 3.2 with cpu_idle: nohlt is needed
kernel 3.3 with/without cpu_idle: nohlt always needed

I really don't know where the problem comes from, but i verified that
the cam powerdomain is correctly "acquired" during capture, i don't
know what else i can check.

[1]: http://www.digipedia.pl/usenet/thread/18550/20510/

Enrico
