Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35224
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbcIMK7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 06:59:53 -0400
Date: Tue, 13 Sep 2016 07:59:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 1/5] media: Determine early whether an IOCTL is
 supported
Message-ID: <20160913075948.70b60842@vento.lan>
In-Reply-To: <20160913105124.GF5086@valkosipuli.retiisi.org.uk>
References: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
        <1470947358-31168-2-git-send-email-sakari.ailus@linux.intel.com>
        <20160906065617.1295d104@vento.lan>
        <20160913105124.GF5086@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 13 Sep 2016 13:51:25 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Sep 06, 2016 at 06:56:17AM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 11 Aug 2016 23:29:14 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   

> > So, we don't expect to have the V4L2 compat32 mess here, but, instead,
> > to keep this untouched as we add more ioctl's.  
> 
> That's a fair point. If we won't require compat handling for more IOCTLs,
> we'll be fine with less generic compat handling.
> 
> I'll resend the set.

OK, thanks!

Regards,
Mauro
