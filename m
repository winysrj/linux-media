Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZBRUM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 15:12:58 -0500
Date: Wed, 18 Feb 2009 20:07:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Agustin <gatoguan-os@yahoo.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH/RFC 1/4] ipu_idmac: code clean-up and robustness improvements
Message-ID: <20090218200739.GC11757@n2100.arm.linux.org.uk>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch> <alpine.DEB.2.00.0902180044120.6986@axis700.grange> <alpine.DEB.2.00.0902180049580.6986@axis700.grange> <951330.963.qm@web32108.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <951330.963.qm@web32108.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 07:09:55AM -0800, Agustin wrote:
> Guennadi,
> > Guennadi Liakhovetski wrote:
> > diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> > index 1f154d0..91e6e4e 100644
> > --- a/drivers/dma/ipu/ipu_idmac.c
> > +++ b/drivers/dma/ipu/ipu_idmac.c
> > @@ -28,6 +28,9 @@
> > #define FS_VF_IN_VALID    0x00000002
> > #define FS_ENC_IN_VALID    0x00000001
> > 
> > +static int ipu_disable_channel(struct idmac *idmac, struct idmac_channel 
> > *ichan,
> > +                   bool wait_for_stop);
> > +
> > /*
> > ...
>...
> $ patch -p1 --dry-run < p1
> patching file drivers/dma/ipu/ipu_idmac.c
> patch: **** malformed patch at line 29: /*
> 
> Looks like your patches lost their format while on their way,
> specially every single line with a starting space has had it
> removed. Or is it my e-mail reader? I am trying to fix it manually,
> no luck.

I think it's your mail reader - the version I have here is fine.
What you could do is look up the message in the mailing list archive
on lists.arm.linux.org.uk, and use the '(text/plain)' link to download
an unmangled copy of it.
