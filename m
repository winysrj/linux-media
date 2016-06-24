Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45293 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbcFXQUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 12:20:17 -0400
Subject: Re: [PATCH 01/24] v4l: Add metadata buffer type and format
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <fcc32004-82dd-45af-a737-019f81dea8e0@xs4all.nl>
Cc: linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a9c9ec51-15c3-675b-55cd-9b471b0ec20a@xs4all.nl>
Date: Fri, 24 Jun 2016 18:20:12 +0200
MIME-Version: 1.0
In-Reply-To: <fcc32004-82dd-45af-a737-019f81dea8e0@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/24/2016 05:57 PM, Hans Verkuil wrote:
> On 06/20/2016 09:10 PM, Laurent Pinchart wrote:
>> The metadata buffer type is used to transfer metadata between userspace
>> and kernelspace through a V4L2 buffers queue. It comes with a new
>> metadata capture capability and format description.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> I am willing to Ack this, provided Sakari and Guennadi Ack this as well. They know
> more about metadata handling in various types of hardware than I do, so I feel
> their Acks are important here.

Actually, I would like to see more about how applications can associate frames with
metadata (if such a correspondence exists).

There was an irc discussion about that here:

https://linuxtv.org/irc/irclogger_log/v4l?date=2016-06-24,Fri

Guennadi's uvc patches may be useful as a testbed for figuring this out.

Regards,

	Hans
