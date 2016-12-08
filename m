Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36757
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752259AbcLHTvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 14:51:12 -0500
Date: Thu, 8 Dec 2016 17:51:02 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v3] [media] tvp5150: don't touch register
 TVP5150_CONF_SHARED_PIN if not needed
Message-ID: <20161208175102.50c936f1@vento.lan>
In-Reply-To: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com>
References: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  8 Dec 2016 17:46:53 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> commit 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
> depending on the type of bus set via the .set_fmt() subdev callback.
> 
> This is known to cause trobules on devices that don't use a V4L2
> subdev devnode, and a fix for it was made by commit 47de9bf8931e
> ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
> such fix doesn't consider the case of progressive video inputs,
> causing chroma decoding issues on such videos, as it overrides not
> only the type of video output, but also other unrelated bits.
> 
> So, instead of trying to guess, let's detect if the device configuration
> is set via Device Tree. If not, just ignore the new logic, restoring
> the original behavior.
> 
> Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation support")
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> 
> changes since version 2: 
>   - fixed settings for register 0x0d
>   - tested on WinTV USB2 with S-Video input
> 
> I'll do an extra test with HVR-950 on both S-Video and composite soon enough

Tested with HVR-950 (USB ID 2040:6513, Hauppauge model 65201, rev A1C0):
	- both S-Video and composite entries are working.

Thanks,
Mauro
