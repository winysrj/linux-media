Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59648 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750964AbdISLZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:25:54 -0400
Date: Tue, 19 Sep 2017 14:25:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 01/25] v4l: fwnode: Move KernelDoc documentation to
 the header
Message-ID: <20170919112551.grmbc7sf6d4olyzn@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <9077921.hsjkiRftLf@avalon>
 <20170919111036.5va2unwqh2vymojr@valkosipuli.retiisi.org.uk>
 <20634394.E3nNBE0rok@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20634394.E3nNBE0rok@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 02:14:39PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 19 September 2017 14:10:37 EEST Sakari Ailus wrote:
> > On Tue, Sep 19, 2017 at 01:48:27PM +0300, Laurent Pinchart wrote:
> > > On Friday, 15 September 2017 17:17:00 EEST Sakari Ailus wrote:
> > >> In V4L2 the practice is to have the KernelDoc documentation in the
> > >> header and not in .c source code files. This consequently makes the V4L2
> > >> fwnode function documentation part of the Media documentation build.
> > >> 
> > >> Also correct the link related function and argument naming in
> > >> documentation.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >> Acked-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > I'm still very opposed to this. In addition to increasing the risk of
> > > documentation becoming stale, it also makes review more difficult. I'm
> > > reviewing patch 05/25 of this series and I have to jump around the patch
> > > to verify that the documentation matches the implementation, it's really
> > > annoying.
> > 
> > I'd like to have this discussion separately from the patchset, which is
> > right now in its 13th version. This patch simply makes the current state
> > consistent; V4L2 async was the only part of V4L2 with KernelDoc
> > documentation in .c files.
> 
> But there's no need to move the documentation at this point until we reach an 
> agreement, is there ?

The status quo has is that the KernelDoc is in headers. Generally, if you
change parts that appear to lack framework-wide changes already done, you
do those changes before making other changes since it's a no-brainer.

Which is what this patch represents.

If we end up moving the KernelDoc to .c files moving this back could result
into an extra patch. I'm not too worried about that frankly.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
