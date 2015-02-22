Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35831 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbBVIxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 03:53:45 -0500
Received: by mail-ob0-f169.google.com with SMTP id wp4so31691347obc.0
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 00:53:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFxAcq9a+Q6evyPXUf_BOkSUW6oajaz-g+DCDpaaE2wc4w@mail.gmail.com>
References: <CAO_48GGT6C8-7gnKMcQ+rAQfvkEmyNzUmJAB=uJUJrFZSNo5sg@mail.gmail.com>
 <CA+55aFxAcq9a+Q6evyPXUf_BOkSUW6oajaz-g+DCDpaaE2wc4w@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Sun, 22 Feb 2015 14:23:24 +0530
Message-ID: <CAO_48GF_evt5x1QN_L4NJLMVKx__5-eZCcWFAXCj44+RZtBxUw@mail.gmail.com>
Subject: Re: [GIT PULL]: few dma-buf updates for 3.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

On 22 February 2015 at 01:42, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Feb 20, 2015 at 8:27 AM, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>>
>> Could you please pull a few dma-buf changes for 3.20-rc1? Nothing
>> fancy, minor cleanups.
>
> No.
>
> I pulled, and immediately unpulled again.
>
> This is complete shit, and the compiler even tells you so:
>
>     drivers/staging/android/ion/ion.c: In function ‘ion_share_dma_buf’:
>     drivers/staging/android/ion/ion.c:1112:24: warning: ‘buffer’ is
> used uninitialized in this function [-Wuninitialized]
>      exp_info.size = buffer->size;
>                             ^
>
> Introduced by "dma-buf: cleanup dma_buf_export() to make it easily extensible".
>
> I'm not taking "cleanups" like this.  And I certainly don't appreciate
> being sent completely bogus shit pull requests at the end of the merge
> cycle.

I apologize sincerely; I shouldn't have missed it before sending you
the pull request. (stupid copy-paste across files is certainly no
excuse for this).

This got caught in for-next too, but right after I sent the pull-request :(.

I also shouldn't have sent it so late in the merge cycle - this could
certainly wait till -rc2, which would've helped me correct it before
the request to you. Serves me right to try and meet the merge-cycle
deadline in a jet-lagged state!

I will definitely take extra precautions next time onward, so you
don't see negligence like this in my requests to you.

Apologies again!
>
>                            Linus

Best regards,
Sumit.
