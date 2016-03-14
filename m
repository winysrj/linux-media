Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:24824 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbcCNPLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 11:11:30 -0400
Date: Mon, 14 Mar 2016 16:11:24 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 7/7] [media] gspca: fix a v4l2-compliance failure during
 read()
Message-Id: <20160314161124.46ce9ace2d81ea57163698b0@ao2.it>
In-Reply-To: <56E199F1.5070707@redhat.com>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
	<1457539401-11515-8-git-send-email-ao2@ao2.it>
	<56E199F1.5070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 10 Mar 2016 16:59:45 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 09-03-16 17:03, Antonio Ospite wrote:
> > v4l2-compliance fails with this message:
> >
> >    fail: v4l2-test-buffers.cpp(512): Expected EBUSY, got 22
> >    test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> >
> > Looking at the v4l2-compliance code reveals that this failure is about
> > the read() callback.
> >
> > In gspca, dev_read() is calling vidioc_dqbuf() which calls
> > frame_ready_nolock() but the latter returns -EINVAL in a case when
> > v4l2-compliance expects -EBUSY.
> >
> > Fix the failure by changing the return value in frame_ready_nolock().
> >
> > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> > ---
> >   drivers/media/usb/gspca/gspca.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> > index 915b6c7..de7e300 100644
> > --- a/drivers/media/usb/gspca/gspca.c
> > +++ b/drivers/media/usb/gspca/gspca.c
> > @@ -1664,7 +1664,7 @@ static int frame_ready_nolock(struct gspca_dev *gspca_dev, struct file *file,
> >   		return -ENODEV;
> >   	if (gspca_dev->capt_file != file || gspca_dev->memory != memory ||
> >   			!gspca_dev->streaming)
> > -		return -EINVAL;
> > +		return -EBUSY;
> >
> >   	/* check if a frame is ready */
> >   	return gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i);
> 
> I'm not sure that this is the right fix:
>
> 
> 1) !gspca_dev->streaming should result in -EINVAL, this is the same as what videobuf2 is doing
> 2) gspca_dev->memory != memory should result in -EINVAL
> 3) gspca_dev->capt_file != file means calling dqbuf without having done reqbufs (through the same fd)
>     which certainly seemes like -EINVAL to me.
> 
> The actual problem is that dev_read() is not catching that mmap is being in use:
> 
> static ssize_t dev_read(struct file *file, char __user *data,
>                      size_t count, loff_t *ppos)
> {
> ...
>          if (gspca_dev->memory == GSPCA_MEMORY_NO) { /* first time ? */
>                  ret = read_alloc(gspca_dev, file);
>                  if (ret != 0)
>                          return ret;
>          }
> 
> It will skip the read_alloc since gspca_dev->memory is USERPTR or MMAP
> and then do a dqbuf with memory == GSPCA_MEMORY_READ, triggering the
> gspca_dev->memory != memory check.
> 
> There are a couple of issues here:
> 
> 1) gspca_dev->memory check without holding usb_lock, the taking and
> releasing of usb_lock should be moved from read_alloc() into dev_read()
> itself.
> 
> 2) dev_read() should not assume that reading is ok if
>     gspca_dev->memory == GSPCA_MEMORY_NO, it needs a:
> 
> if (gspca_dev->memory != GSPCA_MEMORY_NO &&
>      gspca_dev->memory != GSPCA_MEMORY_READ)
>      return -EBUSY;
> 
> (while holding the usb_lock so the above is wrong)
> 
> 3) If gspca_dev->memory == GSPCA_MEMORY_READ already the
>     stream could have been stopped. so we need to check
>     gspca_dev->streaming (while holding the usb_lock)
>     and do a streamon if it is not set (and then we can
>     remove the streamon from read_alloc())
> 
> So TL;DR: dev_read needs some love.
>

I'll try to take a look at this too later this week.

> Regards,
> 
> Hans
> 
> 
> p.s.
> 
> If you've time to work on v4l2 stuff what gspca really needs
> is to just have its buffer handling ripped out and be rewritten
> to use videobuf2. I would certainly love to see a patch for that.
> 

It'd be an interesting tasklet but I don't know when I'll be able to do
that.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
