Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37700 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932462AbcKOWJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 17:09:05 -0500
Date: Wed, 16 Nov 2016 00:08:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] doc-rst: Specify raw bayer format variant used in
 the examples
Message-ID: <20161115220827.GB12971@valkosipuli.retiisi.org.uk>
References: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
 <2115656.8onqqhVbSa@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2115656.8onqqhVbSa@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Nov 15, 2016 at 11:55:27PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 15 Nov 2016 23:49:43 Sakari Ailus wrote:
> > The documentation simply mentioned that one of the four pixel orders was
> > used in the example. Now specify the exact pixelformat instead.
> > 
> > for i in pixfmt-s*.rst; do i=$i perl -i -pe '
> > 	my $foo=$ENV{i};
> > 	$foo =~ s/pixfmt-[a-z]+([0-9].*).rst/$1/;
> > 	$foo = uc $foo;
> > 	s/one of these formats/a small V4L2_PIX_FMT_SBGGR$foo image/' $i;
> > done
> 
> Do we really need this in the commit message ? :-)

Feel free to remove it if you like. I put it there to avoid forgetting it as
I'll still need to convert other patches. Perhaps it might be better placed
elsewhere. :-)

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> As the patch applies on top of another one I took in my tree for the uvcvideo 
> driver I've applied this one there as well.

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
