Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-relay48-hz2.antispameurope.com ([94.100.136.248]:49367 "EHLO
        mx-relay48-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755514AbeARK0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 05:26:55 -0500
Subject: Re: V4L2 v4l2_event_dequeue blocks forever when USB/UVC disconnects
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <f31e8344-75fc-c636-8e0e-b41954465e29@digitalendoscopy.de>
 <c1b2f8ed-c81a-3545-db28-8a0db57fdb8b@xs4all.nl>
From: Michael Walz <m.walz@digitalendoscopy.de>
Message-ID: <a29713e4-9c8f-007c-70c6-730853514358@digitalendoscopy.de>
Date: Thu, 18 Jan 2018 11:26:28 +0100
MIME-Version: 1.0
In-Reply-To: <c1b2f8ed-c81a-3545-db28-8a0db57fdb8b@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.01.2018 11:18, Hans Verkuil wrote:
> Are you able to compile the kernel if I give you a patch to test?
> 
> It should be a fairly easy fix.

Hi Hans,

I have a working yocto setup. Should be no problem to integrate the patch.

Thanks a lot and best regards,
Michael
