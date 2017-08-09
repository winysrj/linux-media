Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51764
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752406AbdHIP7i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 11:59:38 -0400
Date: Wed, 9 Aug 2017 12:59:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.14] Stream control documentation
Message-ID: <20170809125930.7e97bd47@vento.lan>
In-Reply-To: <20170809153507.q5wneyi4x3m7etfa@valkosipuli.retiisi.org.uk>
References: <20170809080340.4c5b4jjypqiqyllp@valkosipuli.retiisi.org.uk>
        <20170809122917.0461db2c@vento.lan>
        <20170809153507.q5wneyi4x3m7etfa@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Aug 2017 18:35:07 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Wed, Aug 09, 2017 at 12:29:17PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 9 Aug 2017 11:03:40 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > Add stream control documentation.
> > > 
> > > We have recently added support for hardware that makes it possible to have
> > > pipelines that are controlled by more than two drivers. This necessitates
> > > documenting V4L2 stream control behaviour for such pipelines.  
> > 
> > Perhaps I missed this one, but I'm not seeing any e-mail with
> > 	"docs-rst: media: Document s_stream() video op usage"
> > 
> > Please always submit patches via e-mail too, as it makes easier for
> > us to comment/review when needed.
> > 
> > In any case, I'm appending the patch contents here. I'll reply to it
> > on a next e-mail.  
> 
> The subject of the patch was changed based on the review comments. The
> patch used to be called "docs-rst: media: Document s_stream() core op
> usage".

On such cases, please send a version 2. The primary key to look for a patch
is the patch name :-)
> 
> The changes were rather trivial (core -> video) so I didn't send an update
> to the original one.
> 
> The patch is available here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg117737.html>

As I posted it at the reply, I replied with my comments to the one I
posted, with matches the version on your pull request.

Thanks,
Mauro
