Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57893 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965652AbdKQQag (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 11:30:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 6/6] media: usb: add SPDX identifiers to some code I wrote
Date: Fri, 17 Nov 2017 18:30:45 +0200
Message-ID: <2260317.oRs8TJsbN5@avalon>
In-Reply-To: <CAOFm3uHnbdSab3w0VQ6+WPPNkXSF96725c8NaRi4O_vixkmCNw@mail.gmail.com>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com> <20171117130104.1479fd43@vento.lan> <CAOFm3uHnbdSab3w0VQ6+WPPNkXSF96725c8NaRi4O_vixkmCNw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

On Friday, 17 November 2017 17:08:51 EET Philippe Ombredanne wrote:
> On Fri, Nov 17, 2017 at 4:01 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 17 Nov 2017 12:54:15 +0100 Philippe Ombredanne escreveu:
> >> On Fri, Nov 17, 2017 at 11:21 AM, Mauro Carvalho Chehab wrote:
> >> > As we're now using SPDX identifiers, on several
> >> > media drivers I wrote, add the proper SPDX, identifying
> >> > the license I meant.
> >> > 
> >> > As we're now using the short license, it doesn't make sense to
> >> > keep the original license text.
> >> > 
> >> > Also, fix MODULE_LICENSE to properly identify GPL v2.
> >> > 
> >> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> 
> >> Mauro,
> >> Thanks ++ .... I can now get rid of a special license detection rule I
> >> had added for the specific language of your notices in the
> >> scancode-toolkit!
> >> 
> > :-)
> > 
> > Yeah, I was too lazy to copy the usual GPL preamble on those
> > drivers ;-)
> 
> I guess I built a lazyness checker with scancode to keep you check then ;)
> But FWIW you are not alone there and at least your notices are/were
> consistent across files ... there are still several hundred variations
> of GPL notices in the kernel each with subtle or byzantine changes.
> 
> Some of them are rather funny like Evgeniy's thermal code being under
> the "therms" of the GPL [1]

Isn't that very appropriate for the thermal code ?

https://en.wikipedia.org/wiki/Therm

Sorry, couldn't resist :)

> CC: Evgeniy Polyakov <zbr@ioremap.net>
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri
> vers/w1/slaves/w1_therm.c?h=v4.14-rc8#n8

-- 
Regards,

Laurent Pinchart
