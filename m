Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3051 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbaIIHxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 03:53:22 -0400
Message-ID: <540EB1A8.9080804@xs4all.nl>
Date: Tue, 09 Sep 2014 09:52:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com> <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com> <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com> <1407153257.3979.30.camel@paszta.hi.pengutronix.de> <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com> <53FDE9E1.2000108@mentor.com> <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
In-Reply-To: <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/14 09:49, Jean-Michel Hautbois wrote:
> 2014-08-27 16:23 GMT+02:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
> 
>> Hi Jean-Michel, Phillip,
> 
> Hi Steve,
> 
>> I've done some work on Philipp's June 12 patchset, converting
>> the CSI driver to a CSI subdev entity, and fixing some issues here
>> and there. This June 12 patchset doesn't appear to be a fully working
>> driver, Phillip correct me if I am wrong. I can post this work as it
>> exists, it is incomplete but compiles.
> 
> Dos it compile against a 3.17-rc3 kernel :) ?
> 
>> I've also worked out what I think is a workable video pipeline graph for i.MX,
>> suitable for defining the entities, pads, and links. Unfortunately I haven't
>> been able to spend as much time as I'd like on it.
> 
> This is very interesting, do you have written this somewhere ?
> 
>> The complete driver I posted to the list does have some minor issues
>> mostly suggested by Hans Verkuil (switch to new selection API instead
>> of cropping API for example). It is a full featured driver but it does not
>> implement the media device framework, i.e. user does not have direct
>> control of the video pipeline, rather the driver chooses the pipeline based
>> on the traditional inputs from user (video format and controls).
>>
>> If there is interest I can submit another version of the traditional driver
>> to resolve the issues. But media device is a major rework, so I don't
>> know whether it would make sense to start from the traditional driver
>> and then implement media device on top later, since media device
>> is almost a complete rewrite.
> 
> I, at least, am interested by this driver, even in its "traditionnal"
> form :). If you don't want to submit it directly because this is not
> using media controller, this is ok, you can provide me a git repo in
> order to get it, or send a patchset.

Is it possible to create a staging driver? Even if there are bits missing,
having the code in the kernel as a staging driver would help a lot.

Regards,

	Hans
