Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35649 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3FRIUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 04:20:07 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOK00J2JXNT7830@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 09:20:05 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	'Arun Kumar K' <arunkk.samsung@gmail.com>
Cc: 'Arun Kumar K' <arun.kk@samsung.com>,
	'LMML' <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
 <1370870586-24141-4-git-send-email-arun.kk@samsung.com>
 <002a01ce6b69$512943c0$f37bcb40$%debski@samsung.com>
 <CALt3h7-mNkOJoGbyNsBR0Z2mYKXD58EwqOezeY+7xpx7G0-vHQ@mail.gmail.com>
 <CAK9yfHy-dEx98YXLdJB0rW5yZ_HeKsy5aLSjH0XL07U=5HNgKg@mail.gmail.com>
In-reply-to: <CAK9yfHy-dEx98YXLdJB0rW5yZ_HeKsy5aLSjH0XL07U=5HNgKg@mail.gmail.com>
Subject: RE: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
Date: Tue, 18 Jun 2013 10:19:58 +0200
Message-id: <008501ce6bfc$a0d2c020$e2784060$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun, Sachin,

> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Tuesday, June 18, 2013 7:27 AM
> To: Arun Kumar K
> Cc: Kamil Debski; Arun Kumar K; LMML; jtp.park@samsung.com; Sylwester
> Nawrocki; avnd.kiran@samsung.com
> Subject: Re: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
> 
> On 18 June 2013 10:21, Arun Kumar K <arunkk.samsung@gmail.com> wrote:
> > Hi Kamil,
> >
> > Thank you for the review.
> >
> >
> >>>  #define IS_MFCV6(dev)                (dev->variant->version >=
> 0x60 ? 1 :
> >> 0)
> >>> +#define IS_MFCV7(dev)                (dev->variant->version >=
> 0x70 ? 1 :
> >> 0)
> >>
> >> According to this, MFC v7 is also detected as MFC v6. Was this
> intended?
> >
> > Yes this was intentional as most of v7 will be reusing the v6 code
> and
> > only minor changes are there w.r.t firmware interface.
> >
> >
> >> I think that it would be much better to use this in code:
> >>         if (IS_MFCV6(dev) || IS_MFCV7(dev)) And change the define to
> >> detect only single MFC revision:
> >>         #define IS_MFCV6(dev)           (dev->variant->version >=
> 0x60 &&
> >> dev->variant->version < 0x70)
> >>
> >
> > I kept it like that since the macro IS_MFCV6() is used quite
> > frequently in the driver. Also if MFCv8 comes which is again similar
> > to v6 (not sure about this), then it will add another OR condition to
> > this check.
> >
> >> Other possibility I see is to change the name of the check. Although
> >> IS_MFCV6_OR_NEWER(dev) seems too long :)
> >>
> >
> > How about making it IS_MFCV6_PLUS()?
> 
> Technically
> #define IS_MFCV6(dev)                (dev->variant->version >= 0x60...)
> means all lower versions are also higher versions.
> This may not cause much of a problem (other than the macro being a
> misnomer) as all current higher versions are supersets of lower
> versions.
> But this is not guaranteed(?).

MFC versions 5+ have very much in common. However there are two previous
MFC versions - 4 (s5pc100?) and 1 (s3c6410). These versions are much 
different if I remember correctly. Drivers for these version are not
present in mainline, but I know that there are community members that
provide support and keep adding new drivers for older SoCs. Maybe
some day they will be added.

> 
> Hence changing the definition of the macro to (dev->variant->version
> >= 0x60 && dev->variant->version < 0x70) as Kamil suggested or
> renaming it to
> IS_MFCV6_PLUS() makes sense.

I agree, this name will be easier to understand.

> 
> OTOH, do we really have intermediate version numbers? For e.g. 0x61,
> 0x72, etc?
> 
> If not we can make it just:
> #define IS_MFCV6(dev)                (dev->variant->version == 0x60 ?
> 1 : 0)
> 
> 

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


