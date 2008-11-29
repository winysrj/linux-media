Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATJrVgf023554
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 14:53:31 -0500
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATJrJrd028486
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 14:53:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Brownell <david-b@pacbell.net>
Date: Sat, 29 Nov 2008 20:53:15 +0100
References: <200811242309.37489.hverkuil@xs4all.nl>
	<200811291519.39549.hverkuil@xs4all.nl>
	<200811291146.44371.david-b@pacbell.net>
In-Reply-To: <200811291146.44371.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200811292053.16121.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 1/3)
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

On Saturday 29 November 2008 20:46:43 David Brownell wrote:
> On Saturday 29 November 2008, Hans Verkuil wrote:
> > > > +And this to go from an i2c_client to a v4l2_subdev struct:
> > > > +
> > > > +   struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > > > +
> > > > +Finally you need to make a command function to make
> > > > +driver->command() call the right subdev_ops functions:
> > > > +
> > > > +static int
> > > > +subdev_command(struct i2c_client *client, unsigned cmd, void
> > > > *arg) +{
> > > > +   return v4l2_subdev_command(i2c_get_clientdata(client), cmd,
> > > > arg); +}
> > > > +
> > > > +If driver->command is never used then you can leave this out.
> > > > +Eventually the driver->command usage should be removed from
> > > > v4l.
> > >
> > > Should it then be added to the list of features scheduled for
> > > removal?
> >
> > No, driver->command is part of the i2c subsystem and we are not the
> > only users, so it can't be scheduled for removal.
>
> ISTR that the only use of the i2c_driver.command() mechanism
> is for video/DVB driver support.  It's kind of an ugly wart,
> and it'd be good to see such ioctl-ish interfaces vanish.
>
> This came up a while back as part of a "how can we clean up
> the I2C stack" discussion.  So it would be nice if V4L2 wasn't
> effectively adding new reasons (and advice) to use this.

If v4l is indeed the only user, then once all i2c drivers are converted 
to this new sub device API, then command can indeed go away.

Would be nice, but it will probably take a few kernel cycles before we 
are there. It's a lot of work, but very worthwhile in my opinion.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
