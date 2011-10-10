Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41693 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1JJRJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 13:09:27 -0400
Received: by ggnv2 with SMTP id v2so4707894ggn.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 10:09:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s1JDoSUqX2Fm7+L1HyNxAZkdenDfmy0M8U5nVLo2eSvOw@mail.gmail.com>
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
	<CA+2YH7tdMHNpJGyOhVJnR4UN5ZwCcspD0Nnj8xCvUs7RaERb_w@mail.gmail.com>
	<CA+2YH7uNvuRdWSoX25NvHryknExrfeew1heB5DNSf3Epz2LOUw@mail.gmail.com>
	<CAAwP0s1JDoSUqX2Fm7+L1HyNxAZkdenDfmy0M8U5nVLo2eSvOw@mail.gmail.com>
Date: Mon, 10 Oct 2011 19:09:27 +0200
Message-ID: <CA+2YH7votO73gQmdxhHkfLsc9sp8Z-S=wxxrJhsTYUzVqpiACA@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 6:53 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> On Mon, Oct 10, 2011 at 6:34 PM, Enrico <ebutera@users.berlios.de> wrote:
>> Ok, i made it work. It was missing just the config_outlineoffset i
>> wrote before and a missing FLDMODE in SYNC registers.
>>
>
> Great, do you get the ghosting effect or do you have a clean video?


Unfortunately i always get the ghosting effect. But this is something
we will try to fix later.


>> Moreover it seems to me that the software-maintained field id
>> (interlaced_cnt in Javier patches, fldstat in Deepthy patches) is
>> useless, i've tried to only use the FLDSTAT bit from isp register
>> (fid) in vd0_isr:
>>
>> if (fid == 0) {
>>     restart = ccdc_isr_buffer(ccdc);
>>     goto done;
>> }
>>
>> and it works. I've not tested very long frame sequences, only up to 16
>> frames. The only issue is that the first frame could be half-green
>> because a field is missing.
>>
>
> Yes, when I tried Deepthy patches I realized that the fldstat was not
> in sync with the frames, but probably I made something wrong.


I had noticed the same thing, but now i tested it and it is ok, maybe
my fault too.


> We had the same problem with the hal-green frame. Our solution was to
> synchronize the CCDC with the first even field looking at fdstat on
> the VD1 interrupt handler and forcing to start processing from an ODD
> sub-frame.

Thinking more about it, it's ugly to have that half-green video frame
even if it's just one. It's better to keep your or Deepthy solution.

Enrico
