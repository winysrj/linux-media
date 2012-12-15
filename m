Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47363 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2LOBNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 20:13:32 -0500
Message-ID: <50CBCE9A.4070006@iki.fi>
Date: Sat, 15 Dec 2012 03:12:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214230324.1e45c182@redhat.com>
In-Reply-To: <20121214230324.1e45c182@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2012 03:03 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 15 Dec 2012 02:56:25 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> NACK. NEC variant selection logic is broken by design.
>
> If you think so, then feel free to fix it without causing regressions to
> the existing userspace.
>
> While you don't do it, I don't see anything wrong on this patch, as it
> will behave just like any other NEC decoder.

yes, so true as I mentioned end of the mail. But it is very high 
probability there is some non/wrong working keys when 32bit NEC variant 
remote is used with that implementation.

And what happened those patches David sends sometime ago. I remember 
there was a patch for the af9015 which removes that kind of logic from 
the driver. If not change NEC to 32bit at least heuristic could be moved 
to single point - rc-core.

regards
Antti

-- 
http://palosaari.fi/
