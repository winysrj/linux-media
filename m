Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58175 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1JJQyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 12:54:00 -0400
Received: by ywb5 with SMTP id 5so5553241ywb.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 09:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7uNvuRdWSoX25NvHryknExrfeew1heB5DNSf3Epz2LOUw@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
 <CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
 <201110081751.38953.laurent.pinchart@ideasonboard.com> <CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
 <CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
 <CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
 <CA+2YH7uFeHAmEpVqbd94qtCajb45pkr9YzeW+RDa5sf2bUG_wQ@mail.gmail.com>
 <CAAwP0s3GJ7-By=q_ADa6qcpaENK5kXvkTG8Hd=Y+qXs9dgXa0w@mail.gmail.com>
 <CA+2YH7subMzFAg7f7-uHXEmYBD+Kd1=E2nWKx7dgKCEpOu=zgQ@mail.gmail.com>
 <CA+2YH7ti4xz9zNby6O=3ZOKAB9=1hnYZr9cM8HSMrj0r4zi1=A@mail.gmail.com>
 <CAAwP0s3ZqDpMsF7mYYtM7twomREZTyO-uDhGPnfNsQcOTXQ_fw@mail.gmail.com>
 <CA+2YH7s6rhLsyJTdWwQVUCd2WBWiH2saSaZZw0tysRWsXw-6Cg@mail.gmail.com>
 <CA+2YH7tdMHNpJGyOhVJnR4UN5ZwCcspD0Nnj8xCvUs7RaERb_w@mail.gmail.com> <CA+2YH7uNvuRdWSoX25NvHryknExrfeew1heB5DNSf3Epz2LOUw@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 10 Oct 2011 18:53:40 +0200
Message-ID: <CAAwP0s1JDoSUqX2Fm7+L1HyNxAZkdenDfmy0M8U5nVLo2eSvOw@mail.gmail.com>
Subject: Re: omap3-isp status
To: Enrico <ebutera@users.berlios.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 6:34 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Mon, Oct 10, 2011 at 4:17 PM, Enrico <ebutera@users.berlios.de> wrote:
>> On Mon, Oct 10, 2011 at 2:46 PM, Enrico <ebutera@users.berlios.de> wrote:
>>> On Mon, Oct 10, 2011 at 12:33 PM, Javier Martinez Canillas
>>>> Perfect, thank you Enrico. I will try this latter today and let you
>>>> know. I'm sure I can get this working (with the ghosting effect of
>>>> course) so you can at least obtain 25 fps and once I have this working
>>>> I will resend the patch-set as v3 so Laurent can review it and
>>>> hopefully help us to fix the artifact on the video.
>>>
>>> Yes it must be something simple but not easy to spot.
>>>
>>> And to add even more confusion i've attached two patches: one is a
>>> port of two Deepthy patches, the other one just a board fix.
>>>
>>> Just replace patches 0017-18-19 with the attached 0001 patch, and
>>> after patch 0025 apply the attached 0002 patch.
>>>
>>> With these i can succesfully grab frames with yavta BUT i only get
>>> half-height frames. Disclaimer: i just made the patch monkey and gave
>>> it a run without a review so it could be anything.
>>
>> My bad, i forgot a part about config_outlineoffset (ODDEVEN...), i
>> still have (different) half-green images though...
>>
>> Side note: while making some tests i can confirm that the solution
>> adopted in Deepthy patches:
>>
>> u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>> fid = syn_mode & ISPCCDC_SYN_MODE_FLDSTAT;
>> /* toggle the software maintained fid */
>>
>> works as expected, i see fid switching correctly.
>
> Ok, i made it work. It was missing just the config_outlineoffset i
> wrote before and a missing FLDMODE in SYNC registers.
>

Great, do you get the ghosting effect or do you have a clean video?

> Moreover it seems to me that the software-maintained field id
> (interlaced_cnt in Javier patches, fldstat in Deepthy patches) is
> useless, i've tried to only use the FLDSTAT bit from isp register
> (fid) in vd0_isr:
>
> if (fid == 0) {
>     restart = ccdc_isr_buffer(ccdc);
>     goto done;
> }
>
> and it works. I've not tested very long frame sequences, only up to 16
> frames. The only issue is that the first frame could be half-green
> because a field is missing.
>
> Enrico
>

Yes, when I tried Deepthy patches I realized that the fldstat was not
in sync with the frames, but probably I made something wrong.

We had the same problem with the hal-green frame. Our solution was to
synchronize the CCDC with the first even field looking at fdstat on
the VD1 interrupt handler and forcing to start processing from an ODD
sub-frame.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
