Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750783AbeCHXfr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 18:35:47 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180306085530.7b51aa29@vento.lan>
References: <20180306085530.7b51aa29@vento.lan> <151559583569.13545.12649741692530472663.stgit@warthog.procyon.org.uk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: Save port number and provide sysfs attributes to pass values to udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <536.1520552145.1@warthog.procyon.org.uk>
Date: Thu, 08 Mar 2018 23:35:45 +0000
Message-ID: <537.1520552145@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@kernel.org> wrote:

> > +	dvb_class->dev_groups = dvb_class_groups,
> >  	dvb_class->dev_uevent = dvb_uevent;
> >  	dvb_class->devnode = dvb_devnode;
> >  	return 0;
> 
> The patch itself looks good, but I'm not seeing any documentation.

I should probably add something to Documentation/media/dvb-drivers/udev.rst

> You should likely add something to Documentation/ABI

Any suggestions as to where to add stuff in there?  The README there leaves
a lot to be desired as to how to name elements - for instance, DVB devices can
be seen through /sys/class/ and /sys/devices/.

I could put it in sys-class-dvb or sys-devices-dvb - or, arguably, both.

> and to the DVB uAPI (Documentation/media/uapi/dvb).

Likewise, any suggestion as to where in here?  As far as I can tell, the docs
here don't currently mention sysfs at all.  I'm guessing I'll need to create a
file specifically to talk about how to use this stuff with udev.

> > +	port->frontends.adapter.port_num = port->nr;
> > +
> 
> Doing it for each multi-adapter device is something that bothers
> me. The better would be if we could move this to the DVB Kernel,
> in order to not need to check/fix every driver.

I'm not sure how achievable that is: *port in this case is a private
cx23885-specific structure object.

> If, otherwise, this is not possible, then we need a patch fixing port_num
> for all drivers that support multiple adapters.
> 
> Also, the risk of forgetting it seems high. So, perhaps we should
> add a new parameter to some function (like at dvb_register_device
> or at dvb_register_frontend), in order to make the port number
> a mandatory attribute.

Hmmm...  The cx23885 driver doesn't call either of these functions as far as I
can tell - at least, not directly.  Maybe by vb2_dvb_register_bus()?

Note that these attribute files appear for the demux, dvr and net directories
as well as for the frontend.

Hmmm... further, the port number is no longer getting through and all adapters
are showing port 0.  The MAC address works, though.  Maybe I should drop the
port number.

David
