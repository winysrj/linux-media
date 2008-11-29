Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATN6gI1014316
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 18:06:42 -0500
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATN6TN6005963
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 18:06:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Brownell <david-b@pacbell.net>
Date: Sun, 30 Nov 2008 00:06:21 +0100
References: <200811291852.41794.hverkuil@xs4all.nl>
	<200811292246.20338.hverkuil@xs4all.nl>
	<200811291422.20155.david-b@pacbell.net>
In-Reply-To: <200811291422.20155.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200811300006.22080.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
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

On Saturday 29 November 2008 23:22:19 David Brownell wrote:
> On Saturday 29 November 2008, Hans Verkuil wrote:
> > > > +void v4l2_device_register(struct device *dev, struct
> > > > v4l2_device *v4l2_dev) +{
> > > > +       BUG_ON(!dev || !v4l2_dev || dev_get_drvdata(dev));
> > >
> > > Ouch.  Better to return -EINVAL, like most register() calls,
> > > than *ever* use a BUG_ON() for bad parameters.  Same applies
> > > every other place you use BUG_ON, from a quick scan ...
> >
> > Are there some documented guidelines on when to use BUG_ON?
>
> Maybe there should be.  I know I've seen flames from Linus on
> the topic.  Basically, treat it like a panic() where the system
> must stop operation lest it catch fire or scribble all over the
> (not-backed-up) disk ... if the system can keep running sanely,
> then BUG() and friends are inappropriate.

I think it would be good to have some document about this, since
from what I've seen from a quick scan I'm not the only one who uses
it incorrectly. There is no documentation in the asm-generic/bug.h
header and there is also no documentation on this in the Documentation
directory.

> > I see it used in other places in this way.
>
> I tend to submit patches fixing bugs like that, when I have time.
>
> > My reasoning was that returning an
> > error makes sense if external causes can result in an error, but
> > this test is more the equivalent of an assert(), i.e. catching a
> > programming bug early.
>
> In which case a WARN() is better.  But in most cases I wouldn't
> even do that.  The kernel's design center is closer to "run
> robustly" than "make developers' lives easier".  Programmers
> who don't check return values for critical operations like
> registering core resources deserve what they get.  And if you
> want to nudge them, the __must_check annotation helps catch
> such goofage even earlier:  compile time, not run time.

I've replaced it as follows (and with __must_check in the header):

int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
{
        if (dev == NULL || v4l2_dev == NULL)
                return -EINVAL;
        /* Warn if we apparently re-register a device */
        WARN_ON(dev_get_drvdata(dev));
        INIT_LIST_HEAD(&v4l2_dev->subdevs);
        spin_lock_init(&v4l2_dev->lock);
        v4l2_dev->dev = dev;
        snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %s",
                        dev->driver->name, dev->bus_id);
        dev_set_drvdata(dev, v4l2_dev);
        return 0;
}
EXPORT_SYMBOL_GPL(v4l2_device_register);

void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
{
        struct v4l2_subdev *sd, *next;

        if (v4l2_dev == NULL || v4l2_dev->dev == NULL)
                return;
        dev_set_drvdata(v4l2_dev->dev, NULL);
        /* unregister subdevs */
        list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list)
                v4l2_device_unregister_subdev(sd);

        v4l2_dev->dev = NULL;
}
EXPORT_SYMBOL_GPL(v4l2_device_unregister);

int v4l2_device_register_subdev(struct v4l2_device *dev, struct v4l2_subdev *sd)
{
        /* Check for valid input */
        if (dev == NULL || sd == NULL || !sd->name[0])
                return -EINVAL;
        /* Warn if we apparently re-register a subdev */
        WARN_ON(sd->dev);
        if (!try_module_get(sd->owner))
                return -ENODEV;
        sd->dev = dev;
        spin_lock(&dev->lock);
        list_add_tail(&sd->list, &dev->subdevs);
        spin_unlock(&dev->lock);
        return 0;
}
EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);

void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
{
        /* return if it isn't registered */
        if (sd == NULL || sd->dev == NULL)
                return;
        spin_lock(&sd->dev->lock);
        list_del(&sd->list);
        spin_unlock(&sd->dev->lock);
        sd->dev = NULL;
        module_put(sd->owner);
}
EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);

Thanks for the review!

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
