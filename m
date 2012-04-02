Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:48099 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2DBOzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 10:55:25 -0400
Message-ID: <4F79BDCF.3070405@mlbassoc.com>
Date: Mon, 02 Apr 2012 08:55:11 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: OMAP3ISP won't start
References: <4F799A99.9010209@mlbassoc.com> <CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com> <4F799F4F.9020606@mlbassoc.com> <CA+2YH7uesV_085_-LyKCm8zuEROy_6FRQg8XkiRsHubdTXF8ig@mail.gmail.com> <4F79AA43.3070109@mlbassoc.com> <CA+2YH7sWJr8oBnPssoQkOAA+7sB+Y=1kYD3Qhacb-56NJFjQgg@mail.gmail.com>
In-Reply-To: <CA+2YH7sWJr8oBnPssoQkOAA+7sB+Y=1kYD3Qhacb-56NJFjQgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-04-02 08:38, Enrico wrote:
> On Mon, Apr 2, 2012 at 3:31 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2012-04-02 07:15, Enrico wrote:
>>>
>>> On Mon, Apr 2, 2012 at 2:45 PM, Gary Thomas<gary@mlbassoc.com>    wrote:
>>>>
>>>> The items you mention are just what I merged from my previous kernel.
>>>> My changes are still pretty rough but I can send them to you if you'd
>>>> like.
>>>
>>>
>>> Post them here and we will try to spot where the problem is, they
>>> could be useful for Laurent too as a reference.
>>
>>
>> Attached.
>
> I just had a quick look and it seems everything is there, i can't test
> it right now but when i did test a mainline 3.3 kernel with my patches
> i had to use the "nohlt" kernel parm. If i'm not wrong without that
> param i had the same error, you can give it a try.

Hurray, that does work.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
