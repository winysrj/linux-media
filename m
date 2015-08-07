Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34182 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945960AbbHGS6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 14:58:31 -0400
Received: by oip136 with SMTP id 136so58679976oip.1
        for <linux-media@vger.kernel.org>; Fri, 07 Aug 2015 11:58:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
Date: Fri, 7 Aug 2015 21:58:30 +0300
Message-ID: <CAKv9HNarT8D95Xk4hgKGyFrXuqJ2U-wk6UYGKCNJg+_hpQPPEQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] rc-core: Revert encoding patchset
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <antti.seppala@iki.fi>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 July 2015 at 22:16, David Härdeman <david@hardeman.nu> wrote:
> The current code is not mature enough, the API should allow a single
> protocol to be specified. Also, the current code contains heuristics
> that will depend on module load order.
>
> The issues were discussed in this thread:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg86998.html
>
> And Antti agreed at the end of the thread:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg86998.html
>
> This needs to go in upstream before 4.2 is released.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>
>

Almost missed this...

Yes, after discussing with David I think we can do the wakeup with
even better API than with the one we currently have.
So without further ado:
Acked-by: Antti Seppälä <a.seppala@gmail.com>
