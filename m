Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38178
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758784AbcLORId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:08:33 -0500
Date: Thu, 15 Dec 2016 15:08:26 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20161215150826.0ca646a3@vento.lan>
In-Reply-To: <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
References: <20161109154608.1e578f9e@vento.lan>
        <20161213102447.60990b1c@vento.lan>
        <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
        <7529355.zfqFdROYdM@avalon>
        <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
        <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
        <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Dec 2016 16:26:19 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > Should all the entities stick around until all references to media
> > device are gone? If an application has /dev/media open, does that
> > mean all entities should not be free'd until this app. exits? What
> > should happen if an app. is streaming? Should the graph stay intact
> > until the app. exits?  
> 
> Yes, everything must stay around until the last user has disappeared.
> 
> In general unplugs can happen at any time. So applications can be in the middle
> of an ioctl, and removing memory during that time is just impossible.
> 
> On unplug you:
> 
> 1) stop any HW DMA (highly device dependent)
> 2) wake up any filehandles that wait for an event
> 3) unregister any device nodes
> 
> Then just sit back and wait for refcounts to go down as filehandles are closed
> by the application.
> 
> Note: the v4l2/media/cec/IR/whatever core is typically responsible for rejecting
> any ioctls/mmap/etc. once the device node has been unregistered. The only valid
> file operation is release().

Agreed. The problem on OMAP3 is that it doesn't stop HW DMA when
struct media_devnode is released. It tries to do it later, when the
V4L2 core is unbind, by trying to dig into the media controller
struct that the driver removed before.

That's said, for OMAP3 and all other drivers that don't support hot unplug,
I would just use suppress_bind_attrs, as I fail to see any need to allow
unbinding them.

Thanks,
Mauro
