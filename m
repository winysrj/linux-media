Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54453 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2GWRMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 13:12:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Documentation: DocBook DRM framework documentation
Date: Mon, 23 Jul 2012 19:12:42 +0200
Message-ID: <70690010.zp9nLr8Ar9@avalon>
In-Reply-To: <500D69EB.6000008@matrix-vision.de>
References: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com> <500D69EB.6000008@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Thank you for the review.

On Monday 23 July 2012 17:12:43 Michael Jones wrote:
> Hi Laurent,
> 
> At a quick glance I noticed a couple of things:
> 
> On 07/13/2012 02:00 AM, Laurent Pinchart wrote:
> 
> [snip]
> 
> > +    <para>
> > +      The <structname>drm_driver</structname> structure contains static
> > +      information that describe the driver and features it supports, and
> 
> s/describe/describes/

Fixed.

> > +      pointers to methods that the DRM core will call to implement the
> > DRM API.
> > +      We will first go through the <structname>drm_driver</structname>
> > static
> > +      information fields, and will then describe individual operations in
> > +      details as they get used in later sections.
> >       </para>
> > -
> >       <sect2>
> > -      <title>Driver private &amp; performance counters</title>
> > -      <para>
> > -	The driver private hangs off the main drm_device structure and
> > -	can be used for tracking various device-specific bits of
> > -	information, like register offsets, command buffer status,
> > -	register state for suspend/resume, etc.  At load time, a
> > -	driver may simply allocate one and set drm_device.dev_priv
> > -	appropriately; it should be freed and drm_device.dev_priv set
> > -	to NULL when the driver is unloaded.
> > -      </para>
> > +      <title>Driver Information</title>
> > +      <sect3>
> > +        <title>Driver Features</title>
> > +        <para>
> > +          Drivers inform the DRM core about their requirements and
> > supported
> > +          features by setting appropriate flags in the
> > +          <structfield>driver_features</structfield> field. Since those
> > flags
> > +          influence the DRM core behaviour since registration time, most
> > of them
>
> Elsewhere you use the American spelling "behavior".

I've used "behavior" when copying sections from the existing documentation. 
I'll unify that. Does kernel documentation favour one of the spellings ?

> [snip]
> 
> > +      <sect3>
> > +        <title>Major, Minor and Patchlevel</title>
> > +        <synopsis>int major;
> > +  int minor;
> > +  int patchlevel;</synopsis>
> 
> In my browser, "int minor" and "int patchlevel" look indented, whereas
> "int major" does not.  Looks like they _should_ be indented identically.
> Don't know how you fix this or if you even see the same problem.

Fixed.

[snip]

-- 
Regards,

Laurent Pinchart

