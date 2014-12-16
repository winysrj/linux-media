Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40368 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaLPLkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 06:40:11 -0500
Date: Tue, 16 Dec 2014 09:40:05 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/6] Use LUT based implementation for (co)sine functions
Message-ID: <20141216094005.4c0c354b@recife.lan>
In-Reply-To: <20141216084553.7ade9777@recife.lan>
References: <548EE25C.4060808@iki.fi>
	<D0B5CB0E.2605C%prladdha@cisco.com>
	<20141216084553.7ade9777@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Dec 2014 08:45:53 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Tue, 16 Dec 2014 06:41:18 +0000
> "Prashant Laddha (prladdha)" <prladdha@cisco.com> escreveu:
> 
> > Antti, Mauro,
> > 
> > Thanks for your comments.
> > 
> > On 15/12/14 7:00 pm, "Antti Palosaari" <crope@iki.fi> wrote:
> > 
> > 
> > >On 12/15/2014 03:13 PM, Mauro Carvalho Chehab wrote:
> > >> Em Mon, 15 Dec 2014 14:49:17 +0530
> > >> Prashant Laddha <prladdha@cisco.com> escreveu:
> > >>
> > >>> Replaced Taylor series calculation for (co)sine with a
> > >>> look up table (LUT) for sine values.
> > >>
> > >> Kernel has already a LUT for sin/cos at:
> > >> 	include/linux/fixp-arith.h
> > >>
> > >> The best would be to either use it or improve its precision, if the one
> > >>there
> > >> is not good enough.
> > 
> > Thanks. I had not looked at this file earlier. But now when I looked at
> > this file I agree with Antti¹s comments below.
> > 
> > 
> > >
> > >I looked that one when made generator. It has poor precision and it uses
> > >degrees not radians.
> > 
> > > 
> > Also, it does not support calculation for phase values falling in middle
> > of two entries of LUT.
> > 
> > 
> > >But surely it is correct practice improve existing
> > >than introduce new.
> > 
> > I agree. Probably we can start looking into how to improve existing. I
> > looked at dependancies. As of now functions in fixp-arith is used by two
> > other files. Replacing current implementation in fixp-arith.h with high
> > precision will not work as it is, because caller functions are using
> > lesser precision. We probably need to discuss more on how to improve
> > existing implementation.
> 
> if you do a:
> 	$ git grep -e 'sin(' --or -e 'cos('
> 
> You'll notice that there are other drivers that have also their own
> sin()/cos() needs, with their own implementation.
> 
> I'm not saying we should touch them, but it is worth to check what are
> their needs, in order to be sure that whatever we do would latter fit
> on their usages.
> 
> > Some thoughts -
> > 1. Going by the name fixp-arith.h, I feel, it should have larger scope
> > than just (co)sine implementation. It can include divide as well. One
> > could also consider option to keep all trignometric functions in another
> > file
> 
> We could do that, but let's start with sin/cos functions. Btw, there are
> log implementation functions already at dvb-core at
> 	drivers/media/dvb-core/dvb_math.[ch]
> 
> Those are also candidates to be moved to a more generic place.
> 
> > 2. One could support APIs to provide output with different precisions, say
> > 16, 32, 64 bits etc. Not sure how final implementation would be but one
> > option would be to do internal computation with highest
> > precision possible and then truncate the result to have desired precision
> > based on the API called.
> 
> Internally, I would stick with a 32 bits implementation, where the 1.0 would
> mean S32_MAX. 64 bits is likely an overkill, and would be slower on 32 bits
> machines.
> 
> Using degrees also seem to be a good thing, as the table will be symmetric,
> and the 90th value will be equal to 1.0 (for a sin table). 
> 
> That means that we need an array with just 90 elements instead of 256.
> To be generic enough, the logic should use modulus math, to be sure that
> the given value will be converted into an angle between 0 and 360, and
> then down-converted to 0-90, in order to use a table with just a quarter
> of the values, e. g. something like:
> 
> static inline const s32 sin_table[] = {
> 	0x00000000, 0x023be165, 0x04779632, 0x06b2f1d2, 0x08edc7b6, 0x0b27eb5c, 
> 	0x0d61304d, 0x0f996a26, 0x11d06c96, 0x14060b67, 0x163a1a7d, 0x186c6ddd, 
> 	0x1a9cd9ac, 0x1ccb3236, 0x1ef74bf2, 0x2120fb82, 0x234815ba, 0x256c6f9e, 
> 	0x278dde6e, 0x29ac379f, 0x2bc750e8, 0x2ddf003f, 0x2ff31bdd, 0x32037a44, 
> 	0x340ff241, 0x36185aee, 0x381c8bb5, 0x3a1c5c56, 0x3c17a4e7, 0x3e0e3ddb, 
> 	0x3fffffff, 0x41ecc483, 0x43d464fa, 0x45b6bb5d, 0x4793a20f, 0x496af3e1, 
> 	0x4b3c8c11, 0x4d084650, 0x4ecdfec6, 0x508d9210, 0x5246dd48, 0x53f9be04, 
> 	0x55a6125a, 0x574bb8e5, 0x58ea90c2, 0x5a827999, 0x5c135399, 0x5d9cff82, 
> 	0x5f1f5ea0, 0x609a52d1, 0x620dbe8a, 0x637984d3, 0x64dd894f, 0x6639b039, 
> 	0x678dde6d, 0x68d9f963, 0x6a1de735, 0x6b598ea1, 0x6c8cd70a, 0x6db7a879, 
> 	0x6ed9eba0, 0x6ff389de, 0x71046d3c, 0x720c8074, 0x730baeec, 0x7401e4bf, 
> 	0x74ef0ebb, 0x75d31a5f, 0x76adf5e5, 0x777f903b, 0x7847d908, 0x7906c0af, 
> 	0x79bc384c, 0x7a6831b8, 0x7b0a9f8c, 0x7ba3751c, 0x7c32a67c, 0x7cb82884, 
> 	0x7d33f0c8, 0x7da5f5a3, 0x7e0e2e31, 0x7e6c924f, 0x7ec11aa3, 0x7f0bc095, 
> 	0x7f4c7e52, 0x7f834ecf, 0x7fb02dc4, 0x7fd317b3, 0x7fec09e1, 0x7ffb025e, 
> 	0x7fffffff
> };
> 
> s32 fixp_sin32(int value)
> {
> 	s32 ret;
> 	bool negative = false;
> 
> 	value = (value % 360 + 360) % 360;
> 	if (value > 180) {
> 		negative = true;
> 		value -= 180;
> 	}
> 	if (value > 90)
> 		value = 180 - value;
> 
> 	ret = sin_table[value];
> 
> 	return negative ? -ret : ret;
> }
> 
> And then define the 16 bits and cos() variants for it with:
> 
> #define fixp_cos32(v) fixp_sin32((v) + 90)
> #define fixp_sin16(v) (fixp_sin32(v) >> 16)
> #define fixp_cos16(v) (fixp_cos32(v) >> 16)
> 
> If we end latter to need 64 bits, it shouldn't be hard to change
> the logic there to add a different table.

Forgot to mention, but it could make sense to have a version
that would allow more than 360 values for the angle.
We can do that via linear interpolation. 

Something like (untested):

#define INT_2PI			((s32)(2 * 3.141592653589 * 32768.0))

static inline s32 fixp_sin32_rad(u32 radians)
{
	int degree;
	s32 v1, v2, dx, dy;
	u64 tmp;

	degree = (radians * 360) / INT_2PI;

	v1 = fixp_sin32(degree);
	v2 = fixp_sin32(degree + 1);

	dx = INT_2PI / 360;
	dy = v2 - v1;

	tmp = radians - (degree * INT_2PI) / 360;
	tmp *= dy;
	do_div(tmp, dx);

	ret (s32)(v1 + tmp64);
}


Regards,
Mauro
