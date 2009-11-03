Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA3M2JTs020003
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 17:02:19 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nA3M23Cj017637
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 17:02:04 -0500
Date: Tue, 3 Nov 2009 23:02:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Neil Johnson <realdealneil@gmail.com>
In-Reply-To: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0911032250060.5059@axis700.grange>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 2 Nov 2009, Neil Johnson wrote:

> video4linux-list,
> 
> I am developing on the OMAP3 system using a micron/aptina mt9p031
> 5-megapixel imager.  This CMOs imager supports full image capture at 5 fps
> (2592x1944 pixels) or you can capture subregions using skipping and
> binning.  We have proven both capabilities, but would like to be able to
> capture both VGA sized video and still images without using separate
> drivers.
> 
> So far, I have not found any support for capturing large images and video
> through a single driver interface.  Does such a capability exist within
> v4l2?  One possible way to solve the problem is to allocate N buffers of the
> full 5-megapixel size (they end up being 10-MB for each buffer since I'm
> using 16-bits per pixel), and then using a small portion of that for video.
> These is less desirable since when I'm capturing video, I only need 640x480
> size buffers, and I should only need one snapshot buffer at a time (I'm not
> streaming them in, just take a snapshot and go back to live video capture).
> Is there a way to allocate a side-buffer for the 5-megapixel image and also
> allocate "normal" sized buffers for video within the same driver?  Any
> recommendations on how to accomplish such a thing?  I would think that
> camera-phones using linux would have run up against this.  Thanks,

I came across the same problem when working on the rj54n1cb0c driver. 
What's even more exciting with that sensor, is that it has separate 
frame-size settings for preview (video) and still capture. So far the 
driver doesn't have any support for those still image frame settings, but 
I was thinking about implenting it using the read V4L method. I.e., you 
would use the mmap method just normally to capture video and use read to 
get still images? OTOH, with my driver I would need to differentiate 
between S_FMT for video and still. Would we have to use different inputs 
for them?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
