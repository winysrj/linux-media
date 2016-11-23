Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55794 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933854AbcKWQlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 11:41:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] doc-rst: Specify raw bayer format variant used in the examples
Date: Wed, 23 Nov 2016 18:41:18 +0200
Message-ID: <2161966.iOndM7fjgu@avalon>
In-Reply-To: <20161122162729.22e4721a@vento.lan>
References: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com> <20161122162729.22e4721a@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 22 Nov 2016 16:27:29 Mauro Carvalho Chehab wrote:
> Em Tue, 15 Nov 2016 23:49:43 +0200 Sakari Ailus escreveu:
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
> Patch is nice, except that it doesn't apply :-)
> 
> If it depends on some other patch, please send it together with
> its dependency or at least mention it at the patch, after the
> -- line.

It depends on "v4l: Add 16-bit raw bayer pixel formats". I have that one in my 
tree in an UVC branch and will send you a pull request that will include this 
patch very shortly.

-- 
Regards,

Laurent Pinchart

