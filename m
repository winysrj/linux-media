Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:20872 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZEAFKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 01:10:30 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1294067ywb.1
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 22:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
Date: Fri, 1 May 2009 01:10:30 -0400
Message-ID: <412bdbff0904302210j1eb34312y9f25ab8a5f83aa56@mail.gmail.com>
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

Hello,

Structurally the patch looks sane, although I want to have a closer
look at the actual modulation table values themselves before I merge
this in.

In the meantime, if Frank could please resubmit this patch against the
current tip, I will get it into my tree with some other patches
queuing up, do some testing, and issue a PULL request.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
