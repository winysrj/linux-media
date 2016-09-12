Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38206
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758817AbcILNYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 09:24:03 -0400
Date: Mon, 12 Sep 2016 15:23:56 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
cc: linux-renesas-soc@vger.kernel.org, joe@perches.com,
        kernel-janitors@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-media@vger.kernel.org, linux-can@vger.kernel.org,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Chien Tin Tung <chien.tin.tung@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/26] constify local structures
In-Reply-To: <20160912131625.GD957@intel.com>
Message-ID: <alpine.DEB.2.10.1609121523330.29099@hadrien>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr> <20160911172105.GB5493@intel.com> <alpine.DEB.2.10.1609121051050.3049@hadrien> <20160912131625.GD957@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 12 Sep 2016, Jarkko Sakkinen wrote:

> On Mon, Sep 12, 2016 at 10:54:07AM +0200, Julia Lawall wrote:
> >
> >
> > On Sun, 11 Sep 2016, Jarkko Sakkinen wrote:
> >
> > > On Sun, Sep 11, 2016 at 03:05:42PM +0200, Julia Lawall wrote:
> > > > Constify local structures.
> > > >
> > > > The semantic patch that makes this change is as follows:
> > > > (http://coccinelle.lip6.fr/)
> > >
> > > Just my two cents but:
> > >
> > > 1. You *can* use a static analysis too to find bugs or other issues.
> > > 2. However, you should manually do the commits and proper commit
> > >    messages to subsystems based on your findings. And I generally think
> > >    that if one contributes code one should also at least smoke test changes
> > >    somehow.
> > >
> > > I don't know if I'm alone with my opinion. I just think that one should
> > > also do the analysis part and not blindly create and submit patches.
> >
> > All of the patches are compile tested.  And the individual patches are
>
> Compile-testing is not testing. If you are not able to test a commit,
> you should explain why.
>
> > submitted to the relevant maintainers.  The individual commit messages
> > give a more detailed explanation of the strategy used to decide that the
> > structure was constifiable.  It seemed redundant to put that in the cover
> > letter, which will not be committed anyway.
>
> I don't mean to be harsh but I do not care about your thought process
> *that much* when I review a commit (sometimes it might make sense to
> explain that but it depends on the context).
>
> I mostly only care why a particular change makes sense for this
> particular subsystem. The report given by a static analysis tool can
> be a starting point for making a commit but it's not sufficient.
> Based on the report you should look subsystems as individuals.

OK, thanks for the feedback.

julia
