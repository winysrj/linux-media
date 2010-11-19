Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.128.24]:30826 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0KSPFT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 10:05:19 -0500
Date: Fri, 19 Nov 2010 17:06:21 +0200
From: David Cohen <david.cohen@nokia.com>
To: ext Lane Brooks <lane@brooks.nu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Translation faults with OMAP ISP
Message-ID: <20101119150620.GB11586@esdhcp04381.research.nokia.com>
References: <4CE16AA2.3000208@brooks.nu>
 <20101119132927.GD13490@esdhcp04381.research.nokia.com>
 <4CE684E6.6010403@brooks.nu>
 <201011191513.59622.laurent.pinchart@ideasonboard.com>
 <4CE686C9.6070902@brooks.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE686C9.6070902@brooks.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Nov 19, 2010 at 03:16:41PM +0100, ext Lane Brooks wrote:
> On 11/19/2010 07:13 AM, Laurent Pinchart wrote:
> > On Friday 19 November 2010 15:08:38 Lane Brooks wrote:
> >> On 11/19/2010 06:29 AM, David Cohen wrote:
> >>> On Thu, Nov 18, 2010 at 12:17:21AM +0100, ext Lane Brooks wrote:
> >>>> On Wednesday 17 November 2010 00:46:27 Lane Brooks wrote:
> >>>>>> Laurent,
> >>>>>>
> >>>>>> I am getting iommu translation errors when I try to use the CCDC
> >>>>>> output after using the Resizer output.
> >>>>>>
> >>>>>> If I use the CCDC output to stream some video, then close it down,
> >>>>>> switch to the Resizer output and open it up and try to stream, I get
> >>>>>> the following errors spewing out:
> >>>>>>
> >>>>>> omap-iommu omap-iommu.0: omap2_iommu_fault_isr: da:00d0ef00
> >>>>>> translation fault
> >>>>>> omap-iommu omap-iommu.0: iommu_fault_handler: da:00d0ef00 pgd:ce664034
> >>>>>> *pgd:00000000
> >>>>>>
> >>>>>> and the select times out.
> >>>>>>
> >>>>>>     From a fresh boot, I can stream just fine from the Resizer and then
> >>>>>>
> >>>>>> switch to the CCDC output just fine. It is only when I go from the
> >>>>>> CCDC to the Resizer that I get this problem. Furthermore, when it
> >>>>>> gets into this state, then anything dev node I try to use has the
> >>>>>> translation errors and the only way to recover is to reboot.
> >>>>>>
> >>>>>> Any ideas on the problem?
> >>> I'm not sure if it's your case, but OMAP3 ISP driver does not support
> >>> pipeline with multiples outputs yet. We have to return error from the
> >>> driver in this case. If you configured CCDC to write to memory and then
> >>> to write to preview/resizer afterwards without deactivating the link to
> >>> write to memory, you may face a similar problem you described.
> >>>
> >>> Can you please try a patch I've sent to you (CC'ing linux-media) with
> >>> subject: "[omap3isp][PATCH] omap3isp: does not allow pipeline with
> >>> multiple video outputs yet"?
> >>>
> >>> Regards,
> >>>
> >>> David
> >> David,
> >>
> >> I am not trying to use multiple outputs simultaneously. I get the
> >> translation error with the following sequence:
> >>
> >> - Open resizer output and setup media links.
> >> - Stream some images.
> >> - Close resizer.
> >> - Reset all media links.
> >> - Open CCDC and setup media links.
> >> - Try to stream some images but get translation faults.

You're describing some different steps from your previous e-mail, as
here the iommu faults come while CCDC outputting to memory and in your
comment above it was happening while Resizer outputting to memory.

Which one should I consider as the correct? :)

It would be nice if you could print the values of CCDC_SDR_ADDR and
RSZ_SDR_OUTADD just before the bug.

Are you also enabling CCDC's LSC?

> >>
> >> Is your patch going to help with this problem?
> > If you reset all links before setting them up for the CCDC output, probably
> > not (unless you have a bug in your CCDC links setup, but I doubt that).

As Laurent said, probably not. But if you want to go ahead to test this
patch, that's fine. It's very unlikely we have a bug on CCDC or Resizer
link setup, but not completely impossible. :)
A new version of this patch fixing the typo I mentioned there is going to be
locally applied anyway.

> I can stream just fine from the CCDC output if I do not use the resizer 
> prior, so I am pretty sure I am setting up the CCDC links correctly.

Well, iommu faults mean bug on kernel side. If you're still doing
something wrong, the driver must be able to return and error to
userland.

Regards,

David

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
