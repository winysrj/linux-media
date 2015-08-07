Return-path: <linux-media-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:49138 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946357AbbHGXVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 19:21:18 -0400
Message-ID: <1438989565.3109.179.camel@hp.com>
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
Date: Fri, 07 Aug 2015 17:19:25 -0600
In-Reply-To: <1438988915.3109.175.camel@hp.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
	 <1434064996.11808.64.camel@misato.fc.hp.com>
	 <557AAD910200007800084014@mail.emea.novell.com>
	 <1434128306.11808.97.camel@misato.fc.hp.com>
	 <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
	 <1438901893.3109.72.camel@hp.com>
	 <CAB=NE6VnspTPfrn5+ZFSdgKb3uh_4g7LsuZVwe2FET=noijr5Q@mail.gmail.com>
	 <1438984574.3109.151.camel@hp.com>
	 <CAB=NE6V+dAq1u52c3tDhBOYWU1BNMBVL3KzDdM=C-zTkLEx4xA@mail.gmail.com>
	 <1438988915.3109.175.camel@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2015-08-07 at 17:08 -0600, Toshi Kani wrote:
> On Fri, 2015-08-07 at 15:23 -0700, Luis R. Rodriguez wrote:
> > On Fri, Aug 7, 2015 at 2:56 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > > On Fri, 2015-08-07 at 13:25 -0700, Luis R. Rodriguez wrote:
> > > > On Thu, Aug 6, 2015 at 3:58 PM, Toshi Kani <toshi.kani@hp.com> 
> > > > wrote:
> > > > > On Thu, 2015-08-06 at 12:53 -0700, Luis R. Rodriguez wrote:
> > > > > > On Fri, Jun 12, 2015 at 9:58 AM, Toshi Kani <toshi.kani@hp.com> 
> > > > > > wrote:
>  :
> > > > > 
> > > > > No, there is no OS support necessary to use MTRR.  After firmware 
> > > > > sets it up, CPUs continue to use it without any OS support.  I 
> > > > > think the Linux change you are referring is to obsolete legacy
> > > > > interfaces that modify the MTRR setup.  I agree that Linux should 
> > > > > not modify MTRR.
> > > > 
> > > > Its a bit more than that though. Since you agree that the OS can 
> > > > live without MTRR code I was hoping to then see if we can fold out 
> > > > PAT Linux code from under the MTRR dependency on Linux and make PAT 
> > > > a first class citizen, maybe at least for x86-64. Right now you can
> > > > only get PAT support on Linux if you have MTRR code, but I'd like to 
> > > > see if instead we can rip MTRR code out completely under its own 
> > > > Kconfig and let it start rotting away.
> > > > 
> > > > Code-wise the only issue I saw was that PAT code also relies on
> > > > mtrr_type_lookup(), see pat_x_mtrr_type(), but other than this I 
> > > > found no other obvious issues.
> > > 
> > > We can rip of the MTTR code that modifies the MTRR setup, but not
> > > mtrr_type_lookup().  This function provides necessary checks per 
> > > documented in commit 7f0431e3dc89 as follows.
> > > 
> > >     1) reserve_memtype() tracks an effective memory type in case
> > >        a request type is WB (ex. /dev/mem blindly uses WB). Missing
> > >        to track with its effective type causes a subsequent request
> > >        to map the same range with the effective type to fail.
> > > 
> > >     2) pud_set_huge() and pmd_set_huge() check if a requested range
> > >        has any overlap with MTRRs. Missing to detect an overlap may
> > >        cause a performance penalty or undefined behavior.
> > > 
> > > mtrr_type_lookup() is still admittedly awkward, but I do not think we 
> > > have an immediate issue in PAT code calling it.  I do not think it 
> > > makes 
> > > PAT code a second class citizen.
> > 
> > OK since we know that if MTRR set up code ends up disabled and would
> > return MTRR_TYPE_INVALID what if we just static inline this for the
> > no-MTRR Kconfig build option immediately, and only then have the full
> > blown implementation for the case where MTRR Kconfig option is
> > enabled?
> 
> Yes, the MTRR code could be disabled by Kconfig with such inline stubs as
> long as the kernel is built specifically for a particular platform with 
> MTRR disabled, such as Xen guest kernel.

Noticed that we do have CONFIG_MTRR and mtrr_type_lookup() inline stub
returns MTRR_INVALID.

-Toshi

