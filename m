Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-xsmtp4.externet.hu ([212.40.96.155]:41081 "EHLO
	mail-xsmtp4.externet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:31:15 -0500
Message-ID: <4F1D8B51.4020507@gmail.com>
Date: Mon, 23 Jan 2012 17:31:13 +0100
From: Csillag Kristof <csillag.kristof@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: 720p webcam providing VDPAU-compatible video stream?
References: <4F1C0921.1060109@gmail.com> <201201231541.32049.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201231541.32049.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At 2012-01-23 15:41, Laurent Pinchart wrote:
> I think your best bet is still UVC + H.264, as that's what the market is
> moving to. Any other compressed format (except for MJPEG) will likely be
> proprietary.
>
> As you correctly mention, H.264 support isn't available yet in the UVC driver.
> Patches are welcome ;-)

So... do I understand it correctly that with the current hw/sw stack, my 
original requirements can not be satisfied?

In that case, let's try with reduced requirements. What if I give up HD 
resolution and H264?

Is there a camera that can provide a HW-compressed 480p video stream, in 
MPEG-2 or something like that?

Thank you:

    Kristof





