Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4630 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HLIrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 04:47:16 -0400
Message-ID: <5208A10E.5050804@xs4all.nl>
Date: Mon, 12 Aug 2013 10:47:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: baard.e.winther@wintherstormer.no
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH FINAL 0/6] qv4l2: cropping, optimization and documentatio
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård,

I've committed this patch series + the GeneralTab layout patch. I had to make
a small fix to the first cropping patch as it failed for drivers without the
CROPCAP ioctl, and I added a new patch fixing a resize/setFrame bug when going
from PAL to NTSC and back again.

The qv4l2 test bench utility is now much improved, and I would like thank you
for your work on qv4l2 during your Summer internship at Cisco Systems Norway!

For those who want to contact him, please use his private email and not the
cisco account as he no longer has access to that (and it will disappear soon
anyway).

Regards,

	Hans

On 08/09/2013 02:12 PM, Bård Eirik Winther wrote:
> qv4l2:
> 
> Add cropping to the CaptureWin. In order to make the Qt renderer work with
> this as well, it had to be optimized to not lose framerate.
> A basic manpage is added along width fixing the input parameters.
> 
> New Features/Improvements:
> - Add cropping to CaptureWin
> - Qt renderer has been optimized (no longer uses memcpy!)
> - Add a basic manpage
> - About window shows version number and ALSA/OpenGL support
> - Fix program parameters
> - Fix status hints for some missing GeneralTab elements
> - Code cleanup and fixes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

