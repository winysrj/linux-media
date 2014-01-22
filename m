Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2719 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaAVXNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 18:13:10 -0500
Message-ID: <52E0507D.1060103@xs4all.nl>
Date: Thu, 23 Jan 2014 00:13:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Detlev Casanova <detlev.casanova@gmail.com>,
	linux-media@vger.kernel.org, hyun.kwon@xilinx.com
Subject: Re: qv4l2 and media controller support
References: <2270106.dN7Lhra68Q@avalon>
In-Reply-To: <2270106.dN7Lhra68Q@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

First, regarding the inheritance of subdev controls: I found it annoying as
well that there is no way to do this. If you have a simple video pipeline,
then having to create subdev nodes just to set a few controls is unnecessary
complex. I've been thinking of adding a flag to the control handler that, when
set, will 'import' the private controls. The bridge driver is the one that sets
this as that is the only one that knows whether or not it is in fact a simple
pipeline.

Secondly, I'd love to add MC support to qv4l2. But I'm waiting for you to merge
the MC library into v4l-utils.git. It's basically the reason why I haven't looked
at this at all.

Regards,

	Hans

On 01/22/2014 11:55 PM, Laurent Pinchart wrote:
> Hi Hans and Detlev,
> 
> While reviewed driver code that models the hardware using the media 
> controller, I noticed a patch that enabled subdev controls inheritance for the 
> video nodes. While this is useful for fixed devices, the complexity, 
> genericity and flexibility of the hardware at hand makes this undesirable, 
> given that we can't guarantee that a control won't be instantiated more than 
> once in the pipeline.
> 
> I've thus asked what triggered the need for controls inheritance, and found 
> out that the developers wanted to use qv4l2 as a demo application 
> (congratulations to Hans for such a useful application :-)). As qv4l2 doesn't 
> support subdevices, accessing controls required inheriting them on video 
> nodes.
> 
> There's an existing GUI test application for media controller-based devices 
> called mci (https://gitorious.org/mci) but it hasn't been maintained for quite 
> some time, and isn't as feature-complete as qv4l2. I was thus wondering 
> whether it would make sense to add explicit media controller support to qv4l2, 
> or whether the two applications should remain separate (in the later case some 
> code could probably still be shared).
> 
> Any opinion and/or desire to work on this ?
> 

