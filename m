Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:22374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbAGLWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 06:22:33 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: 'Jacek Anaszewski' <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, kgene@kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, robh+dt@kernel.org, mark.rutland@arm.com,
	bhushan.r@samsung.com
References: <1418974680-5837-1-git-send-email-tony.kn@samsung.com>
 <1418974680-5837-3-git-send-email-tony.kn@samsung.com>
 <54AD068F.8030001@samsung.com>
In-reply-to: <54AD068F.8030001@samsung.com>
Subject: RE: [PATCH v2 2/2] [media] s5p-jpeg: Adding Exynos7 JPEG variant
Date: Wed, 07 Jan 2015 16:52:51 +0530
Message-id: <000801d02a6c$59fdbc60$0df93520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On  Wednesday, January 07, 2015 3:43 PM : Jacek Anaszewski wrote,

> Hi Tony,
> 
> On 12/19/2014 08:38 AM, Tony K Nadackal wrote:
> > Fimp_jpeg used in Exynos7 is a revised version. Some register
> > configurations are slightly different from JPEG in Exynos4.
> > Added one more variant SJPEG_EXYNOS7 to handle these differences.
> >
> > Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> > ---
> >   .../bindings/media/exynos-jpeg-codec.txt           |  2 +-
> >   drivers/media/platform/s5p-jpeg/jpeg-core.c        | 61
++++++++++++++++++-
> ---
> >   drivers/media/platform/s5p-jpeg/jpeg-core.h        | 10 ++--
> >   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  | 32 ++++++------
> >   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h  |  8 +--
> >   drivers/media/platform/s5p-jpeg/jpeg-regs.h        | 17 ++++--
> >   6 files changed, 93 insertions(+), 37 deletions(-)
> >
> > diff --git
> > a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> > b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> > index bf52ed4..cd19417 100644
> > --- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> > +++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> > @@ -4,7 +4,7 @@ Required properties:
> >
> >   - compatible	: should be one of:
> >   		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
> > -		  "samsung,exynos3250-jpeg";
> > +		  "samsung,exynos3250-jpeg", "samsung,exynos7-jpeg";
> >   - reg		: address and length of the JPEG codec IP register set;
> >   - interrupts	: specifies the JPEG codec IP interrupt;
> >   - clock-names   : should contain:
> 
> This should be put in a separate patch.

Checkpatch gives warning if this change is not there.
If that is ok with you, I will make this change a separate patch. 

[snip]

> --
> Best Regards,
> Jacek Anaszewski

Thanks and Regards,
Tony

