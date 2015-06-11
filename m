Return-path: <linux-media-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:39702 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbFKXXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 19:23:30 -0400
Message-ID: <1434064996.11808.64.camel@misato.fc.hp.com>
Subject: Re: RIP MTRR - status update for upcoming v4.2
From: Toshi Kani <toshi.kani@hp.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Borislav Petkov <bp@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
	<ville.syrjala@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Airlie <airlied@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	xen-devel@lists.xenproject.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 11 Jun 2015 17:23:16 -0600
In-Reply-To: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2015-06-11 at 13:36 -0700, Luis R. Rodriguez wrote:
 :
> Pending RIP MTRR patches
> ====================
> 
> There are a few pending series so I wanted to provide a status update
> on those series.
> 
> mtrr: bury MTRR - unexport mtrr_add() and mtrr_del()
> 
> This is the nail on the MTRR coffin, it will prevent future direct
> access to MTRR code. This will not be posted until all of the below
> patches are in and merged. A possible next step here might be to
> consider separating PAT code from MTRR code and making PAT a first
> class citizen, enabling distributions to disable MTRR code in the
> future. I thought this was possible but for some reason I recently
> thought that there was one possible issue to make this happen. I
> suppose we won't know unless we try, unless of course someone already
> knows, Toshi?

There are two usages on MTRRs:
 1) MTRR entries set by firmware
 2) MTRR entries set by OS drivers

We can obsolete 2), but we have no control over 1).  As UEFI firmwares
also set this up, this usage will continue to stay.  So, we should not
get rid of the MTRR code that looks up the MTRR entries, while we have
no need to modify them.

Such MTRR entries provide safe guard to /dev/mem, which allows
privileged user to access a range that may require UC mapping while
the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to UC in
such a case.

UEFI memory table has memory attribute, which describes cache types
supported in physical memory ranges.  However, this information gets
lost when it it is converted to e820 table.

Thanks,
-Toshi

