Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34084
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750914AbdCMKAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 06:00:34 -0400
Date: Mon, 13 Mar 2017 07:00:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 12/23] MAINTAINERS: Add file patterns for media
 device tree bindings
Message-ID: <20170313070027.4df48c03@vento.lan>
In-Reply-To: <CAMuHMdXYkMWUYSoWRr87eq9t3dFjjM7R1cDwYxKOVBBLmX57mg@mail.gmail.com>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
        <1489324627-19126-13-git-send-email-geert@linux-m68k.org>
        <20170312220231.193801fd@vento.lan>
        <CAMuHMdXYkMWUYSoWRr87eq9t3dFjjM7R1cDwYxKOVBBLmX57mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 13 Mar 2017 08:43:52 +0100
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> Hi Mauro,
> 
> On Mon, Mar 13, 2017 at 2:02 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Em Sun, 12 Mar 2017 14:16:56 +0100
> > Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
> >  
> >> Submitters of device tree binding documentation may forget to CC
> >> the subsystem maintainer if this is missing.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> >
> > As the To: is devicetree, I'm assuming that this patch will be
> > applied there, so:
> >
> > Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Thanks!
> 
> > I may also merge via my tree, if that would be better. Just let me
> > know in such case.  
> 
> Please apply to your tree, cfr.
> 
> | Please apply this patch directly if you want to be involved in device
> | tree binding documentation for your subsystem.

I saw that text, but, as you send it to devicetree ML, c/c me and media,
I was in doubt if "your subsystem" would be DT subsystem or media.

I'll apply it on my tree.

Regards,
Mauro
