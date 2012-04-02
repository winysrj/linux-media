Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40265 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2DBOio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 10:38:44 -0400
Received: by vbbff1 with SMTP id ff1so1725583vbb.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 07:38:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F79AA43.3070109@mlbassoc.com>
References: <4F799A99.9010209@mlbassoc.com>
	<CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com>
	<4F799F4F.9020606@mlbassoc.com>
	<CA+2YH7uesV_085_-LyKCm8zuEROy_6FRQg8XkiRsHubdTXF8ig@mail.gmail.com>
	<4F79AA43.3070109@mlbassoc.com>
Date: Mon, 2 Apr 2012 16:38:43 +0200
Message-ID: <CA+2YH7sWJr8oBnPssoQkOAA+7sB+Y=1kYD3Qhacb-56NJFjQgg@mail.gmail.com>
Subject: Re: OMAP3ISP won't start
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 2, 2012 at 3:31 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-04-02 07:15, Enrico wrote:
>>
>> On Mon, Apr 2, 2012 at 2:45 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>>>
>>> The items you mention are just what I merged from my previous kernel.
>>> My changes are still pretty rough but I can send them to you if you'd
>>> like.
>>
>>
>> Post them here and we will try to spot where the problem is, they
>> could be useful for Laurent too as a reference.
>
>
> Attached.

I just had a quick look and it seems everything is there, i can't test
it right now but when i did test a mainline 3.3 kernel with my patches
i had to use the "nohlt" kernel parm. If i'm not wrong without that
param i had the same error, you can give it a try.

Enrico
