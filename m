Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55721 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbcKQL5n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 06:57:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Date: Thu, 17 Nov 2016 13:57:53 +0200
Message-ID: <2575917.39Nu28ZGiN@avalon>
In-Reply-To: <1479237536.506544.788777817.10BEA636@webmail.messagingengine.com>
References: <87h97achun.fsf@edgarthier.net> <4228838.ihduIDFkeB@avalon> <1479237536.506544.788777817.10BEA636@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

On Tuesday 15 Nov 2016 20:18:56 Edgar Thier wrote:
> Hi Laurent,
> 
> > Which device(s) support these formats ?
> 
> As mentioned in my last mail, I took the freedom and uploaded the lsusb
> -v output for 3 cameras with
> bayer 16-bit patterns. You can find them here:
> 
> dfk23up1300_16bitbayer_RG.lsusb:  http://pastebin.com/PDdY7rs0
> dfk23ux249_16bitbayer_GB.lsusb: http://pastebin.com/gtjF3Q2k
> dfk33ux250_16bitbayer_GR.lsusb: http://pastebin.com/Errz5UMr
> 
> All 3 are USB 3.0 industrial cameras by 'The Imaging Source'.

Thank you. I've added the cameras names to the commit message.

> > And could you please try to fix your e-mail client and/or server to avoid
> > corrupting patches ?
>
> I am not sure what is wrong but I will look into it.

Thanks. If it's on the server side there might not be much you'll be able to 
do, but it's always worth a shot.

-- 
Regards,

Laurent Pinchart

