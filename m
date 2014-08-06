Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35079 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaHFSkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 14:40:16 -0400
Received: by mail-la0-f54.google.com with SMTP id hz20so2661276lab.27
        for <linux-media@vger.kernel.org>; Wed, 06 Aug 2014 11:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407284947.78794.YahooMailNeo@web162403.mail.bf1.yahoo.com>
References: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com>
	<7469714.hULjr0WVDI@avalon>
	<CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
	<9468625.rMRWF7vSjZ@avalon>
	<CALFbYK3zxoYx4ypXiz3cLsMenvWhk0QUGni0g-hwpwh_HsgNGg@mail.gmail.com>
	<1407284947.78794.YahooMailNeo@web162403.mail.bf1.yahoo.com>
Date: Thu, 7 Aug 2014 00:10:14 +0530
Message-ID: <CALFbYK2BeYp0pX5R_w1tCSRS8Jc_C3wiy_VeCC=dqM0cXykzbg@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
To: Raymond Jender <rayj00@yahoo.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sre@debian.org" <sre@debian.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please send "unsubscribe linux-media" message with empty subject line
to majordomo@vger.kernel.org.

---------------------------------------------------------------------------------------
To: majordomo@vger.kernel.org
Subject:

unsubscribe linux-media
---------------------------------------------------------------------------------------

Regards,
Alagan

On Wed, Aug 6, 2014 at 5:59 AM, Raymond Jender <rayj00@yahoo.com> wrote:
> Why can't I get off this stinkin mail list?   The unsubscribe email does not work!
>
> Get me the heII off this list!
>
>
>
>
>
>
> On Tuesday, August 5, 2014 3:51 PM, alaganraj sandhanam <alaganraj.sandhanam@gmail.com> wrote:
>
>
>
> Thanks Laurent.
>
> Regards,
> Alagan
>
>
> On Wed, Aug 6, 2014 at 4:11 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Alagan,
>>
>> On Wednesday 06 August 2014 04:07:58 alaganraj sandhanam wrote:
>>> Hi Laurent,
>>>
>>> Thanks for the info. what about git://linuxtv.org/pinchartl/media.git
>>> omap3isp/dt branch?
>>> I took 3 patches from this branch, fixed
>>> error: implicit declaration of function ‘v4l2_of_get_next_endpoint’
>>> by changing to "of_graph_get_next_endpoint".
>>>
>>> while booting i'm getting below msg
>>> [    1.558471] of_graph_get_next_endpoint(): no port node found in
>>> /ocp/omap3_isp@480bc000
>>> [    1.567169] omap3isp 480bc000.omap3_isp: no port node at
>>> /ocp/omap3_isp@480bc000
>>>
>>> omap3isp/dt is not working branch?
>>
>> The branch contains work in progress patches. If I'm not mistaken the code
>> isn't complete and doesn't work yet.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
