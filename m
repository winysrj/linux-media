Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:38251 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIAU2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 16:28:03 -0400
Received: by mail-la0-f52.google.com with SMTP id ty20so6596790lab.39
        for <linux-media@vger.kernel.org>; Mon, 01 Sep 2014 13:28:01 -0700 (PDT)
Message-ID: <5404D729.4030202@googlemail.com>
Date: Mon, 01 Sep 2014 22:29:29 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Lorenzo Marcantonio <l.marcantonio@logossrl.com>
CC: linux-media@vger.kernel.org
Subject: Re: strange empia device
References: <20140825190109.GB3372@aika.discordia.loc> <5403358C.4070504@googlemail.com> <54033620.4000105@googlemail.com> <20140831154127.GA15276@aika.discordia.loc> <5404B781.9020702@googlemail.com> <20140901190301.GA3762@aika.discordia.loc>
In-Reply-To: <20140901190301.GA3762@aika.discordia.loc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 01.09.2014 um 21:03 schrieb Lorenzo Marcantonio:
> On Mon, Sep 01, 2014 at 08:14:25PM +0200, Frank Schäfer wrote:
>
>> What's the other device using this vid:pid and which hardware does it use ?
> The previous generation of the tool:
>
> http://www.linuxtv.org/wiki/index.php/RoxioEasyVHStoDVD
>
> ... an easycap DC60+ clone. Doubly hating it since I bought is sure that
> it would have been supported!
>
>> The big task is the integrated decoder. Makes no fun without a datasheet. :/
> I presume that with decoder you mean the composite to YUV translator... 
Yes.

> With the datasheet is too easy :D 
:D

> strange thing is eMPIA says that linux
> is supported for some of their chip. But of course the 2980 isn't even
> advertised 
It had been advertised in past, but they removed all informations about
it from their website. :-(

> and probably they only give you docs if you buy 100K pieces:(
...and sign an NDA (non-disclosure agreement).

>
>> Thanks, looks like the other em2980 we have seen (Dazzle Video Capture
>> USB V1.0).
> Please tell if there are other tests or captures you need.
At the moment, no.

>  By the way,
> even on Windows, transfer seems flaky. If the bus is not perfectly
> idle or there is some nontrivial CPU load often it loses transfer sync
> and the image get "split" (probably an isoc transfer get lost and it
> doesn't number the packets or something). 
Not our problem. ;-)

Regards,
Frank


> Had the same problem with the
> other chinese camera I used (USB suckitude knows no limits:P)


