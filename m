Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39007 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1JKKvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 06:51:17 -0400
Received: by gyg10 with SMTP id 10so6349389gyg.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 03:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7v444zTDCV9Gmnkcj+mXB10RZE4KU2zDHFMqjzDmUXLzw@mail.gmail.com>
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
 <CA+2YH7tdMHNpJGyOhVJnR4UN5ZwCcspD0Nnj8xCvUs7RaERb_w@mail.gmail.com>
 <CA+2YH7uNvuRdWSoX25NvHryknExrfeew1heB5DNSf3Epz2LOUw@mail.gmail.com>
 <CAAwP0s1JDoSUqX2Fm7+L1HyNxAZkdenDfmy0M8U5nVLo2eSvOw@mail.gmail.com>
 <CA+2YH7votO73gQmdxhHkfLsc9sp8Z-S=wxxrJhsTYUzVqpiACA@mail.gmail.com>
 <CAAwP0s3tUUm+9S-MasWcp2HMLOW6xegQMTNbhxJ6355fW=hr0g@mail.gmail.com> <CA+2YH7v444zTDCV9Gmnkcj+mXB10RZE4KU2zDHFMqjzDmUXLzw@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 11 Oct 2011 12:50:57 +0200
Message-ID: <CAAwP0s0-5h=R39V7Nf3896eLi0HVXY8+edguMEH_Dtbs5RZnhg@mail.gmail.com>
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

On Tue, Oct 11, 2011 at 12:29 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Mon, Oct 10, 2011 at 8:18 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> On Mon, Oct 10, 2011 at 7:09 PM, Enrico <ebutera@users.berlios.de> wrote:
>>> On Mon, Oct 10, 2011 at 6:53 PM, Javier Martinez Canillas
>>> <martinez.javier@gmail.com> wrote:
>>>> On Mon, Oct 10, 2011 at 6:34 PM, Enrico <ebutera@users.berlios.de> wrote:
>>>>> Ok, i made it work. It was missing just the config_outlineoffset i
>>>>> wrote before and a missing FLDMODE in SYNC registers.
>>>>>
>>>>
>>>> Great, do you get the ghosting effect or do you have a clean video?
>>>
>>>
>>> Unfortunately i always get the ghosting effect. But this is something
>>> we will try to fix later.
>>>
>>>
>>
>> Agree, we should try to get some code upstream to add interlaced video
>> and bt.656 support and fix the artifact later.
>>
>>>>> Moreover it seems to me that the software-maintained field id
>>>>> (interlaced_cnt in Javier patches, fldstat in Deepthy patches) is
>>>>> useless, i've tried to only use the FLDSTAT bit from isp register
>>>>> (fid) in vd0_isr:
>>>>>
>>>>> if (fid == 0) {
>>>>>     restart = ccdc_isr_buffer(ccdc);
>>>>>     goto done;
>>>>> }
>>>>>
>>>>> and it works. I've not tested very long frame sequences, only up to 16
>>>>> frames. The only issue is that the first frame could be half-green
>>>>> because a field is missing.
>>>>>
>>>>
>>>> Yes, when I tried Deepthy patches I realized that the fldstat was not
>>>> in sync with the frames, but probably I made something wrong.
>>>
>>>
>>> I had noticed the same thing, but now i tested it and it is ok, maybe
>>> my fault too.
>>>
>>>
>>>> We had the same problem with the hal-green frame. Our solution was to
>>>> synchronize the CCDC with the first even field looking at fdstat on
>>>> the VD1 interrupt handler and forcing to start processing from an ODD
>>>> sub-frame.
>>>
>>> Thinking more about it, it's ugly to have that half-green video frame
>>> even if it's just one. It's better to keep your or Deepthy solution.
>>>
>>> Enrico
>>>
>>
>> Well, that is something that can be fixed later also. Can you send to
>> the list your patches? So, Laurent, Sakari and others than know more
>> about the ISP can review it. I hope they can find the cause for the
>> artifact.
>
> I'm attaching some fixes (taken from Deepthy patches) to be applied on
> top of your v2 patches, with those i can grab frames but i only get
> garbage.
>

Yes, I still couldn't find time to try that patch on real hardware, sorry.

> I think the problem is that it always hits this in ccdc_isr_buffer:
>
> if (ccdc_sbl_wait_idle(ccdc, 1000)) {
>                dev_info(isp->dev, "CCDC won't become idle!\n");
>                goto done;
> }
>
> so the video buffer never gets updated.
>
> At this point i think it is better to go on with my port of Deepthy
> patches and try to solve the ghosting issues, maybe with your fixes
> about buffer decoupling.
>

I second you on that. Deepthy patches make two changes to the ISP in
order to support BT.656:

1- Add support to configure the bridge with UYVY8_2X8 format.
2- Add support to interlaced video mode.

Looking at your fixes taken from Deepthy I see code that still make
(1). I understood from Laurent's comments that its oma3isp-yuv branch
already made (1), but he also said he didn't try on hardware though.

I think the best approach is to resend Deepthy patches again on top of
Laurent's yuv branch so it can be reviewed. Probably Laurent will want
then to split the patch in two, one to fix the UYVY8_2X8 support and
another one that adds support to interlaced video mode.

> Laurent, what do you suggest to do?
>
> Enrico
>

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
