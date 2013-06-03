Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4401 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3FCNsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 09:48:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: phil.edworthy@renesas.com
Subject: Re: [PATCH] ov10635: Add OmniVision ov10635 SoC camera driver
Date: Mon, 3 Jun 2013 15:47:52 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1370252135-23261-1-git-send-email-phil.edworthy@renesas.com> <201306031149.45454.hverkuil@xs4all.nl> <OF4BD2B449.93EBBD07-ON80257B7F.0049D5FC-80257B7F.004A56F1@eu.necel.com>
In-Reply-To: <OF4BD2B449.93EBBD07-ON80257B7F.0049D5FC-80257B7F.004A56F1@eu.necel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306031547.52124.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 3 2013 15:31:55 phil.edworthy@renesas.com wrote:
> Hi Hans,
> 
> > Subject: Re: [PATCH] ov10635: Add OmniVision ov10635 SoC camera driver
> <snip>
> > > +#include <media/v4l2-chip-ident.h>
> > 
> > Don't implement chip_ident or use this header: it's going to be 
> > removed in 3.11.
> 
> <snip>

> > This can be dropped as well, because this header will go away.
> 
> Thanks for the very quick review! I'll have a look at the media tree to 
> see what's changing wrt the chip ident.

The chip ident removal isn't in yet. The patch series removing it was posted
on Wednesday:

http://www.mail-archive.com/linux-media@vger.kernel.org/

VIDIOC_DBG_G_CHIP_IDENT is replaced by VIDIOC_DBG_G_CHIP_INFO:

http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-dbg-g-chip-info

If I don't get any comments, then I'm going to make a pull request for the
chip ident removal on Friday or the Monday after that. It's a substantial
cleanup, so it will be nice to have that merged.

Regards,

	Hans
