Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55157 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944426AbcJaRFa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:05:30 -0400
Date: Mon, 31 Oct 2016 17:05:26 +0000
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any
 transmitting time for tx only devices
Message-ID: <20161031170526.GA8183@gofer.mess.org>
References: <20161027143601.GA5103@gofer.mess.org>
 <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
 <CGME20160902084206epcas1p26e535506ec1c418ede9ba230d40f0656@epcas1p2.samsung.com>
 <20160902084158.GA25342@gofer.mess.org>
 <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
 <7e2f88ed83c4044c30bc03aaea9f09e1@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e2f88ed83c4044c30bc03aaea9f09e1@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David, Andi,

On Mon, Oct 31, 2016 at 02:31:52PM +0000, David Härdeman wrote:
> October 27, 2016 4:36 PM, "Sean Young" <sean@mess.org> wrote:
> > Since we have to be able to switch between waiting and not waiting,
> > we need some sort of ABI for this. I think this warrants a new ioctl;
> > I'm not sure how else it can be done. I'll be sending out a patch
> > shortly.
> 
> Hi Sean,
> 
> have you considered using a module param for the LIRC bridge module instead? As far as I understand it, this is an issue which is entirely internal to LIRC, and it's also not something which really needs to be changed on a per-device level (either you have a modern LIRC daemon or you don't, and all drivers should behave the same, no?).

I still don't see how any of this would change anything for the ir-spi case:
since it uses sync spi transfer, it's going to block anyway.

> Another advantage is that the parameter would then go away if and when the lirc bridge ever goes away (yes, I can still dream, can't I?).

The suggested ioctl is unique to lirc too and would disappear if the
lirc ABI goes away. With a module parameter you would change the lirc ABI
into an incompatible one. Not sure that is what module parameters should
be used for.

Andi, it would be good to know what the use-case for the original change is.


Thanks
Sean
