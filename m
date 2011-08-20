Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55577 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1HTL1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:27:12 -0400
Received: by ewy4 with SMTP id 4so1394467ewy.19
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2011 04:27:11 -0700 (PDT)
Message-ID: <4E4F9A0B.4050302@gmail.com>
Date: Sat, 20 Aug 2011 13:27:07 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Embedded device and the  V4L2 API support - Was: [GIT PATCHES
 FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <201108151430.42722.laurent.pinchart@ideasonboard.com> <4E49B60C.4060506@redhat.com> <201108161057.57875.laurent.pinchart@ideasonboard.com> <4E4A8D27.1040602@redhat.com> <4E4AE583.6050308@gmail.com> <4E4B5C27.3000008@redhat.com>
In-Reply-To: <4E4B5C27.3000008@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/17/2011 08:13 AM, Mauro Carvalho Chehab wrote:
> It seems that there are too many miss understandings or maybe we're just
> talking the same thing on different ways.
> 
> So, instead of answering again, let's re-start this discussion on a
> different way.
> 
> One of the requirements that it was discussed a lot on both mailing
> lists and on the Media Controllers meetings that we had (or, at least
> in the ones where I've participated) is that:
> 
> 	"A pure V4L2 userspace application, knowing about video device
> 	 nodes only, can still use the driver. Not all advanced features
> 	 will be available."

What does a term "a pure V4L2 userspace application" mean here ?
Does it also account an application which is linked to libv4l2 and uses
calls specific to a particular hardware which are included there?

> 
> This is easily said than done. Also, different understandings can be
> obtained by a simple phrase like that.

--
Regards,
Sylwester
