Return-path: <linux-media-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:45049 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbHFXAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 19:00:06 -0400
Message-ID: <1438901893.3109.72.camel@hp.com>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
From: Toshi Kani <toshi.kani@hp.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Jan Beulich <JBeulich@suse.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	X86 ML <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ville =?ISO-8859-1?Q?Syrj=E4l=E4?=
	<ville.syrjala@linux.intel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	xen-devel@lists.xenproject.org, Dave Airlie <airlied@redhat.com>,
	Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Juergen Gross <JGross@suse.com>, Borislav Petkov <bp@suse.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Thu, 06 Aug 2015 16:58:13 -0600
In-Reply-To: <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
	 <1434064996.11808.64.camel@misato.fc.hp.com>
	 <557AAD910200007800084014@mail.emea.novell.com>
	 <1434128306.11808.97.camel@misato.fc.hp.com>
	 <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2015-08-06 at 12:53 -0700, Luis R. Rodriguez wrote:
> On Fri, Jun 12, 2015 at 9:58 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Fri, 2015-06-12 at 08:59 +0100, Jan Beulich wrote:
> > > > > > On 12.06.15 at 01:23, <toshi.kani@hp.com> wrote:
> > > > There are two usages on MTRRs:
> > > >  1) MTRR entries set by firmware
> > > >  2) MTRR entries set by OS drivers
> > > > 
> > > > We can obsolete 2), but we have no control over 1).  As UEFI 
> > > > firmwares
> > > > also set this up, this usage will continue to stay.  So, we should 
> > > > not
> > > > get rid of the MTRR code that looks up the MTRR entries, while we 
> > > > have
> > > > no need to modify them.
> > > > 
> > > > Such MTRR entries provide safe guard to /dev/mem, which allows
> > > > privileged user to access a range that may require UC mapping while
> > > > the /dev/mem driver blindly maps it with WB.  MTRRs converts WB to 
> > > > UC in
> > > > such a case.
> > > 
> > > But it wouldn't be impossible to simply read the MTRRs upon boot,
> > > store the information, disable MTRRs, and correctly use PAT to
> > > achieve the same effect (i.e. the "blindly maps" part of course
> > > would need fixing).
> > 
> > It could be done, but I do not see much benefit of doing it.  One of the
> > reasons platform vendors set MTRRs is so that a system won't hit a
> > machine check when an OS bug leads an access with a wrong cache type.
> > 
> > A machine check is hard to analyze and can be seen as a hardware issue 
> > by customers.  Emulating MTRRs with PAT won't protect from such a bug.
> 
> That's seems like a fair and valid concern. This could only happen if
> the OS would have code that would use MTRR, in the case of Linux we'll
> soon be able to vet that this cannot happen. 

No, there is no OS support necessary to use MTRR.  After firmware sets it
up, CPUs continue to use it without any OS support.  I think the Linux
change you are referring is to obsolete legacy interfaces that modify the
MTRR setup.  I agree that Linux should not modify MTRR. 

> For those type of OSes...
> could it be possible to negotiate or hint to the platform through an
> attribute somehow that the OS has such capability to not use MTRR?

The OS can disable MTRR.  However, this can also cause a problem in
firmware, which may rely on MTRR.

> Then, only if this bit is set, the platform could then avoid such MTRR
> settings, and if we have issues you can throw rocks at us.

> And if that's not possible how about a new platform setting that would
> need to be set at the platform level to enable disabling this junk?
> Then only folks who know what they are doing would enable it, and if
> the customer set it, the issue would not be on the platform.

> Could this also be used to prevent SMIs with MTRRs?

ACPI _OSI could be used for firmware to implement some OS-specific features,
but it may be too late for firmware to make major changes and is generally
useless unless OS requirements are described in a spec backed by logo
certification.  SMIs are also used for platform management, such as fan
speed control.

Is there any issue for Linux to use MTRR set by firmware?

Thanks,
-Toshi

