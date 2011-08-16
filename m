Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1HPPHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 11:07:36 -0400
Message-ID: <4E4A87A5.9020604@redhat.com>
Date: Tue, 16 Aug 2011 08:07:17 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <201108151445.38650.laurent.pinchart@ideasonboard.com> <4E49B7F5.4010609@redhat.com> <201108161059.12300.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108161059.12300.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-08-2011 01:59, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Tuesday 16 August 2011 02:21:09 Mauro Carvalho Chehab wrote:
>> Em 15-08-2011 05:45, Laurent Pinchart escreveu:
>>>> After having it there properly working and tested independently, we may
>>>> consider patches removing V4L2 interfaces that were obsoleted in favor
>>>> of using the libv4l implementation, of course using the Kernel way of
>>>> deprecating interfaces. But doing it before having it, doesn't make any
>>>> sense.
>>>
>>> Once again we're not trying to remove controls, but expose them
>>> differently.
>>
>> See the comments at the patch series, starting from the patches that
>> removes support for S_INPUT. I'm aware that the controls will be exposed
>> by both MC and V4L2 API, althrough having ways to expose/hide controls via
>> V4L2 API makes patch review a way more complicated than it used to be
>> before the MC patches.
> 
> The MC API doesn't expose controls. Controls are still exposed by the V4L2 API 
> only, but V4L2 can then expose them on subdev nodes in addition to video 
> nodes.

To be clear, when I'm talking about MC, I'm meaning also the subdev nodes API,
as a pure V4L2 api application doesn't know anything about them.

Regards,
Mauro
