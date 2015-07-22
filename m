Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46149 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbbGVBlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 21:41:00 -0400
Date: Wed, 22 Jul 2015 10:40:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
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
Subject: Re: [PATCH 0/3] R-Car JPEG Processing Unit
Message-ID: <20150722014056.GA28467@verge.net.au>
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <20150722004105.GD25644@verge.net.au>
 <CALi4nhrJcDV6gLKVOtt8Y9CBqstAmg=HL5-60EQaem6gC4qhYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALi4nhrJcDV6gLKVOtt8Y9CBqstAmg=HL5-60EQaem6gC4qhYA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

On Wed, Jul 22, 2015 at 04:19:53AM +0300, Mikhail Ulyanov wrote:
> Hi Simon,
> 
> 2015-07-22 3:41 GMT+03:00 Simon Horman <horms@verge.net.au>:
> > Hi Mikhail,
> >
> > On Tue, Jul 21, 2015 at 05:00:19AM +0300, Mikhail Ulyanov wrote:
> >> This series of patches contains a driver for the JPEG codec integrated
> >> peripheral found in the Renesas R-Car SoCs and associated DT documentation.
> >
> > I am wondering if you have any plans to post patches to integrate this
> > change on any Reneas boards - by which I mean patches to update dts and/or
> > dtsi files. I would be very happy to see such patches submitted for review.
> Yes, i have such plans. I suppose it was already (partially)reviewed.
> https://www.marc.info/?l=linux-sh&m=140867246726948&w=4
> As soon as driver patches will be accepted i will resubmit this patches.

Excellent. Sorry for forgetting about having seen the patch at the URL above.
