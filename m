Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40412 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbcCUTXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 15:23:52 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
 <56F038A0.1010004@xs4all.nl> <20160321152323.01e29553@recife.lan>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F04218.5040908@xs4all.nl>
Date: Mon, 21 Mar 2016 19:48:56 +0100
MIME-Version: 1.0
In-Reply-To: <20160321152323.01e29553@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 07:23 PM, Mauro Carvalho Chehab wrote:
>> Indeed. So a tvp5150 has three sink pads and one source pad (pixel port).
> 
> I would actually map tvp5150 with just one sink pad, with 3 links
> (one for each connector).
> 
> In other words, I'm mapping tvp5150 input mux via links, and the
> output of its mux as the sink pad.
> 
> IMHO, this works a way better than one sink pad per input at its
> internal mux.

You're right, that would work better for this specific device.

Regards,

	Hans

