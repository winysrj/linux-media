Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38280
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756743AbcLORZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:25:08 -0500
Date: Thu, 15 Dec 2016 15:25:01 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20161215152501.11ce2b2a@vento.lan>
In-Reply-To: <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan>
        <20161213102447.60990b1c@vento.lan>
        <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
        <7529355.zfqFdROYdM@avalon>
        <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
        <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
        <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
        <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
        <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
        <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Dec 2016 10:09:53 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 12/15/2016 09:28 AM, Hans Verkuil wrote:
> > On 15/12/16 17:06, Shuah Khan wrote:  

> > 
> > I think this will work for interface entities, but for subdev entities this
> > certainly won't work. Unbinding subdevs should be blocked (just set
> > suppress_bind_attrs to true in all subdev drivers). Most top-level drivers
> > have pointers to subdev data, so unbinding them will just fail horribly.
> >   
> 
> Yes that is an option. I did something similar for au0828 and snd_usb_audio
> case, so the module that registers the media_device can't unbound until the
> other driver. If au0828 registers media_device, it becomes the owner and if
> it gets unbound ioctls will start to see problems.
> 
> What this means though is that drivers can't be unbound easily. But that is
> a small price to pay compared to the problems we will see if a driver is
> unbound when its entities are still in use. Also, unsetting bind_attrs has
> to be done as well, otherwise we can never unbind any driver.

I don't think suppress_bind_attrs will work on USB drivers, as the
device can be physically removed. 

Thanks,
Mauro
