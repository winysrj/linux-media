Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37471 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139AbbGVBTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 21:19:54 -0400
Received: by igbpg9 with SMTP id pg9so121497567igb.0
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 18:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150722004105.GD25644@verge.net.au>
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<20150722004105.GD25644@verge.net.au>
Date: Wed, 22 Jul 2015 04:19:53 +0300
Message-ID: <CALi4nhrJcDV6gLKVOtt8Y9CBqstAmg=HL5-60EQaem6gC4qhYA@mail.gmail.com>
Subject: Re: [PATCH 0/3] R-Car JPEG Processing Unit
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: Simon Horman <horms@verge.net.au>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"j.anaszewski" <j.anaszewski@samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

2015-07-22 3:41 GMT+03:00 Simon Horman <horms@verge.net.au>:
> Hi Mikhail,
>
> On Tue, Jul 21, 2015 at 05:00:19AM +0300, Mikhail Ulyanov wrote:
>> This series of patches contains a driver for the JPEG codec integrated
>> peripheral found in the Renesas R-Car SoCs and associated DT documentation.
>
> I am wondering if you have any plans to post patches to integrate this
> change on any Reneas boards - by which I mean patches to update dts and/or
> dtsi files. I would be very happy to see such patches submitted for review.
Yes, i have such plans. I suppose it was already (partially)reviewed.
https://www.marc.info/?l=linux-sh&m=140867246726948&w=4
As soon as driver patches will be accepted i will resubmit this patches.

-- 
W.B.R, Mikhail.
