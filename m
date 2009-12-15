Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47266 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760492AbZLOVPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 16:15:31 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mitar <mitar@tnode.com>
Subject: Re: uvcvideo Logitech patch
Date: Tue, 15 Dec 2009 22:15:19 +0100
Cc: laurent.pinchart@ideasonboard.com,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
References: <4B27DD88.3090900@tnode.com>
In-Reply-To: <4B27DD88.3090900@tnode.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912152215.21467.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 December 2009 20:03:36 Mitar wrote:
> Hi!
>
> I have Logitech QuickCam Pro 9000 webcam and I had the same problems
> described here:
>
> http://patchwork.kernel.org/patch/52261/
>
> I have applied the patch and it did not help. But it helped when I
> increased UVC_CTRL_CONTROL_TIMEOUT to 1000 and
> UVC_CTRL_STREAMING_TIMEOUT 5000. So 300 and 3000 values were not enough.
> I do not know if it was really necessary to increase
> UVC_CTRL_CONTROL_TIMEOUT or if it would be enough something between 3000
> and 5000 for UVC_CTRL_STREAMING_TIMEOUT as I did not have more time to
> test it.
>
> So maybe 5000 would be a good default for UVC_CTRL_STREAMING_TIMEOUT?
>
> I have been doing this on 2.6.30 amd64 system.
>
> Just to let you know. And thanks for the patch.
>
>
> Mitar

[Added UVC mailing lists to CC]


-- 
Ondrej Zary
