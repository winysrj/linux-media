Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:52679 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbaFYIA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 04:00:58 -0400
Date: Wed, 25 Jun 2014 10:00:39 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Alexander Sosna <alexander@xxor.de>
Subject: Re: [RFC 2/2] gspca_kinect: add support for the depth stream
Message-Id: <20140625100039.24fb87f1967dc226d7d84abc@ao2.it>
In-Reply-To: <53A2F525.2070504@redhat.com>
References: <53450D76.2010405@redhat.com>
	<1401913499-6475-1-git-send-email-ao2@ao2.it>
	<1401913499-6475-3-git-send-email-ao2@ao2.it>
	<53A2F525.2070504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Jun 2014 16:35:17 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 06/04/2014 10:24 PM, Antonio Ospite wrote:
> > Add support for the depth mode at 10bpp, use a command line parameter to
> > switch mode.
> > 
> > NOTE: this is just a proof-of-concept, the final implementation will
> > have to expose two v4l2 devices, one for the video stream and one for
> > the depth stream.
> 
> Thanks for the patch. If this is useful for some people I'm willing to
> merge this until we've a better fix.
>

I guess adding a command line parameter (depth_mode) and then removing
it in the future, when a far better alternative is available, is
acceptable in this case; we also did something like that before for the
PS3 Eye driver for instance.

So I am going to submit this patch set for inclusion.

> > Signed-off-by: Alexander Sosna <alexander@xxor.de>
> > Signed-off-by: Antonio Ospite <ao2@ao2.it>
> > ---
> > 
> > For now a command line parameter called "depth_mode" is used to select which
> > mode to activate when loading the driver, this is necessary because gspca is
> > not quite ready to have a subdriver call gspca_dev_probe() multiple times.
> > 
> > The problem seems to be that gspca assumes one video device per USB
> > _interface_, and so it stores a pointer to gspca_dev as the interface
> > private data: see usb_set_intfdata(intf, gspca_dev) in
> > gspca_dev_probe2().
> > 
> > If anyone feels brave (do a backup first, etc. etc.), hack the sd_probe()
> > below to register both the devices: you will get the two v4l nodes and both
> > streams will work OK, but the kernel will halt when you disconnect the device,
> > i.e. some problem arises in gspca_disconnect() after the usb_get_intfdata(intf)
> > call.
> > 
> > I am still figuring out the details of the failure sequence, and I'll try to
> > imagine a way to support the use case "multiple v4l devices on one USB
> > interface", but this will take some more time.
> 
> I believe that support 2 devices would require separating the per video node /
> stream data and global data into separate structs, and then refactoring everything
> so that we can have 2 streams on one gspca_dev. If you do this please make it
> a patch-set with many small patches, rather then 1 or 2 very large patches.
>
> And then in things like disconnect, loop over the streams and stop both, unregister
> both nodes, etc.
> 
> If you ever decide to add support for controls you will also need to think about what
> to do with those, but for now I guess you can just register all the controls on the
> first video-node/stream (which will be the only one for all devices except kinect
> devices, and the kinect code currently does not have controls.
>

Very useful hints, as always.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
