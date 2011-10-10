Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40903 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1JJMyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 08:54:14 -0400
Received: by ggnv2 with SMTP id v2so4430890ggn.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 05:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3ZqDpMsF7mYYtM7twomREZTyO-uDhGPnfNsQcOTXQ_fw@mail.gmail.com>
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
Date: Mon, 10 Oct 2011 14:54:14 +0200
Message-ID: <CA+2YH7tCOdpjiWhC80Nx8OiijJHVYxZypdB0E=3p1zn0bXVpQw@mail.gmail.com>
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

On Mon, Oct 10, 2011 at 12:33 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> On Mon, Oct 10, 2011 at 12:07 PM, Enrico <ebutera@users.berlios.de> wrote:
>> On Mon, Oct 10, 2011 at 12:06 PM, Enrico <ebutera@users.berlios.de> wrote:
>>> I have updated my igep openembedded layer at [1] (testing branch) with:
>>
>> Ops, forgot [1] !
>>
>> [1]: https://github.com/ebutera/meta-igep
>>
>> Enrico
>>
>
> Perfect, thank you Enrico. I will try this latter today and let you
> know. I'm sure I can get this working (with the ghosting effect of
> course) so you can at least obtain 25 fps and once I have this working
> I will resend the patch-set as v3 so Laurent can review it and
> hopefully help us to fix the artifact on the video.

For your tests i suggest to add "nohlt" to the kernel cmdline, see [1]
for the reason.

Enrico

[1]: http://www.spinics.net/lists/linux-media/msg37795.html
