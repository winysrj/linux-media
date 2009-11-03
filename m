Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA3ME9S4027886
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 17:14:09 -0500
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA3MDrwV029398
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 17:13:54 -0500
Received: by bwz6 with SMTP id 6so766600bwz.11
	for <video4linux-list@redhat.com>; Tue, 03 Nov 2009 14:13:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911032250060.5059@axis700.grange>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
	<Pine.LNX.4.64.0911032250060.5059@axis700.grange>
Date: Tue, 3 Nov 2009 15:13:52 -0700
Message-ID: <3d7d5c150911031413i2a3c23a1j8cb136b721b75da1@mail.gmail.com>
From: Neil Johnson <realdealneil@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: Re: Capturing video and still images using one driver
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

On Tue, Nov 3, 2009 at 3:02 PM, Guennadi Liakhovetski <g.liakhovetski@gmx.de
> wrote:

> On Mon, 2 Nov 2009, Neil Johnson wrote:
>
> > video4linux-list,
> >
> > I am developing on the OMAP3 system using a micron/aptina mt9p031
> > 5-megapixel imager.  This CMOs imager supports full image capture at 5
> fps
> > (2592x1944 pixels) or you can capture subregions using skipping and
> > binning.  We have proven both capabilities, but would like to be able to
> > capture both VGA sized video and still images without using separate
> > drivers.
> >
> > So far, I have not found any support for capturing large images and video
> > through a single driver interface.  Does such a capability exist within
> > v4l2?  One possible way to solve the problem is to allocate N buffers of
> the
> > full 5-megapixel size (they end up being 10-MB for each buffer since I'm
> > using 16-bits per pixel), and then using a small portion of that for
> video.
> > These is less desirable since when I'm capturing video, I only need
> 640x480
> > size buffers, and I should only need one snapshot buffer at a time (I'm
> not
> > streaming them in, just take a snapshot and go back to live video
> capture).
> > Is there a way to allocate a side-buffer for the 5-megapixel image and
> also
> > allocate "normal" sized buffers for video within the same driver?  Any
> > recommendations on how to accomplish such a thing?  I would think that
> > camera-phones using linux would have run up against this.  Thanks,
>
> I came across the same problem when working on the rj54n1cb0c driver.
> What's even more exciting with that sensor, is that it has separate
> frame-size settings for preview (video) and still capture.


I'm running into this as well.  The MT9P013 has different capture sizes for
video preview (can be 720x480, 1280x720, etc), but the full image capture is
2592x1944.  The biggest problem is that the hardware I'm using (OMAP3530)
has an image signal processing (isp) chain that needs to be properly
configured for the input size and output size.  Right now, the isp gets
initialized when the driver is opened, and then doesn't get touched until
it's closed.  However, the isp needs to be reconfigured if the frame size
changes.  This is getting to be a painful experience.



> So far the
> driver doesn't have any support for those still image frame settings, but
> I was thinking about implenting it using the read V4L method. I.e., you
> would use the mmap method just normally to capture video and use read to
> get still images?

I've considered this, and maybe that's the right way to do it.  The buffer
size for the read would have to be different than the mmap buffers...but
maybe that's doable.  Does "read" use videobuf in most circumstances?  Is it
possible to allocate multiple video buffer queues from a single driver?


> OTOH, with my driver I would need to differentiate
> between S_FMT for video and still. Would we have to use different inputs
> for them?
>
Not sure...maybe that's the way to do it... right now my only option is to
close the device, reopen it with different settings everytime I switch from
video to still image.

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


Thanks for the feedback.  Hopefully this will be a good learning experience
:)


-- 
Neil Johnson
Systems Engineer
Procerus Technologies
http://www.procerus.com
801-437-0805 (work)
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
