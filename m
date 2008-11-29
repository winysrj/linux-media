Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATLkeUQ024897
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 16:46:40 -0500
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATLkRfI011083
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 16:46:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Brownell <david-b@pacbell.net>
Date: Sat, 29 Nov 2008 22:46:20 +0100
References: <200811291852.41794.hverkuil@xs4all.nl>
	<200811291220.47542.david-b@pacbell.net>
In-Reply-To: <200811291220.47542.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200811292246.20338.hverkuil@xs4all.nl>
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

On Saturday 29 November 2008 21:20:47 David Brownell wrote:
> On Saturday 29 November 2008, Hans Verkuil wrote:
> > +void v4l2_device_register(struct device *dev, struct v4l2_device
> > *v4l2_dev) +{
> > +       BUG_ON(!dev || !v4l2_dev || dev_get_drvdata(dev));
>
> Ouch.  Better to return -EINVAL, like most register() calls,
> than *ever* use a BUG_ON() for bad parameters.  Same applies
> every other place you use BUG_ON, from a quick scan ...

Are there some documented guidelines on when to use BUG_ON? I see it 
used in other places in this way. My reasoning was that returning an 
error makes sense if external causes can result in an error, but this 
test is more the equivalent of an assert(), i.e. catching a programming 
bug early.

> For the unregister() paths a WARN() would be fair.  Again,
> any time you're tempted to use BUG() or BUG_ON(), you need
> to re-think.  It's hardly ever the right thing to do.  Just
> report the error and continue; callers should check, and
> clean up if something went wrong.
>
> > +EXPORT_SYMBOL(v4l2_device_register);
>
> This may be a nit, but I wonder why not EXPORT_SYMBOL_GPL,
> which seems to be more correct in this case.

I was under the impression that the v4l core was all EXPORT_SYMBOL, but 
I took another look and a lot is now EXPORT_SYMBOL_GPL, so I guess I 
should use that as well.

> Another quasi-style point:  v4l2-device.s and v4l-subdev.c
> are so small, and conceptually related, that I'd be tempted
> to have one file not two.  Ditto their headers.

They are small now, but they will become a lot larger in the future. 
There is a lot of common code in most if not all of the v4l drivers and 
my intention is to gradually expand the framework and move some of the 
common code into these headers/sources. This is just the start.

>
> - Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
