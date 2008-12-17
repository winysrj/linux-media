Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHJUmnV021333
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:30:48 -0500
Received: from smtp-vbr8.xs4all.nl (smtp-vbr8.xs4all.nl [194.109.24.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHJUZB0012955
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:30:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Date: Wed, 17 Dec 2008 20:30:32 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<200812171437.33695.hverkuil@xs4all.nl>
	<20081217181645.GA26161@kroah.com>
In-Reply-To: <20081217181645.GA26161@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812172030.32535.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wednesday 17 December 2008 19:16:45 Greg KH wrote:
> On Wed, Dec 17, 2008 at 02:37:33PM +0100, Hans Verkuil wrote:
> > > Again, don't use cdev's reference counting for your own object
> > > lifecycle, it is different and will cause problems, like you have
> > > found out.
> >
> > Sigh. It has nothing to do with how v4l uses it. And to demonstrate
> > this, here is how you reproduce it with the sg module (tested it with
> > my USB harddisk).
> >
> > 1) apply this patch to char_dev.c:
>
> <snip>
>
> Ok, since I can't convince you that using a cdev for your reference
> counting is incorrect, I'll have to go change the cdev code to prevent
> you from doing this :(

Erm, you haven't told me yet why it's a bad idea. You just said "don't do 
it", but I haven't seen the reason for it. There doesn't seem to be any 
documentation on how to properly use cdev besides the Kernel Device Drivers 
book, which (if memory serves) doesn't mention anything on this topic.

I really don't mind implementing refcounting in the v4l framework, I just 
want to understand why it should be done like that!

It seems to me that I will just be shadowing the refcounting of cdev if I 
implement refcounting in v4l: init to 1 on creation, increase on open, 
decrease on close, decrease on deletion. It's all terribly familiar...

> Anyway, do you have a patch for the cdev code to propose how to fix this
> issue you are having?

Sure, here it is:

--- fs/char_dev.c.orig	2008-12-17 20:28:40.000000000 +0100
+++ fs/char_dev.c	2008-12-17 20:28:49.000000000 +0100
@@ -345,7 +345,9 @@
 {
 	if (p) {
 		struct module *owner = p->owner;
+		spin_lock(&cdev_lock);
 		kobject_put(&p->kobj);
+		spin_unlock(&cdev_lock);
 		module_put(owner);
 	}
 }
@@ -415,14 +417,12 @@
 
 static void cdev_purge(struct cdev *cdev)
 {
-	spin_lock(&cdev_lock);
 	while (!list_empty(&cdev->list)) {
 		struct inode *inode;
 		inode = container_of(cdev->list.next, struct inode, i_devices);
 		list_del_init(&inode->i_devices);
 		inode->i_cdev = NULL;
 	}
-	spin_unlock(&cdev_lock);
 }
 
 /*
@@ -478,7 +478,9 @@
 void cdev_del(struct cdev *p)
 {
 	cdev_unmap(p->dev, p->count);
+	spin_lock(&cdev_lock);
 	kobject_put(&p->kobj);
+	spin_unlock(&cdev_lock);
 }

This solves this particular problem. But this will certainly break v4l as it 
is right now, since the spin_lock means that the kref's release cannot do 
any sleeps, which is possible in v4l. If we want to allow that in cdev, 
then the spinlock has to be replaced by a mutex. But I have the strong 
feeling that that's not going to happen :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
