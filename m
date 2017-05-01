Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50808 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969026AbdEAEih (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:38:37 -0400
Subject: Re: [RFC] [PATCH 0/4] [media] pxa_camera: Fixing bugs and missing
 colorformats
To: robert.jarzmik@free.fr
References: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
Cc: linux-media@vger.kernel.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <34b6ce27-7567-a654-4276-ae522b44f781@tul.cz>
Date: Mon, 1 May 2017 06:39:42 +0200
MIME-Version: 1.0
In-Reply-To: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 1.5.2017 v 06:20 Petr Cvek napsal(a):
> This patchset is just a grouping of a few bugfixes I've found during
> the ov9640 sensor support re-adding. 

P.S. I've manually calculated every format variant for the image size calculation functions, but still these functions are not too robust (for every hypothetical bps/packing/layout combination). For example:

MEDIA_BUS_FMT_Y8_1X8
	.name			= "Grey",
	.bits_per_sample	= 8,
	.packing		= PXA_MBUS_PACKING_NONE,
	.order			= PXA_MBUS_ORDER_LE,
	.layout			= PXA_MBUS_LAYOUT_PACKED,

seems to me as a little bit misleading. The better solution would be to have something like bytes_per_line and image_size coefficients. Is my idea worth a try?

Anyway the .order field seems to be unused (it is a pxa_camera defined structure). I'm for removing it (I can create a patch and test it on the real hardware). Unless there are plans for it.

The pxa_camera_get_formats() could be probably simplified even up to the point of a removal of the soc_camera_format_xlate structure. If no one works on it (in like 2 months) I can try to simplify it.

best regards,
Petr Cvek
