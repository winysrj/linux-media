Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAQO2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:28:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Fri, 17 Jan 2014 15:28:01 +0100
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-8-git-send-email-arnd@arndb.de> <52D90A2F.2030903@xs4all.nl>
In-Reply-To: <52D90A2F.2030903@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171528.02016.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 17 January 2014, Hans Verkuil wrote:
> > @@ -323,25 +324,32 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
> >       struct cadet *dev = video_drvdata(file);
> >       unsigned char readbuf[RDS_BUFFER];
> >       int i = 0;
> > +     DEFINE_WAIT(wait);
> >  
> >       mutex_lock(&dev->lock);
> >       if (dev->rdsstat == 0)
> >               cadet_start_rds(dev);
> > -     if (dev->rdsin == dev->rdsout) {
> > +     while (1) {
> > +             prepare_to_wait(&dev->read_queue, &wait, TASK_INTERRUPTIBLE);
> > +             if (dev->rdsin != dev->rdsout)
> > +                     break;
> > +
> >               if (file->f_flags & O_NONBLOCK) {
> >                       i = -EWOULDBLOCK;
> >                       goto unlock;
> >               }
> >               mutex_unlock(&dev->lock);
> > -             interruptible_sleep_on(&dev->read_queue);
> > +             schedule();
> >               mutex_lock(&dev->lock);
> >       }
> > +
> 
> This seems overly complicated. Isn't it enough to replace interruptible_sleep_on
> by 'wait_event_interruptible(&dev->read_queue, dev->rdsin != dev->rdsout);'?
> 
> Or am I missing something subtle?

The existing code sleeps with &dev->lock released because the cadet_handler()
function needs to grab (and release) the same lock before it can wake up
the reader thread.

Doing the simple wait_event_interruptible() would result in a deadlock here.

	Arnd
