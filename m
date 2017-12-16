Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbdLPOOe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 09:14:34 -0500
Date: Sat, 16 Dec 2017 12:14:27 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Fabien DESSENNE <fabien.dessenne@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
Message-ID: <20171216121427.6307c584@recife.lan>
In-Reply-To: <abd7b14d-cda6-ab67-3c5b-7cbd0dbaa336@gmail.com>
References: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
        <0370257c-ce0c-792f-6c85-50ebc18975f9@st.com>
        <abd7b14d-cda6-ab67-3c5b-7cbd0dbaa336@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 16 Dec 2017 19:53:55 +0800
Jia-Ju Bai <baijiaju1990@gmail.com> escreveu:

> Hi,
> 
> On 2017/12/15 22:51, Fabien DESSENNE wrote:
> > Hi
> >
> > On 12/12/17 14:47, Jia-Ju Bai wrote:  
> >> The driver may sleep under a spinlock.
> >> The function call path is:
> >> bdisp_device_run (acquire the spinlock)
> >>     bdisp_hw_reset
> >>       msleep --> may sleep
> >>
> >> To fix it, msleep is replaced with mdelay.  
> > May I suggest you to use readl_poll_timeout_atomic (instead of the whole
> > "for" block): this fixes the problem and simplifies the code?  
> 
> Okay, I have submitted a patch according to your advice.
> You can have a look :)

This can still be usind mdelay() to wait for a long time.

It doesn't seem wise to do that, as it could cause system
contention. Couldn't this be reworked in a way to avoid
having the spin locked while sleeping?

Once we had a similar issue on Siano, and it was solved by this

commit 3cdadc50bbe8f04c1231c8af614cafd7ddd622bf
Author: Richard Zidlicky <rz@linux-m68k.org>
Date:   Tue Aug 24 09:52:36 2010 -0300

    V4L/DVB: dvb: fix smscore_getbuffer() logic
    
    Drivers shouldn't sleep while holding a spinlock. A previous workaround
    were to release the spinlock before callinc schedule().
    
    This patch uses a different approach: it just waits for the
    siano hardware to answer.
    
    Signed-off-by: Richard Zidlicky <rz@linux-m68k.org>
    Cc: stable@kernel.org
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

The code as changed to use wait_event() at the kthread that was
waiting for data to arrive. Only when the data is ready, the
code with the spin lock is called.

It made the driver a way more stable, and didn't add any penalties
of needing to do long delays on a non-interruptible code.

Thanks,
Mauro
