Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760132AbdLSJk3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:40:29 -0500
Date: Tue, 19 Dec 2017 07:40:23 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Benjamin GAIGNARD" <benjamin.gaignard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
Message-ID: <20171219074023.5141e39e@recife.lan>
In-Reply-To: <9998c82a-fe50-49c1-3e0f-0719bd6abde4@st.com>
References: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
        <0370257c-ce0c-792f-6c85-50ebc18975f9@st.com>
        <abd7b14d-cda6-ab67-3c5b-7cbd0dbaa336@gmail.com>
        <20171216121427.6307c584@recife.lan>
        <9998c82a-fe50-49c1-3e0f-0719bd6abde4@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 09:01:41 +0000
Fabien DESSENNE <fabien.dessenne@st.com> escreveu:

> On 16/12/17 15:14, Mauro Carvalho Chehab wrote:
> > Em Sat, 16 Dec 2017 19:53:55 +0800
> > Jia-Ju Bai <baijiaju1990@gmail.com> escreveu:
> >  
> >> Hi,
> >>
> >> On 2017/12/15 22:51, Fabien DESSENNE wrote:  
> >>> Hi
> >>>
> >>> On 12/12/17 14:47, Jia-Ju Bai wrote:  
> >>>> The driver may sleep under a spinlock.
> >>>> The function call path is:
> >>>> bdisp_device_run (acquire the spinlock)
> >>>>      bdisp_hw_reset
> >>>>        msleep --> may sleep
> >>>>
> >>>> To fix it, msleep is replaced with mdelay.  
> >>> May I suggest you to use readl_poll_timeout_atomic (instead of the whole
> >>> "for" block): this fixes the problem and simplifies the code?  
> >> Okay, I have submitted a patch according to your advice.
> >> You can have a look :)  
> > This can still be usind mdelay() to wait for a long time.
> >
> > It doesn't seem wise to do that, as it could cause system
> > contention. Couldn't this be reworked in a way to avoid
> > having the spin locked while sleeping?
> >
> > Once we had a similar issue on Siano, and it was solved by this
> >
> > commit 3cdadc50bbe8f04c1231c8af614cafd7ddd622bf
> > Author: Richard Zidlicky <rz@linux-m68k.org>
> > Date:   Tue Aug 24 09:52:36 2010 -0300
> >
> >      V4L/DVB: dvb: fix smscore_getbuffer() logic
> >      
> >      Drivers shouldn't sleep while holding a spinlock. A previous workaround
> >      were to release the spinlock before callinc schedule().
> >      
> >      This patch uses a different approach: it just waits for the
> >      siano hardware to answer.
> >      
> >      Signed-off-by: Richard Zidlicky <rz@linux-m68k.org>
> >      Cc: stable@kernel.org
> >      Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> > The code as changed to use wait_event() at the kthread that was
> > waiting for data to arrive. Only when the data is ready, the
> > code with the spin lock is called.
> >
> > It made the driver a way more stable, and didn't add any penalties
> > of needing to do long delays on a non-interruptible code.
> >
> > Thanks,
> > Mauro  
> I have checked what was done there but I cannot see a simple way to do 
> the same in bdisp where the context is a bit different (the lock is 
> taken out in the central device_run, not locally in hw_reset) without 
> taking the risk to have unexpected side effects
> 
> Moreover, the bdisp_hw_reset() function called from bdisp_device_run is 
> not expected to last for a long time. The "one second" delay we are 
> talking about is a very large timeout protection. From my past 
> observations, the reset is applied instantly and we even never reach the 
> msleep() call (not saying it never happens).
> 
> For those two reasons, using readl_poll_timeout_atomic() seems to be the 
> best option.

OK. The best is then to document it at the source code, for others
to be aware, while reviewing the code, that, despite the large timeout, 
most of the time the reset happens without needing any delays.

Thanks,
Mauro
