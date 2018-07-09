Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34844 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbeGIM7f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 08:59:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 05/12] media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
Date: Mon, 09 Jul 2018 16:00:08 +0300
Message-ID: <2187896.B0EHAgUiIi@avalon>
In-Reply-To: <CAAEAJfAmHZD2sjw9NF2Fyv6j+Z-usKJL4YNG5pgfZuyBSqLZkQ@mail.gmail.com>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <20180629114331.7617-6-hverkuil@xs4all.nl> <CAAEAJfAmHZD2sjw9NF2Fyv6j+Z-usKJL4YNG5pgfZuyBSqLZkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, 29 June 2018 20:40:49 EEST Ezequiel Garcia wrote:
> On 29 June 2018 at 08:43, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > From: Hans Verkuil <hansverk@cisco.com>
> > 
> > The use of 'DTV' is very confusing since it normally refers to Digital
> > TV e.g. DVB etc.
> > 
> > Instead use 'DV' (Digital Video), which nicely corresponds to the
> > DV Timings API used to configure such receivers and transmitters.
> > 
> > We keep an alias to avoid breaking userspace applications.
> > 
> > Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> > ---
> > 
> >  Documentation/media/uapi/mediactl/media-types.rst | 2 +-
> >  drivers/media/i2c/adv7604.c                       | 1 +
> >  drivers/media/i2c/adv7842.c                       | 1 +
> 
> It would be nice to mention in the commit log
> that this patch also sets the function for these drivers.

That's also my only concern with this patch (alternatively that change could 
be split to a separate patch).

-- 
Regards,

Laurent Pinchart
