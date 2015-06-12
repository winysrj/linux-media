Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbbFLAw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 20:52:26 -0400
Date: Fri, 12 Jun 2015 02:52:21 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Borislav Petkov <bp@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?=
	<ville.syrjala@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Airlie <airlied@redhat.com>,
	xen-devel@lists.xenproject.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: RIP MTRR - status update for upcoming v4.2
Message-ID: <20150612005221.GD23057@wotan.suse.de>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434064996.11808.64.camel@misato.fc.hp.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 11, 2015 at 05:23:16PM -0600, Toshi Kani wrote:
> On Thu, 2015-06-11 at 13:36 -0700, Luis R. Rodriguez wrote:
>  :
> > Pending RIP MTRR patches
> > ====================
> > 
> > There are a few pending series so I wanted to provide a status update
> > on those series.
> > 
> > mtrr: bury MTRR - unexport mtrr_add() and mtrr_del()
> > 
> > This is the nail on the MTRR coffin, it will prevent future direct
> > access to MTRR code. This will not be posted until all of the below
> > patches are in and merged. A possible next step here might be to
> > consider separating PAT code from MTRR code and making PAT a first
> > class citizen, enabling distributions to disable MTRR code in the
> > future. I thought this was possible but for some reason I recently
> > thought that there was one possible issue to make this happen. I
> > suppose we won't know unless we try, unless of course someone already
> > knows, Toshi?
> 
> There are two usages on MTRRs:
>  1) MTRR entries set by firmware
>  2) MTRR entries set by OS drivers
> 
> We can obsolete 2), but we have no control over 1).  As UEFI firmwares
> also set this up, this usage will continue to stay.  So, we should not
> get rid of the MTRR code that looks up the MTRR entries, while we have
> no need to modify them.
> 
> Such MTRR entries provide safe guard to /dev/mem, which allows
> privileged user to access a range that may require UC mapping while
> the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to UC in
> such a case.
> 
> UEFI memory table has memory attribute, which describes cache types
> supported in physical memory ranges.  However, this information gets
> lost when it it is converted to e820 table.

Is there no way to modify CPU capability bits upon boot and kick UEFI
to re-evaluate ? In such UEFI cases what happens for instance when
Xen is used which does not support MTRR?

  Luis
