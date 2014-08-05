Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59345 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaHEWuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 18:50:06 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so1298067lbi.29
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 15:50:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9468625.rMRWF7vSjZ@avalon>
References: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com>
	<7469714.hULjr0WVDI@avalon>
	<CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
	<9468625.rMRWF7vSjZ@avalon>
Date: Wed, 6 Aug 2014 04:20:04 +0530
Message-ID: <CALFbYK3zxoYx4ypXiz3cLsMenvWhk0QUGni0g-hwpwh_HsgNGg@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: alaganraj sandhanam <alaganraj.sandhanam@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sre@debian.org, sakari.ailus@iki.fi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Laurent.

Regards,
Alagan

On Wed, Aug 6, 2014 at 4:11 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Alagan,
>
> On Wednesday 06 August 2014 04:07:58 alaganraj sandhanam wrote:
>> Hi Laurent,
>>
>> Thanks for the info. what about git://linuxtv.org/pinchartl/media.git
>> omap3isp/dt branch?
>> I took 3 patches from this branch, fixed
>> error: implicit declaration of function ‘v4l2_of_get_next_endpoint’
>> by changing to "of_graph_get_next_endpoint".
>>
>> while booting i'm getting below msg
>> [    1.558471] of_graph_get_next_endpoint(): no port node found in
>> /ocp/omap3_isp@480bc000
>> [    1.567169] omap3isp 480bc000.omap3_isp: no port node at
>> /ocp/omap3_isp@480bc000
>>
>> omap3isp/dt is not working branch?
>
> The branch contains work in progress patches. If I'm not mistaken the code
> isn't complete and doesn't work yet.
>
> --
> Regards,
>
> Laurent Pinchart
>
