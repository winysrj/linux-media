Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59864 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732502AbeGKLjb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 07:39:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 05/12] media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
Date: Wed, 11 Jul 2018 14:36:07 +0300
Message-ID: <3637719.YFNTZDU0bC@avalon>
In-Reply-To: <0304525b-17cb-e92a-4c38-2c356dacffa2@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl> <2187896.B0EHAgUiIi@avalon> <0304525b-17cb-e92a-4c38-2c356dacffa2@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday, 9 July 2018 16:42:09 EEST Hans Verkuil wrote:
> On 09/07/18 15:00, Laurent Pinchart wrote:
> > On Friday, 29 June 2018 20:40:49 EEST Ezequiel Garcia wrote:
> >> On 29 June 2018 at 08:43, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> From: Hans Verkuil <hansverk@cisco.com>
> >>> 
> >>> The use of 'DTV' is very confusing since it normally refers to Digital
> >>> TV e.g. DVB etc.
> >>> 
> >>> Instead use 'DV' (Digital Video), which nicely corresponds to the
> >>> DV Timings API used to configure such receivers and transmitters.
> >>> 
> >>> We keep an alias to avoid breaking userspace applications.
> >>> 
> >>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> >>> ---
> >>> 
> >>>  Documentation/media/uapi/mediactl/media-types.rst | 2 +-
> >>>  drivers/media/i2c/adv7604.c                       | 1 +
> >>>  drivers/media/i2c/adv7842.c                       | 1 +
> >> 
> >> It would be nice to mention in the commit log
> >> that this patch also sets the function for these drivers.
> > 
> > That's also my only concern with this patch (alternatively that change
> > could be split to a separate patch).
> 
> I'll clarify the commit log. I can't split up this patch since the old
> define is only available under #ifndef __KERNEL__, to prevent drivers from
> accidentally using it in the kernel in the future.

But the two drivers above don't use MEDIA_ENT_F_DTV_DECODER, do they ? Only 
drivers/media/i2c/tda1997x.c does.

-- 
Regards,

Laurent Pinchart
