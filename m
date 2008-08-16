Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GCDlNU030024
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 08:13:47 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7GCDb3m011676
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 08:13:38 -0400
Received: by wa-out-1112.google.com with SMTP id j32so2303855waf.7
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 05:13:37 -0700 (PDT)
Message-ID: <7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
Date: Sat, 16 Aug 2008 07:13:37 -0500
From: "Mark Ferrell" <majortrips@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080816083613.51071257@mchehab.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Sat, Aug 16, 2008 at 6:36 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>
> Hi Mark,
>
> First of all, please review your patch with checkpatch.pl. I've seen a few
> non-compliances.
>
> If you're using -hg tree, this is as simple as doing: make
> checkpatch. Otherwise, you can use v4l/scripts/checkpatch.pl <my patch>

Thanks, ran make checkpatch and fixed the issues reported.

> I have also a few other comments:
>
> > +             switch (data & 0xFF) {
>
> The better is that all hexadecimal values to be on lowercase.

Agreed and corrected.

> > +static void ov534_setup(struct usb_device *udev)
> > +{
> > +     ov534_reg_verify_write(udev, 0xe7, 0x3a);
> > +
> > +     ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
> > +     ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
> > +     ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
>
>        Hmm... three times the same write?

Supposedly it requires 3 writes of 0x60 followed by a write of 0x42 to
initialize the sensor.  That particularly register sequence at one
point existed as ov534_sccb_init(), but it was only ever called once
and so it got moved into the general init.  It may need to get split
out again once more is known about configuring the camera.  Outside of
initialization all that is known is how to toggle the led and how to
get images from the camera.  Setting up the output modes and
controlling the sensor is still unknown unfortunately.

> > +     ov534_reg_write(udev, OV534_REG_ADDRESS, 0x42);
> > +
> > +     ov534_reg_verify_write(udev, 0xc2,0x0c);
>        ...
> > +     ov534_reg_verify_write(udev, 0xe7,0x3e);
>
> It is generally better and smaller to have a table instead of those long init sequences.

Will do.

> > +static void ov534_fillbuff(struct ov534_dev *dev, struct ov534_buffer *buf)
> > +{
>
> > +     tmpbuf = kmalloc(size + 4, GFP_ATOMIC);
> > +     if (!tmpbuf)
> > +             return;
>
> It would be better if you allocate the buffer at videobuf prep routines, instead of doing this for every buffer fill. Is there any reason why you just don't use vbuf instead of doing double buffering?

Attempting to bulk transfer directly to the vbuf resulted in a
deadlock.  I went back to the tmpbuf until I could figure out a better
solution as I am not partial to the double buffering at all.

> > +     /* Updates stream time */
> > +
> > +     dev->ms += jiffies_to_msecs(jiffies-dev->jiffies);
> > +     dev->jiffies = jiffies;
> > +     if (dev->ms >= 1000) {
> > +             dev->ms -= 1000;
> > +             dev->s++;
> > +             if (dev->s >= 60) {
> > +                     dev->s -= 60;
> > +                     dev->m++;
> > +                     if (dev->m > 60) {
> > +                             dev->m -= 60;
> > +                             dev->h++;
> > +                             if (dev->h > 24)
> > +                                     dev->h -= 24;
> > +                     }
> > +             }
> > +     }
> > +     sprintf(dev->timestr, "%02d:%02d:%02d:%03d",
> > +                     dev->h, dev->m, dev->s, dev->ms);
>
> You don't need the above. This is at vivi just because we want to print a
> timestamp at the video. Just remove it and timestr from dev.

Done

> I also didn't see any code to provide S1/S3 hibernation. This is probably not
> needed at vivi (since there's no hardware registers to be saved/restored - yet
> - I never tried to do suspend/resume with vivi working), but for sure this is
> needed for real devices ;) I suggest you to take a look, for example, at
> cafe_ccic, for its implementation (it is inside #ifdef CONFIG_PM).

Will do

--
Mark

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
