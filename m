Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43167 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954Ab3IJVlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 17:41:46 -0400
Date: Wed, 11 Sep 2013 00:41:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC> multi-crop (was: Multiple Rectangle cropping)
Message-ID: <20130910214140.GD2057@valkosipuli.retiisi.org.uk>
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
 <5228FB2E.5050503@gmail.com>
 <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Fri, Sep 06, 2013 at 10:30:18AM +0200, Ricardo Ribalda Delgado wrote:
> Hi Sylvester
> 
> Thanks for your response
> 
> Unfortunately, the v4l2_crop dont have any reserved field :(

Don't worry about v4lw_crop. we have selections now. :-)

> struct v4l2_crop {
> __u32 type; /* enum v4l2_buf_type */
> struct v4l2_rect        c;
> };
> 
> And changing that ABI I dont think is an option.
> 
> What about a new call: G/S_READOUT .that uses a modified
> v4l2_selection as you propose?

Could this functionality be added to the ex$sting selection API, with a
possible extension in a for of a new field, say, "id" to tell which one is
being changed?

> That call selects the readable areas from the sensor.
> 
> The new structure could be something like:
> 
> #define SELECTION_BITMAP 0xffffffff
> #define SELECTION_RESET 0xfffffffe
> #define SELECTION_MAX_AREAS 32
> struct v4l2_selection {
> __u32 type;
> __u32 target;
> __u32                   flags;
> union {
>    struct v4l2_rect        r;
>    __u32 bitmap;
> };
> __u32 n;
> __u32                   reserved[8];
> };
> 
> n chooses the readout area to choose, up to 32.
> 
> When n is == 0xffffffff the user wants to change the bitmap that
> selects which areas are enabled.
>   When the bitmap is 0x0 all the sensor is read.
>   When the bitmap is 0x5 the readout area 0 and 2 are enabled.
> 
> When the bitmap is set to a value !=0, the driver checks if the
> combination of readout areas is supported by the sensor/readout logic
> and returns -EINVAL if not.
> 
> The g/s_crop API still works as usual.
> 
> Any comment on this? Of course the names should be better chosen, this
> is just a declaration of intentions.

I think the functionality you're describing is highly peculiar. I have to
say that, as Sylwester noted, it bears resemblance to the AF windows so the
solution could be same as well.

I think earlier on (say perhaps a year and a half) ago it was proposed to
use bitmask controls with selections to tell which IDs are valid. What would
you think about that?

It's also always possible to use private controls, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
