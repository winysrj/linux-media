Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:52204 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLRRg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:36:28 -0500
Received: by mail-la0-f52.google.com with SMTP id hs14so1435318lab.11
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 09:36:27 -0800 (PST)
Message-ID: <54931098.30102@cogentembedded.com>
Date: Thu, 18 Dec 2014 20:36:24 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/5] media: rcar_vin: Fixes for buffer management
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
In-Reply-To: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/18/2014 05:47 PM, Ben Hutchings wrote:

> This is a re-submission of patches previously sent and archived at
> <http://thread.gmane.org/gmane.linux.ports.sh.devel/37184/>.  Will has
> rebased onto 3.18 and added a further patch to address Hans' review
> comments.

> The driver continues to works for single frame capture, and no longer
> provokes a WARNing.  However, video capture has regressed (a gstreamer
> capture pipeline yields a zero-length file).

> Ben.

> Ian Molton (4):
>    media: rcar_vin: Dont aggressively retire buffers
>    media: rcar_vin: Ensure all in-flight buffers are returned to error
>      state before stopping.
>    media: rcar_vin: Fix race condition terminating stream
>    media: rcar_vin: Clean up rcar_vin_irq

> William Towle (1):
>    media: rcar_vin: move buffer management to .stop_streaming handler

    Having actual fixes and clean-ups in a single series is not a good idea...

WBR, Sergei

