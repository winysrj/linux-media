Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:36040 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1JANeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 09:34:10 -0400
Message-ID: <4E8716D1.9010104@mlbassoc.com>
Date: Sat, 01 Oct 2011 07:34:09 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-09-30 18:33, Javier Martinez Canillas wrote:
> Hello,
>
> The tvp5150 video decoder is usually used on a video pipeline with several
> video processing integrated circuits. So the driver has to be migrated to
> the new media device API to reflect this at the software level.
>
> Also the tvp5150 is able to detect what is the video standard at which
> the device is currently operating, so it makes sense to add video format
> detection in the driver as well as.
>
> This patch-set migrates the tvp5150 driver to the MCF and adds video format detection.
>

What is this patchset relative to?
Does it still handle the case of overscan? e.g. I typically capture from
an NTSC source using this device at 720x524.
Even if it does detect the signal shape (NTSC, PAL), doesn't one still need
to [externally] configure the pads for this shape?

Have you given any thought as to how the input (composite-A, composite-B or S-Video)
could be configured using the MCF?

Note: CC list trimmed to only the linux-media list.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
