Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59595 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677AbcB2N2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:28:00 -0500
Subject: Re: [PATCH/RFC 0/4] media: soc_camera: rcar_vin: Add UDS and NV16
 scaling support
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D4475A.1070203@xs4all.nl>
Date: Mon, 29 Feb 2016 14:27:54 +0100
MIME-Version: 1.0
In-Reply-To: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huh, you must have missed Niklas's work the rcar-vin driver:

http://www.spinics.net/lists/linux-media/msg97816.html

I expect that the old soc-camera driver will be retired soon in favor of
the new driver, so I don't want to accept patches for that one.

I recommend that you check the new driver and see what (if anything) is needed
to get this functionality in there and work with Niklas on this.

This is all quite recent work, so it is not surprising that you missed it.

Regards,

	Hans

On 02/29/2016 02:12 PM, Yoshihiro Kaneko wrote:
> This series adds UDS support, NV16 scaling support and callback functions
> to be required by a clipping process.
> 
> This series is against the master branch of linuxtv.org/media_tree.git.
> 
> Koji Matsuoka (3):
>   media: soc_camera: rcar_vin: Add get_selection callback function
>   media: soc_camera: rcar_vin: Add cropcap callback function
>   media: soc_camera: rcar_vin: Add NV16 scaling support
> 
> Yoshihiko Mori (1):
>   media: soc_camera: rcar_vin: Add UDS support
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 220 ++++++++++++++++++++++-----
>  1 file changed, 184 insertions(+), 36 deletions(-)
> 

