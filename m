Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0EHB0d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 21:26:33 -0400
Message-ID: <4BE4BDB5.60509@redhat.com>
Date: Fri, 07 May 2010 22:26:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Status of the patches under review (85 patches) and some misc
 	notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <x2w1a297b361005070610lda8d8d2ve90011bbfff320ee@mail.gmail.com>
In-Reply-To: <x2w1a297b361005070610lda8d8d2ve90011bbfff320ee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Fri, May 7, 2010 at 4:39 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Hi,
>>
> 
>> This is the summary of the patches that are currently under review.
>> Each patch is represented by its submission date, the subject (up to 70
>> chars) and the patchwork link (if submitted via email).
>>
>> P.S.: This email is c/c to the developers that some review action is expected.
>>
>> May, 7 2010: [v2] stv6110x Fix kernel null pointer deref when plugging two TT s2-16 http://patchwork.kernel.org/patch/97612
> 
> 
> How is this patch going to fix a NULL ptr dereference when more than 1
> card is plugged in ? The patch doesn't seem to do what the patch title
> implies. At least the patch title seems to be wrong. Maybe the patch
> is supposed to check for a possible NULL ptr dereference when put to
> sleep ?

(c/c patch author, to be sure that he'll see your explanation request)

His original patch is at:
	https://patchwork.kernel.org/patch/91929/

The original description with the bug were much better than version 2.

>From his OOPS log and description, I suspect that he's facing some
sort of race condition with the two cards. 

This fix seems still valid (with an updated comment), as his dump
proofed that there are some cases where fe->tuner_priv can be null, 
generating an OOPS, but it seems that his patch is combating
the effect, and not the cause.

So, I am for adding his patch for now, and then work on a more complete
approach for the two cards environment.

-- 

Cheers,
Mauro
