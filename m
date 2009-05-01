Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:33297 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZEAFRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 01:17:00 -0400
Received: by yx-out-2324.google.com with SMTP id 3so1298095yxj.1
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 22:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
Date: Fri, 1 May 2009 01:17:00 -0400
Message-ID: <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Frank Dischner <phaedrus961@googlemail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2009 at 10:17 PM, Britney Fransen
<britney.fransen@gmail.com> wrote:
> On Apr 30, 2009, at 8:55 PM, Frank Dischner wrote:
>
>> As far as
>> I can tell, the only modification to the patch is the file it is
>> applied to.
>
> Frank, you are correct.  The only change I made was to the new _dig.c file
> that I believe changed with analog support.  Do you want to resubmit the
> patch with your "Signed-off-by:" line?  I don't think mine was/will be
> accepted into Patchwork because I omitted the "Signed-off-by:".
>
> Thanks for the info Andy.
>
> Britney
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

One more comment:  when resubmitting this patch, please change the
modulation values by removing the top bit from the register numbers.
In other words, change:

+       { 0x80a3, 0x09 },

to

+       { 0x00a3, 0x09 },

The top bit is actually not part of the register number, and it now
gets set automatically by the au8522_writereg() routine (I made this
change when I did the analog support).  I am going to take a pass over
all the registers in au8522_dig.c at some point, but it doesn't make
sense for any new code to set it.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
