Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3250 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2GJGkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 02:40:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
Date: Tue, 10 Jul 2012 08:39:32 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com> <CALF0-+W_rNqn-cXK76DJH=5DtdgmvzrfDg-ZcF_RHu_-2pGR2w@mail.gmail.com> <CALF0-+WhLkraoL2ckVAqcU044z5tJ3xaWg1EXByBpzKn8My8iQ@mail.gmail.com>
In-Reply-To: <CALF0-+WhLkraoL2ckVAqcU044z5tJ3xaWg1EXByBpzKn8My8iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207100839.32830.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue July 10 2012 05:17:41 Ezequiel Garcia wrote:
> Hey Mauro,
> 
> On Fri, Jul 6, 2012 at 11:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > On Thu, Jul 5, 2012 at 9:01 PM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> >> Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
> >>> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
> >>>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> >>>>> +{
> >>>>> +   struct stk1160 *dev = video_drvdata(file);
> >>>>> +
> >>>>> +   if (!stk1160_is_owner(dev, file))
> >>>>> +           return -EBUSY;
> >>>>> +
> >>>>> +   return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);

Take a look at the latest videobuf2-core.h: I've added helper functions
that check the owner. You can probably simplify the driver code quite a bit
by using those helpers.

> >>>>
> >>>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
> >>>
> >>> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
> >>> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
> >>> information out from file->f_flags.
> >>
> >> Ah! OK then.
> >>
> >> It might be better to initialize it during vb2 initialization, at open,
> >> instead of requiring this argument every time vb_dqbuf() is called.

You can't do this at open since the application can change the NONBLOCK mode
after open. So the current approach is correct.

Regards,

	Hans

> Currently stk1160 doesn't implement an open call, but uses v4l2_fh_open instead.
> I'm not sure I should add a separate open, or perhaps you would accept
> to initialize this non-block flag in vidioc_reqbufs.
> 
> On the other hand, many drivers are doing it at dqbuf, like here at stk1160,
> and I was wondering: is it *that* bad?
> 
> Thanks,
> Ezequiel.
> 
