Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1HQN2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 09:28:15 -0400
Message-ID: <4E4BC1DE.1060404@redhat.com>
Date: Wed, 17 Aug 2011 06:27:58 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com>  <201108161744.34749.laurent.pinchart@ideasonboard.com>  <4E4AF0FC.4070104@redhat.com>  <201108170957.15955.laurent.pinchart@ideasonboard.com>  <4E4BB330.7010506@redhat.com> <1313584678.14286.27.camel@iivanov-desktop>
In-Reply-To: <1313584678.14286.27.camel@iivanov-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-08-2011 05:37, Ivan T. Ivanov escreveu:
> 
> Hi everybody, 
> 
> On Wed, 2011-08-17 at 05:25 -0700, Mauro Carvalho Chehab wrote:
>> Em 17-08-2011 00:57, Laurent Pinchart escreveu:
>>> Hi Mauro,
>>>
>>> On Wednesday 17 August 2011 00:36:44 Mauro Carvalho Chehab wrote:
>>>> Em 16-08-2011 08:44, Laurent Pinchart escreveu:
>>>>> On Tuesday 16 August 2011 17:30:47 Mauro Carvalho Chehab wrote:
>>>>>> Em 16-08-2011 01:57, Laurent Pinchart escreveu:
>>>>> No. S_INPUT shouldn't be use to select between sensors. The hardware
>>>>> pipeline is more complex than just that. We can't make it all fit in the
>>>>> S_INPUT API.
>>>>>
>>>>> For instance, when switching between a b&w and a color sensor you will
>>>>> need to reconfigure the whole pipeline to select the right gamma table,
>>>>> white balance parameters, color conversion matrix, ... That's not
>>>>> something we want to hardcode in the kernel. This needs to be done from
>>>>> userspace.
>>>>
>>>> This is something that, if it is not written somehwere, no userspace
>>>> applications not developed by the hardware vendor will ever work.
>>>>
>>>> I don't see any code for that any at the kernel or at libv4l. Am I missing
>>>> something?
>>>
>>> Code for that needs to be written in libv4l. It's not there yet as I don't 
>>> think we have any hardware for this particular example at the moment :-)
>>>
>> As no pure V4L2 application would set the pipelines as you've said, and
>> no libv4l code exists yet, 
> 
> 
> Actually there is such code for OMAP3 ISP driver. Plug-in support in
> libv4l have been extended a little bit [1] and plugin-in which handle
> request for "regular" video device nodes /dev/video0 and /dev/video1
> and translate them to MC and sub-device API have been posted here [2],
> but is still not merged.
> 
> Regards, 
> iivanov
> 
> [1] http://www.spinics.net/lists/linux-media/msg35570.html
> [2] http://www.spinics.net/lists/linux-media/msg32539.html

Ah, ok. So, it is just the usual delay of having some features merged.

Hans G.,

FYI. Please review the OMAP3 MC-aware patches for libv4l when you have
some time for that.

Thanks!
Mauro


