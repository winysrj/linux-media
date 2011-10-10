Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40208 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab1JJORr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 10:17:47 -0400
Received: by yxl31 with SMTP id 31so5385801yxl.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 07:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7s6rhLsyJTdWwQVUCd2WBWiH2saSaZZw0tysRWsXw-6Cg@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
	<CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
	<201110081751.38953.laurent.pinchart@ideasonboard.com>
	<CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
	<CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
	<CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
	<CA+2YH7uFeHAmEpVqbd94qtCajb45pkr9YzeW+RDa5sf2bUG_wQ@mail.gmail.com>
	<CAAwP0s3GJ7-By=q_ADa6qcpaENK5kXvkTG8Hd=Y+qXs9dgXa0w@mail.gmail.com>
	<CA+2YH7subMzFAg7f7-uHXEmYBD+Kd1=E2nWKx7dgKCEpOu=zgQ@mail.gmail.com>
	<CA+2YH7ti4xz9zNby6O=3ZOKAB9=1hnYZr9cM8HSMrj0r4zi1=A@mail.gmail.com>
	<CAAwP0s3ZqDpMsF7mYYtM7twomREZTyO-uDhGPnfNsQcOTXQ_fw@mail.gmail.com>
	<CA+2YH7s6rhLsyJTdWwQVUCd2WBWiH2saSaZZw0tysRWsXw-6Cg@mail.gmail.com>
Date: Mon, 10 Oct 2011 16:17:47 +0200
Message-ID: <CA+2YH7tdMHNpJGyOhVJnR4UN5ZwCcspD0Nnj8xCvUs7RaERb_w@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 2:46 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Mon, Oct 10, 2011 at 12:33 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> On Mon, Oct 10, 2011 at 12:07 PM, Enrico <ebutera@users.berlios.de> wrote:
>>> On Mon, Oct 10, 2011 at 12:06 PM, Enrico <ebutera@users.berlios.de> wrote:
>>>> I have updated my igep openembedded layer at [1] (testing branch) with:
>>>
>>> Ops, forgot [1] !
>>>
>>> [1]: https://github.com/ebutera/meta-igep
>>>
>>> Enrico
>>>
>>
>> Perfect, thank you Enrico. I will try this latter today and let you
>> know. I'm sure I can get this working (with the ghosting effect of
>> course) so you can at least obtain 25 fps and once I have this working
>> I will resend the patch-set as v3 so Laurent can review it and
>> hopefully help us to fix the artifact on the video.
>
> Yes it must be something simple but not easy to spot.
>
> And to add even more confusion i've attached two patches: one is a
> port of two Deepthy patches, the other one just a board fix.
>
> Just replace patches 0017-18-19 with the attached 0001 patch, and
> after patch 0025 apply the attached 0002 patch.
>
> With these i can succesfully grab frames with yavta BUT i only get
> half-height frames. Disclaimer: i just made the patch monkey and gave
> it a run without a review so it could be anything.

My bad, i forgot a part about config_outlineoffset (ODDEVEN...), i
still have (different) half-green images though...

Side note: while making some tests i can confirm that the solution
adopted in Deepthy patches:

u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
fid = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT;
/* toggle the software maintained fid */

works as expected, i see fid switching correctly.

Enrico
