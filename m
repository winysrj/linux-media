Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:63220 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2GJMeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:34:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
Date: Tue, 10 Jul 2012 14:34:25 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com> <201207100839.32830.hverkuil@xs4all.nl> <CALF0-+VKNfp=_qUzoTKfJO_nsj_e+29pnNAt5Ze-BCewccBjJA@mail.gmail.com>
In-Reply-To: <CALF0-+VKNfp=_qUzoTKfJO_nsj_e+29pnNAt5Ze-BCewccBjJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207101434.25254.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 10 July 2012 14:26:11 Ezequiel Garcia wrote:
> Hi Hans,
> 
> On Tue, Jul 10, 2012 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tue July 10 2012 05:17:41 Ezequiel Garcia wrote:
> >> Hey Mauro,
> >>
> >> On Fri, Jul 6, 2012 at 11:41 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> >> > On Thu, Jul 5, 2012 at 9:01 PM, Mauro Carvalho Chehab
> >> > <mchehab@redhat.com> wrote:
> >> >> Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
> >> >>> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
> >> >>>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> >> >>>>> +{
> >> >>>>> +   struct stk1160 *dev = video_drvdata(file);
> >> >>>>> +
> >> >>>>> +   if (!stk1160_is_owner(dev, file))
> >> >>>>> +           return -EBUSY;
> >> >>>>> +
> >> >>>>> +   return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
> >
> > Take a look at the latest videobuf2-core.h: I've added helper functions
> > that check the owner. You can probably simplify the driver code quite a bit
> > by using those helpers.
> 
> Ok.
> 
> >
> >> >>>>
> >> >>>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
> >> >>>
> >> >>> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
> >> >>> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
> >> >>> information out from file->f_flags.
> >> >>
> >> >> Ah! OK then.
> >> >>
> >> >> It might be better to initialize it during vb2 initialization, at open,
> >> >> instead of requiring this argument every time vb_dqbuf() is called.
> >
> > You can't do this at open since the application can change the NONBLOCK mode
> > after open. So the current approach is correct.
> 
> Yes, that sounds ok. Let's wait until Mauro returns from holiday to discuss this
> with him.
> 
> Also, what do you think about current_norm usage?

Don't use it. Implement g_std instead. current_norm really doesn't add anything
useful, it is a bit too magical and it doesn't work if you have multiple nodes
that share the same std (e.g. video and vbi).

I'm removing it from existing drivers whenever I have the chance, and it will
eventually go away.

Regards,

	Hans
