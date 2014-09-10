Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:59935 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaIJQIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 12:08:30 -0400
Received: by mail-oi0-f51.google.com with SMTP id e131so4688707oig.10
        for <linux-media@vger.kernel.org>; Wed, 10 Sep 2014 09:08:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540F2AC1.20700@gmail.com>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
 <1407153257.3979.30.camel@paszta.hi.pengutronix.de> <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>
 <53FDE9E1.2000108@mentor.com> <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
 <540F2AC1.20700@gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 10 Sep 2014 18:08:15 +0200
Message-ID: <CAL8zT=h+=4_iUiTLwc0LKUa2ug7qRouQsc7jso0N4ynn1qffTQ@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-09-09 18:28 GMT+02:00 Steve Longerbeam <slongerbeam@gmail.com>:
> On 09/09/2014 12:49 AM, Jean-Michel Hautbois wrote:
>> 2014-08-27 16:23 GMT+02:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
>>
>>> The complete driver I posted to the list does have some minor issues
>>> mostly suggested by Hans Verkuil (switch to new selection API instead
>>> of cropping API for example). It is a full featured driver but it does not
>>> implement the media device framework, i.e. user does not have direct
>>> control of the video pipeline, rather the driver chooses the pipeline based
>>> on the traditional inputs from user (video format and controls).
>>>
>>> If there is interest I can submit another version of the traditional driver
>>> to resolve the issues. But media device is a major rework, so I don't
>>> know whether it would make sense to start from the traditional driver
>>> and then implement media device on top later, since media device
>>> is almost a complete rewrite.
>> I, at least, am interested by this driver, even in its "traditionnal"
>> form :). If you don't want to submit it directly because this is not
>> using media controller, this is ok, you can provide me a git repo in
>> order to get it, or send a patchset.
>
> Hi Jean-Michel, I forgot to mention I will be working on the staging
> capture driver in a copy of the media-tree on github at:
>
> git@github.com:slongerbeam/mediatree.git
>

I took your mx6-camera-staging branch and merger it, but compile fails :
drivers/staging/media/imx6/capture/mx6-vdic.c:815:2: error: implicit
declaration of function 'ipu_mbus_code_to_fourcc'

Maybe isn't it ready yet ? I always want to go faster than music... :)

Thanks,
JM
