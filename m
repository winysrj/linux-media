Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50153 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935242AbdKQPBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:01:13 -0500
Date: Fri, 17 Nov 2017 13:01:04 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] media: usb: add SPDX identifiers to some code I
 wrote
Message-ID: <20171117130104.1479fd43@vento.lan>
In-Reply-To: <CAOFm3uFQGftabX93YEiLfpAoR+7kEvwuLudH+A7Bo4zKa60TOQ@mail.gmail.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
        <fd92263a2c04a10d58ce465058391e6e8703dc90.1510913595.git.mchehab@s-opensource.com>
        <CAOFm3uFQGftabX93YEiLfpAoR+7kEvwuLudH+A7Bo4zKa60TOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Nov 2017 12:54:15 +0100
Philippe Ombredanne <pombredanne@nexb.com> escreveu:

> On Fri, Nov 17, 2017 at 11:21 AM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > As we're now using SPDX identifiers, on several
> > media drivers I wrote, add the proper SPDX, identifying
> > the license I meant.
> >
> > As we're now using the short license, it doesn't make sense to
> > keep the original license text.
> >
> > Also, fix MODULE_LICENSE to properly identify GPL v2.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Mauro,
> Thanks ++ .... I can now get rid of a special license detection rule I
> had added for the specific language of your notices in the
> scancode-toolkit!

:-)

Yeah, I was too lazy to copy the usual GPL preamble on those
drivers ;-)

> 
> FWIW for this 6 patch series:
> 
> Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>

Thanks!
Mauro
