Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41920
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752634AbcKIRqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 12:46:14 -0500
Date: Wed, 9 Nov 2016 15:46:08 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20161109154608.1e578f9e@vento.lan>
In-Reply-To: <938ce288-d3d0-59f3-7714-c51fe1939af9@osg.samsung.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
        <6101f959-f8a9-eaca-b015-91161c04cb87@osg.samsung.com>
        <20161108081947.GL3217@valkosipuli.retiisi.org.uk>
        <0a4edeb4-d92d-2928-5667-da26213f39d7@osg.samsung.com>
        <938ce288-d3d0-59f3-7714-c51fe1939af9@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 10:00:58 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> > Maybe we can get the Media Device Allocator API work in and then we can
> > get your RFC series in after that. Here is what I propose:
> > 
> > - Keep the fixes in 4.9

Fixes should always be kept. Reverting a fix is not an option.
Instead, do incremental patches on the top of it.

> > - Get Media Device Allocator API patches into 4.9.  
> 
> I meant 4.10 not 4.9
> 
> > - snd-usb-auido work go into 4.10

Sounds like a plan.

> > Then your RFC series could go in. I am looking at the RFC series and that
> > the drivers need to change as well, so this RFC work could take longer.
> > Since we have to make media_device sharable, it is necessary to have a
> > global list approach Media Device Allocator API takes. So it is possible
> > for your RFC series to go on top of the Media Device Allocator API.

Firstly, the RFC series should be converted into something that can
be applicable upstream, e. g.:

- doing the changes over the top of upstream, instead of needing to
  revert patches;

- change all drivers as the kAPI changes;

- be git bisectable, e. g. all patches should compile and run fine
  after each single patch, without introducing regressions.

That probably means that the series should be tested not only on
omap3, but also on some other device drivers.


-- 
Thanks,
Mauro
