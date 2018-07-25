Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38710 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731437AbeGZATZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 20:19:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Carlos Garnacho <carlosg@gnome.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Devices with a front and back webcam represented as a single UVC device
Date: Thu, 26 Jul 2018 02:06:06 +0300
Message-ID: <10745005.DZ8nYEgB6R@avalon>
In-Reply-To: <CABxcv=kTDtmFy=FDmJGLvu6NZk9iHuQBGZR7T9tvSs03Q8dYcA@mail.gmail.com>
References: <8804dcb3-1aca-3679-6a96-bbe554f188d0@redhat.com> <1762892.v9kic1zYKq@avalon> <CABxcv=kTDtmFy=FDmJGLvu6NZk9iHuQBGZR7T9tvSs03Q8dYcA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday, 24 July 2018 15:35:17 EEST Javier Martinez Canillas wrote:
> On Thu, Jul 12, 2018 at 3:01 PM, Laurent Pinchart wrote:
> 
> [snip]
> 
> >> Laurent, thank you for your input on this. I thought it was a bit weird
> >> that the cam on my HP X2 only had what appears to be the debug controls,
> >> so I opened it up and as I suspect (after your analysis) it is using a
> >> USB module for the front camera, but the back camera is a sensor
> >> directly hooked with its CSI/MIPI bus to the PCB, so very likely it is
> >> using the ATOMISP stuff.
> >> 
> >> So I think that we can consider this "solved" for my 2-in-1.
> > 
> > Great, I'll add you to the list of potential testers for an ATOMISP
> > solution :-)
> 
> The ATOMISP driver was removed from staging by commit 51b8dc5163d
> ("media: staging: atomisp: Remove driver"). Do you mean that there's a
> plan to bring that driver back?

I don't think so, unless someone is willing to invest the time it would need 
to bring it back.

-- 
Regards,

Laurent Pinchart
