Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2441 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2GEGzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 02:55:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [GIT PULL FOR v3.6] mostly remove V4L2_FL_LOCK_ALL_FOPS
Date: Thu, 5 Jul 2012 08:54:20 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201207041942.04606.hverkuil@xs4all.nl> <4FF49957.3070604@gmail.com>
In-Reply-To: <4FF49957.3070604@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207050854.20966.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed July 4 2012 21:28:23 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 07/04/2012 07:42 PM, Hans Verkuil wrote:
> > Hi Mauro,
> > 
> > This pull request builds on (and includes) this core patch series:
> > 
> > http://patchwork.linuxtv.org/patch/13180/
> > 
> > It is identical to the RFC patch series I posted before:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg48184.html
> > 
> > ...except that I dropped the patches touching s5p-fimc and fimc-lite and the
> > final patch removing the flag altogether.
> > 
> > Sylwester posted patches for those two drivers, but they won't apply. Sylwester,
> > can you rebase those patches? Once I have those, then I can make another pull
> > request that fixes those two drivers and removes the flag completely.
> 
> First of all, sorry about the trouble. These patches are available at:
> 
> git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-next
> 
> The first one was already included in a pull request with fixes for 3.5-rc:
> http://patchwork.linuxtv.org/patch/13149. It is not really needed for
> your V4L2_FL_LOCK_ALL_FOPS removal changeset. You only need the top one from 
> the above branch.
> 
> The reason why those 2 patches won't apply to the current media tree is 
> a pending fixups pull request from over a month ago - 
> http://patchwork.linuxtv.org/patch/11503. These are mostly important fixes 
> for new code that went into 3.5, and I'm really not happy they're still not 
> upstream :(
> 
> So I would propose you to merge v4l-fimc-fixes branch from
> git://git.infradead.org/users/kmpark/linux-samsung, then there won't be
> any merge conflicts.
> 
> Please feel free to add the top patch: 
> "s5p-fimc: Remove V4L2_FL_LOCK_ALL_FOPS flag"
> to your pull request including the patch removing V4L2_FL_LOCK_ALL_FOPS.
> 
> Here is a gitweb link:
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-fimc-next

Hi Sylwester,

It still doesn't apply. This patch starts with:

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index da2c40e..cb04a870 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -480,48 +480,59 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 static int fimc_capture_open(struct file *file)
 {
        struct fimc_dev *fimc = video_drvdata(file);
-       int ret;
+       int ret = -EBUSY;

The actual current source code starts with:

static int fimc_capture_open(struct file *file)
{
        struct fimc_dev *fimc = video_drvdata(file);
        int ret = v4l2_fh_open(file);

Quite different. That 'int ret = v4l2_fh_open(file);' line was added June 10th, 2011, so
I don't understand why that isn't in your git repository.

Regards,

	Hans
