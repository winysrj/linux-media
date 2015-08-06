Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36405 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbHFT4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 15:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
References: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
 <1434064996.11808.64.camel@misato.fc.hp.com> <557AAD910200007800084014@mail.emea.novell.com>
 <1434128306.11808.97.camel@misato.fc.hp.com> <CAB=NE6W3=SFTqabeD6gq7JCqFZ7+SBZh7Xa=RteO_8-3P7fbdw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Aug 2015 12:55:48 -0700
Message-ID: <CAB=NE6WvaY4p7O3=0MMjWO44AytNYFr6xRsvVmVWDns9qdYZ8Q@mail.gmail.com>
Subject: Re: [Xen-devel] RIP MTRR - status update for upcoming v4.2
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jan Beulich <JBeulich@suse.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	X86 ML <x86@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	xen-devel@lists.xenproject.org, Dave Airlie <airlied@redhat.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Juergen Gross <JGross@suse.com>, Borislav Petkov <bp@suse.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 6, 2015 at 12:53 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> For those type of OSes...
> could it be possible to negotiate or hint to the platform through an
> attribute somehow that the OS has such capability to not use MTRR?

And if that's not possible how about a new platform setting that would
need to be set at the platform level to enable disabling this junk?
Then only folks who know what they are doing would enable it, and if
the customer set it, the issue would not be on the platform.

 Luis
