Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeCIIJL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 03:09:11 -0500
Date: Fri, 9 Mar 2018 05:09:05 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: Save port number and provide sysfs attributes to
 pass values to udev
Message-ID: <20180309050905.3584cae3@vento.lan>
In-Reply-To: <537.1520552145@warthog.procyon.org.uk>
References: <20180306085530.7b51aa29@vento.lan>
        <151559583569.13545.12649741692530472663.stgit@warthog.procyon.org.uk>
        <537.1520552145@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 08 Mar 2018 23:35:45 +0000
David Howells <dhowells@redhat.com> escreveu:

> Mauro Carvalho Chehab <mchehab@kernel.org> wrote:
> 
> > > +	dvb_class->dev_groups = dvb_class_groups,
> > >  	dvb_class->dev_uevent = dvb_uevent;
> > >  	dvb_class->devnode = dvb_devnode;
> > >  	return 0;  
> > 
> > The patch itself looks good, but I'm not seeing any documentation.  
> 
> I should probably add something to Documentation/media/dvb-drivers/udev.rst

Makes sense.

> > You should likely add something to Documentation/ABI  
> 
> Any suggestions as to where to add stuff in there?  The README there leaves
> a lot to be desired as to how to name elements - for instance, DVB devices can
> be seen through /sys/class/ and /sys/devices/.
>
> I could put it in sys-class-dvb or sys-devices-dvb - or, arguably, both.

Good point. I don't have a strong opinion, but, as we're using /sys/class
for remote controller's elements[1], I would place DVB stuff there also.

[1] Documentation/ABI/testing/sysfs-class-rc


> > and to the DVB uAPI (Documentation/media/uapi/dvb).  
> 
> Likewise, any suggestion as to where in here?  As far as I can tell, the docs
> here don't currently mention sysfs at all.  I'm guessing I'll need to create a
> file specifically to talk about how to use this stuff with udev.

Yes. The docs don't mention simply because, right now, there's nothing
special on sysfs.

> > > +	port->frontends.adapter.port_num = port->nr;
> > > +  
> > 
> > Doing it for each multi-adapter device is something that bothers
> > me. The better would be if we could move this to the DVB Kernel,
> > in order to not need to check/fix every driver.  
> 
> I'm not sure how achievable that is: *port in this case is a private
> cx23885-specific structure object.

Yes, but other drivers that support multiple frontends store it
somewhere. Yet, maybe we could keep this out of the first version.

> > If, otherwise, this is not possible, then we need a patch fixing port_num
> > for all drivers that support multiple adapters.
> > 
> > Also, the risk of forgetting it seems high. So, perhaps we should
> > add a new parameter to some function (like at dvb_register_device
> > or at dvb_register_frontend), in order to make the port number
> > a mandatory attribute.  
> 
> Hmmm...  The cx23885 driver doesn't call either of these functions as far as I
> can tell - at least, not directly.  Maybe by vb2_dvb_register_bus()?

Yeah, some hybrid drivers typically use a helper module to handle dvb
registration, either at VB or VB2. As this has to be generic enough,
if we add, we'll likely need to place the port number at
dvb_register_device()/dvb_register_frontend() and then change
vb2_dvb_register_bus() accordingly.

Hmm... that's said, I guess we can get rid of the VB 1 version, as
I'm not seeing any driver calling videobuf_dvb_register_bus() anymore.

I'll double check and write a patch to get rid of it, if possible.

> 
> Note that these attribute files appear for the demux, dvr and net directories
> as well as for the frontend.
> 
> Hmmm... further, the port number is no longer getting through and all adapters
> are showing port 0.  

Weird.

> The MAC address works, though.  Maybe I should drop the
> port number.

Yeah, let's drop it for the first version. It can be added later if
needed.

Thanks,
Mauro
