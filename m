Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipb21b9510.dynamic.kabel-deutschland.de ([178.27.149.16]:53827
	"EHLO zaxnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbHQHxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2015 03:53:44 -0400
Date: Mon, 17 Aug 2015 09:37:24 +0200
From: Zahari Doychev <zax@zaxnet.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Zahari Doychev <zahari.doychev@linux.com>,
	linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] m2m: fix bad unlock balance
Message-ID: <20150817073723.GB22469@mail>
References: <cover.1436361987.git.zahari.doychev@linux.com>
 <ccf89324d232ddb3861bde57379d044bc587e5d5.1436361987.git.zahari.doychev@linux.com>
 <55B74514.6010601@xs4all.nl>
 <55CB3135.8080706@samsung.com>
 <CAP3TMiGi=JswcQV=WmjG-Ds0-pTdBgErPsq9SN=2L0ACdYfc_w@mail.gmail.com>
 <55CDD7BF.8070105@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55CDD7BF.8070105@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 14, 2015 at 01:57:51PM +0200, Hans Verkuil wrote:
> On 08/12/2015 05:50 PM, Kamil Debski wrote:
> > Hi,
> > 
> > On 12 August 2015 at 13:42, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >> Hello Hans,
> >>
> >> I'm sorry for a delay. Once again I've been busy with some other internal
> >> stuff.
> >>
> >> On 2015-07-28 11:02, Hans Verkuil wrote:
> >>>
> >>> Kamil, Marek,
> >>>
> >>> Why does v4l2_m2m_poll unlock and lock in that function?
> >>
> >>
> >> I've checked the code and indeed the poll_wait() function doesn't do
> >> anything that
> >> should not be done with queue mutex being taken. I don't remember if it was
> >> always
> >> like that. You are right that the unlock&lock code should be removed.
> >>
> >>> Zahari is right that the locking is unbalanced, but I don't see the reason
> >>> for the unlock/lock sequence in the first place. I'm wondering if that
> >>> shouldn't just be removed.
> >>>
> >>> Am I missing something?
> >>>
> >>> Instead, I would expect to see a spin_lock_irqsave(&src/dst_q->done_lock,
> >>> flags)
> >>> around the list_empty(&src/dst_q->done_list) calls.
> >>
> >>
> >> Indeed, that's another thing that should be fixed in this function. I looks
> >> that
> >> commit c16218402a000bb25c1277c43ae98c11bcb59bd1 ("[media] videobuf2: return
> >> -EPIPE
> >> from DQBUF after the last buffer") is the root cause of both issues
> >> (unballanced
> >> locking and lack of spinlock protection), while the unnecessary queue
> >> unlock/lock
> >> sequence was there from the beginning.
> >>
> > 
> > I am all with Marek on this. Unlock/lock was there from the beginning,
> > it is not necessary. I agree also that spin_lock/unlock should be
> > added for the list_empty call.
> 
> Zahari, will you make a new version of this patch with the suggested changes?

yes I will do it.

Regards

Zahari

> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
