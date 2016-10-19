Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46406
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942951AbcJSOne (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:43:34 -0400
Date: Wed, 19 Oct 2016 07:56:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Antti Palosaari <crope@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Nick Dyer <nick@shmanahar.org>, Shuah Khan <shuah@kernel.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH v2 50/58] v4l2-core: don't break long lines
Message-ID: <20161019075652.36f59b7b@vento.lan>
In-Reply-To: <20161019070916.GQ9460@valkosipuli.retiisi.org.uk>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <9ff01ca23d33ed0bdbd4b72a2135029d77afd21b.1476822925.git.mchehab@s-opensource.com>
        <20161019070916.GQ9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 10:09:16 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Oct 18, 2016 at 06:46:02PM -0200, Mauro Carvalho Chehab wrote:
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index c52d94c018bb..26fe7aef1196 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -174,8 +174,7 @@ static void v4l_print_querycap(const void *arg, bool write_only)
> >  {
> >  	const struct v4l2_capability *p = arg;
> >  
> > -	pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, "
> > -		"capabilities=0x%08x, device_caps=0x%08x\n",
> > +	pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, capabilities=0x%08x, device_caps=0x%08x\n",
> >  		(int)sizeof(p->driver), p->driver,
> >  		(int)sizeof(p->card), p->card,
> >  		(int)sizeof(p->bus_info), p->bus_info,  
> 
> I still wouldn't do this to v4l2-ioctl.c. It does not improve grappability
> because of the format strings. 

The main reason that made me do this patch series is to identify the lack
of KERN_CONT at the media subsystem.

The grep I'm using to identify missing KERN_CONT lines actually tests
for a string line that doesn't end with "\n", like:

	$ git grep '("' drivers/media/|grep -v KERN_|grep -v '\\n'|grep -v MODULE

That's said, the format strings don't hurt grep:

	$ git grep -E "driver=.*bus=.*device_caps="
	drivers/media/v4l2-core/v4l2-ioctl.c:   pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, capabilities=0x%08x, device_caps=0x%08x\n",

> Some are also really long such as the one a
> few chunks below.

Yeah, but it gives a bad coding style example. I prefer to have the core
subsystem as close as possible of the coding style I would like to see
at the drivers code I review. Btw, at least on my 1920x1050 monitor,
if I open a console full screen, only one line of v4l2-ioctl.c is bigger
than the terminal column size.

> Other than that, this looks very nice now. Your script makes me wonder,
> though, whether there should be a tool to automatically improve coding style
> for cases such as this. I didn't realise so many strings were actually
> split. I'm sure also the rest of the kernel would benefit from such a tool.
> With the increased number of lines of code, the special cases that need to
> be handled manually must decrease as well or it becomes unfeasible.

Yeah, I was also thinking that there would be a way less places than
what it was hit by this script.

The script on this patch is generic enough to be used to fix such cases
on other subsystems, although it needs some polish to cover a few corner
cases. I suspect it shouldn't be hard to integrate it to checkpatch.pl
to be used with --fix.

Thanks,
Mauro
