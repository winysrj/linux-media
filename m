Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:49148 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZHCB0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 21:26:03 -0400
Received: by yxe5 with SMTP id 5so1642337yxe.33
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 18:26:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A74C64D.80708@iol.it>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <4A7140DD.7040405@iol.it>
	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	 <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it> <4A74C64D.80708@iol.it>
Date: Sun, 2 Aug 2009 21:26:02 -0400
Message-ID: <829197380908021826t5cedc918r37ce6e3d780de2a7@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 1, 2009 at 6:48 PM, Valerio Messina<efa@iol.it> wrote:
> Valerio Messina ha scritto:
>>
>> Devin Heitmueller ha scritto:
>>>
>>> Ah, good news:  the patch I wrote that adds support for the remote
>>> control is still around:
>>>
>>> http://linuxtv.org/hg/~dheitmueller/v4l-dvb-terratec-xs/rev/92885f66ac68
>>>
>>> I will prep this into a new tree and issue a pull request when I get
>>> back in town on Sunday.
>>
>> hi,
>> I tried to apply the patch, recompile, install and reboot.
>> Same results, IR does not send digit to text editor or Kaffeine.
>>
>> What other can I do for further help/testing?
>
> I tried another thing.
> I unzipped a 2009-01-29 version of
> http://mcentral.de/hg/~mrec/v4l-dvb-kernel
> the last I used on Ubuntu 8.10, not really updated but worked,
> recompiled for the new Ubuntu kernel
> 2.6.28-14-generic
> install and reboot.
> This one work, IR send digit to text editor and Kaffeine.
> Now I remember, with past Ubuntu version I used mcentral modules, and not
> linuxtv ones. This is why IR worked for me.
>
> I uploaded this shot of the disappeared mercurial repositories here:
> http://sharebee.com/fed68f5f
> all in all is all GPL code.
>
> I looked at the code, and see that 'v4l-dvb-kernel' consist of less files,
> in particular are 296 files, while 'v4l-dvb' are 7916, probably because
> there are only em28xx related files.
> The source tree have some different organization.
> I see that:
> v4l-dvb/linux/include/media/ir-common.h
> and
> v4l-dvb/linux/drivers/media/common/ir-keymaps.c
> does not exist
>
> v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c
> is located here:
> v4l-dvb-kernel/em28xx-cards.c
> and diff report lot lot of differencies.
>
> hope this helps integrating IR support,
> Valerio
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Valerio,

I'll get my patched merged (and make sure I didn't miss something).
There is no need for the mcentral.de tree.

I had the whole thing working so perhaps the code that enabled the IR
support was in a separate patch.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
