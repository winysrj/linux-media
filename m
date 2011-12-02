Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33625 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1LBBIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 20:08:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [PATCH v2 02/11] mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
Date: Fri, 2 Dec 2011 02:08:47 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com> <201112011824.54207.laurent.pinchart@ideasonboard.com> <CAKnK67R_sTToETijbBsyKXfdfvKv68vaF-_Ur5uYy=yKJ4hiEA@mail.gmail.com>
In-Reply-To: <CAKnK67R_sTToETijbBsyKXfdfvKv68vaF-_Ur5uYy=yKJ4hiEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112020208.47919.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Thursday 01 December 2011 18:35:20 Aguirre, Sergio wrote:
> On Thu, Dec 1, 2011 at 11:24 AM, Laurent Pinchart wrote:
> > On Thursday 01 December 2011 01:14:51 Sergio Aguirre wrote:
> >> The define should be the result of 1 << Bit number.
> >> 
> >> Bit number for GPOCTL.GPO3 field is 2, which results
> >> in 0x4 value.
> >> 
> >> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> >> ---
> >>  include/linux/mfd/twl6040.h |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
> >> index 2463c261..2a7ff16 100644
> >> --- a/include/linux/mfd/twl6040.h
> >> +++ b/include/linux/mfd/twl6040.h
> >> @@ -142,7 +142,7 @@
> >> 
> >>  #define TWL6040_GPO1                 0x01
> >>  #define TWL6040_GPO2                 0x02
> >> -#define TWL6040_GPO3                 0x03
> >> +#define TWL6040_GPO3                 0x04
> > 
> > What about defining the fields as (1 << x) instead then ?
> 
> I thought about that, but I guess I just wanted to keep it consistent with
> the rest of the file.

I've seen that as well. I'm fine with keeping the above defines if you prefer.

> Maybe I can create a separate patch for changing all these bitwise flags to
> use BIT() macros instead.

-- 
Regards,

Laurent Pinchart
