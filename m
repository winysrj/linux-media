Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51085 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJCKZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Oct 2014 06:25:36 -0400
Received: by mail-ig0-f170.google.com with SMTP id l13so1069092iga.5
        for <linux-media@vger.kernel.org>; Fri, 03 Oct 2014 03:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=g6CXmLiW6VZwMFVDjKC8FtoPMPDPg7S37Czev+8YO+PA@mail.gmail.com>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
	<20140728185949.GS13730@pengutronix.de>
	<53D6BD8E.7000903@gmail.com>
	<CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
	<1407153257.3979.30.camel@paszta.hi.pengutronix.de>
	<CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>
	<53FDE9E1.2000108@mentor.com>
	<CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
	<540F2AC1.20700@gmail.com>
	<CAL8zT=g6CXmLiW6VZwMFVDjKC8FtoPMPDPg7S37Czev+8YO+PA@mail.gmail.com>
Date: Fri, 3 Oct 2014 12:25:35 +0200
Message-ID: <CAPW4HR036d271pC+rnqr9KVXn1o2-y=Tc73iBwf8CCeK79Qr2A@mail.gmail.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
From: =?UTF-8?Q?Carlos_Sanmart=C3=ADn_Bustos?= <carsanbu@gmail.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the resend, I forget send in plain text.
Hi all,

I'm interested in this driver with MC support too. I join the
conversation and if I have time can try to develop some functionality.

Only one question:

2014-10-02 16:50 GMT+02:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
>
> Hi Steve,
>
> 2014-09-09 18:28 GMT+02:00 Steve Longerbeam <slongerbeam@gmail.com>:
> > On 09/09/2014 12:49 AM, Jean-Michel Hautbois wrote:
> >> 2014-08-27 16:23 GMT+02:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
> >>
> >>> The complete driver I posted to the list does have some minor issues
> >>> mostly suggested by Hans Verkuil (switch to new selection API instead
> >>> of cropping API for example). It is a full featured driver but it does not
> >>> implement the media device framework, i.e. user does not have direct
> >>> control of the video pipeline, rather the driver chooses the pipeline based
> >>> on the traditional inputs from user (video format and controls).
>
> Here is my first step toward MC support from your work :
> https://github.com/Vodalys/linux-2.6-imx/commit/8f0318f53c48a9638a1963b395bc79fbd7ba4c07
>
> This is a WIP, so some parts of code are commented out awaiting a
> nicer solution.
> I also keep using your eplist array for the moment, and open will
> obviously fail when trying to power sensor.
> But what I wanted was a complete MC support with parsing links from DT
> and I used Laurent's work intensively :).
>

You are forking the Freescale linux-2.6-imx repository if I understood
well. Why not fork the linux-media repository? It's closer to mainline
kernel I think it's better.

Regards,
Carlos

2014-10-02 16:50 GMT+02:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
> Hi Steve,
>
> 2014-09-09 18:28 GMT+02:00 Steve Longerbeam <slongerbeam@gmail.com>:
>> On 09/09/2014 12:49 AM, Jean-Michel Hautbois wrote:
>>> 2014-08-27 16:23 GMT+02:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
>>>
>>>> The complete driver I posted to the list does have some minor issues
>>>> mostly suggested by Hans Verkuil (switch to new selection API instead
>>>> of cropping API for example). It is a full featured driver but it does not
>>>> implement the media device framework, i.e. user does not have direct
>>>> control of the video pipeline, rather the driver chooses the pipeline based
>>>> on the traditional inputs from user (video format and controls).
>
> Here is my first step toward MC support from your work :
> https://github.com/Vodalys/linux-2.6-imx/commit/8f0318f53c48a9638a1963b395bc79fbd7ba4c07
>
> This is a WIP, so some parts of code are commented out awaiting a
> nicer solution.
> I also keep using your eplist array for the moment, and open will
> obviously fail when trying to power sensor.
> But what I wanted was a complete MC support with parsing links from DT
> and I used Laurent's work intensively :).
>
>>>> I've also worked out what I think is a workable video pipeline graph for i.MX,
>>>> suitable for defining the entities, pads, and links. Unfortunately I haven't
>>>> been able to spend as much time as I'd like on it.
>
> Did you find some time to write the pdf you mentioned ?
>
> Thanks for your work again,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
