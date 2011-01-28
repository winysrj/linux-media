Return-path: <mchehab@pedra>
Received: from smtp4.Stanford.EDU ([171.67.219.84]:36375 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752986Ab1A1WT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 17:19:27 -0500
Message-ID: <4D434100.3020903@stanford.edu>
Date: Fri, 28 Jan 2011 14:19:44 -0800
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Neil MacMunn <neil@gumstix.com>
CC: linux-media@vger.kernel.org
Subject: Re: omap3-isp segfault
References: <4D4076C3.4080201@gumstix.com> <4D40CDB3.7090106@gumstix.com> <201101271328.05891.laurent.pinchart@ideasonboard.com> <4D41F54C.2030804@gumstix.com>
In-Reply-To: <4D41F54C.2030804@gumstix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 1/27/2011 2:44 PM, Neil MacMunn wrote:
> When I use media-ctl the pipeline gets configured properly. I can generate graphs before and after and see the pipeline change. However, my system hangs when I attempt to use yavta. I've also tried outputting to video4.
>
....
>
>
>
> Does anybody know how I can capture images from the camera? From previous posts it appears that I'm not the first to go through this process.
>
> Thanks. Neil

A few questions that would help to diagnose problems:
What version of the ISP drivers and the MT9V032 driver are you using? Kernel version?

You could try to force the format on the gst-launch command, as a further test, although I don't know why it's not matching up to the YUVY format you configured in the pipeline.

Eino-Ville Talvala
Stanford University

