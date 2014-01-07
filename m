Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59826 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaAGPy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 10:54:56 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so321583wgh.14
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 07:54:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140107125830.4525c52c@samsung.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
	<CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
	<20140107125830.4525c52c@samsung.com>
Date: Tue, 7 Jan 2014 10:54:54 -0500
Message-ID: <CAGoCfiwweitb7UGfk3K87Bs6aaEMca5B-7=wjJnJexkNiQkXHg@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Tim Mester <ttmesterr@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tim Mester <tmester@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 7, 2014 at 9:58 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Patches 1 and 2 are ok? If so, could you please reply to them with your
> ack?

Sure, no problem.

>> http://git.kernellabs.com/?p=dheitmueller/linuxtv.git;a=shortlog;h=refs/heads/950q_improv
>>
>> I'm not against the hack you've proposed if it's really warranted, but
>> a reset is really a last resort and I'm very concerned it's masking
>> over the real problem.
>
> Are you planning to submit the above patches upstream soon?

Yeah, I've just been busy and haven't had a chance to send them to the
list (except for the last patch on the series, which is customer
specific).  I've got a couple of others which haven't been pushed and
need to be put onto that series before it can be merged.  Will
definitely be good to get it all upstream before somebody does some
refactoring and then a rebase is required.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
