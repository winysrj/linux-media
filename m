Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966692AbeFSQdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 12:33:32 -0400
Date: Tue, 19 Jun 2018 12:33:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add TRACE_EVENTs in pwc_isoc_handler()
Message-ID: <20180619123329.52bf6216@gandalf.local.home>
In-Reply-To: <CAJs94EZAAuUS4rznPDmD=1aD8B72P0mLft+YDoNs+74pRXr+KA@mail.gmail.com>
References: <20180617143625.32133-1-matwey@sai.msu.ru>
        <20180618145854.2092c6e0@gandalf.local.home>
        <CAJs94EZAAuUS4rznPDmD=1aD8B72P0mLft+YDoNs+74pRXr+KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Jun 2018 19:23:04 +0300
"Matwey V. Kornilov" <matwey@sai.msu.ru> wrote:

> Hi Steven,
> 
> Thank you for valuable comments.
> 
> This is for measuring performance of URB completion callback inside PWC driver.
> What do you think about moving events to __usb_hcd_giveback_urb() in
> order to make this more generic? Like the following:
> 
>         local_irq_save(flags);
> // trace urb complete enter
>         urb->complete(urb);
> // trace urb complete exit
>         local_irq_restore(flags);
> 
> 

If that can work for you, I'm fine with that. Trace events may be
cheap, but they do come with some cost. I'd like to have all trace
events be as valuable as possible, and limit the "special case" ones.

-- Steve
