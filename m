Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:33729 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751999AbdLLQCv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 11:02:51 -0500
Message-ID: <1513094567.3036.54.camel@perches.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Dec 2017 08:02:47 -0800
In-Reply-To: <CAK8P3a2=FG-cO5G0S5xssrEcX-rmem2xS-SDsaLOGfYmcHWGBQ@mail.gmail.com>
References: <20171211120612.3775893-1-arnd@arndb.de>
         <1513020868.3036.0.camel@perches.com>
         <CAOcJUbyARps1CeRFvLau3w-rBvn2QLbsY2PHGymbpUyuFCJ2HA@mail.gmail.com>
         <CAK8P3a01sOsWSw4t-x6rv+9pzbfhZtEMc6iwV54Xq-48h6CN=Q@mail.gmail.com>
         <1513078952.3036.36.camel@perches.com> <20171212104530.46ac4ffe@vento.lan>
         <CAK8P3a2=FG-cO5G0S5xssrEcX-rmem2xS-SDsaLOGfYmcHWGBQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-12-12 at 15:21 +0100, Arnd Bergmann wrote:
> On Tue, Dec 12, 2017 at 1:45 PM, Mauro Carvalho Chehab
> <mchehab@kernel.org> wrote:
> > Em Tue, 12 Dec 2017 03:42:32 -0800
> > Joe Perches <joe@perches.com> escreveu:
> > 
> > > > I actually thought about marking them 'const' here before sending
> > > > (without noticing the changelog text) and then ran into what must
> > > > have led me to drop the 'const' originally: tuner_i2c_xfer_send()
> > > > takes a non-const pointer. This can be fixed but it requires
> > > > an ugly cast:
> > > 
> > > Casting away const is always a horrible hack.
> > > 
> > > Until it could be changed, my preference would
> > > be to update the changelog and perhaps add to
> > > the changelog the reason why it can not be const
> > > as detailed below.
> > > 
> > > ie: xfer_send and xfer_xend_recv both take a
> > >     non-const unsigned char *
> 
> Ok.
> 
> > Perhaps, on a separate changeset, we could change I2C routines to
> > accept const unsigned char pointers. This is unrelated to tda8290
> > KASAN fixes. So, it should go via I2C tree, and, once accepted
> > there, we can change V4L2 drivers (and other drivers) accordingly.
> 
> I don't see how that would work unfortunately. i2c_msg contains
> a pointer to the data, and that is used for both input and output,
> including arrays like
> 
>         struct i2c_msg msgs[] = {
>                 {
>                         .addr = dvo->slave_addr,
>                         .flags = 0,
>                         .len = 1,
>                         .buf = &addr,
>                 },
>                 {
>                         .addr = dvo->slave_addr,
>                         .flags = I2C_M_RD,
>                         .len = 1,
>                         .buf = val,
>                 }
>         };
> 
> that have one constant output pointer and one non-constant
> input pointer. We could add an anonymous union for 'buf'
> to make that two separate pointers, but that's barely any
> better than the cast, and it would break the named initializers
> in the example above, at least on older compilers. Adding
> a second pointer to i2c_msg would add a bit of bloat and
> also require tree-wide changes or ugly hacks.

Perhaps add something like

struct i2c_msg_set {
	__u16 addr;		/* slave address			*/
	__u16 flags;
	__u16 len;		/* msg length				*/
	const __u8 *buf;	/* pointer to read-only msg data	*/
};

struct i2c_msg_get {
	__u16 addr;		/* slave address			*/
	__u16 flags;
	__u16 len;		/* msg length				*/
	__u8 *buf;		/* pointer to writeable msg data	*/
};

to the uapi include and use that where appropriate
but where a write then read is done via a single
i2c_msg array, it's not really feasible either.

Probably better to avoid any churn and just mark
all these as static rather than static const.
