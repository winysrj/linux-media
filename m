Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:64360 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbdCMI77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 04:59:59 -0400
Subject: Re: [PATCH] v4l: soc-camera: Remove videobuf1 support
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170308153327.23954-1-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1703121300040.22698@axis700.grange>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <fcf1bcf3-12ca-262b-c161-3783ce8fc282@cisco.com>
Date: Mon, 13 Mar 2017 09:59:50 +0100
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1703121300040.22698@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/2017 01:06 PM, Guennadi Liakhovetski wrote:
> Hi Laurent,
>
> Thanks for the patch. I just checked in the current media/master, there
> are still 2 users of vb1: sh_mobile_ceu_camera.c and atmel-isi.c. I
> understand, that they are about to be removed either completely or out of
> soc-camera, maybe patches for that have already beed submitted, but they
> haven't been committed yet. Shall we wait until then with this patch?
> Would be easier to handle dependencies, there isn't any hurry with it,
> right?

????

Both drivers use vb2.

I've already added this patch to a pull request of mine.

Regards,

	Hans
