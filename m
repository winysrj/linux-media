Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.thermoteknix.com ([188.223.91.156]:49251 "EHLO
	mailgate.thermoteknix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403Ab1JELLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 07:11:06 -0400
Message-ID: <4E8C3595.3000702@thermoteknix.com>
Date: Wed, 05 Oct 2011 11:46:45 +0100
From: Adam Pledger <a.pledger@thermoteknix.com>
MIME-Version: 1.0
To: ebutera@users.berlios.de, gary@mlbassoc.com
CC: linux-media@vger.kernel.org
Subject: Re: Getting started with OMAP3 ISP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Tue, Sep 6, 2011 at 10:49 AM, Laurent Pinchart
> <laurent.pinch...@ideasonboard.com>  wrote:
> >  On Monday 05 September 2011 18:37:04 you wrote:
> >>  Yes that was the first thing i tried, anyway now i have it finally
> >>  working. Well at least yavta doesn't hang, do you know some
> >>  application to see raw yuv images?
>
> I made a typo since in fact it's uyvy ( so a tool to covert from yuv
> will not work ;) ), but if someone will ever need it:
>
> ffmpeg -f rawvideo -pix_fmt uyvy422 -s 720x628 -i frame-000001.bin frame-1.png
>
> Enrico

Enrico, Gary,

I am in an identical situation to you both in that I am migrating to a newer kernel and am faced with the task of getting a driver for the tvp5150 working with the new MC framework and omap3 ISP.
I understand from reading this thread that you have both had some success in modifying an existing / writing a driver and configuring a MC pipeline.
If you are able to share your driver(s) or any insights, I would be very grateful and I am happy to help out with further testing or polishing as required.

Best Regards

Adam

