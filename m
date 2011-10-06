Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab1JFNNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 09:13:38 -0400
Message-ID: <4E8DA979.2020703@infradead.org>
Date: Thu, 06 Oct 2011 10:13:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <201110060923.14797.hverkuil@xs4all.nl> <4E8D9633.5040303@infradead.org> <201110061406.13117.hverkuil@xs4all.nl>
In-Reply-To: <201110061406.13117.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 09:06, Hans Verkuil escreveu:
> On Thursday 06 October 2011 13:51:15 Mauro Carvalho Chehab wrote:
>> Em 06-10-2011 04:23, Hans Verkuil escreveu:
>>> On Thursday, October 06, 2011 09:09:26 Hans Verkuil wrote:
>>>> On Thursday, October 06, 2011 02:32:33 Mauro Carvalho Chehab wrote:
>>>>> Also, I couldn't see a consense about input selection on drivers that
>>>>> implement MC: they could either implement S_INPUT, create one V4L
>>>>> device node for each input, or create just one devnode and let
>>>>> userspace (somehow) to discover the valid inputs and set the pipelines
>>>>> via MC/pad.
>>>>
>>>> I don't follow. I haven't seen any MC driver yet that uses S_INPUT as
>>>> that generally doesn't make sense. But for a device like tvp5150 we
>>>> probably need it since the tvp5150 has multiple inputs. This is
>>>> actually an interesting challenge how to implement this as this is
>>>> platform-level knowledge. I suspect that the only way to do this that
>>>> is sufficiently generic is to model this with MC links.
>>
>> $ git grep s_input drivers/media/video/s5p-*
>> drivers/media/video/s5p-fimc/fimc-capture.c:      .vidioc_s_input
>>        = fimc_cap_s_input,
>>
>> The current code does nothing, but take a look at what was there before
>> changeset 3e002182.
>>
>>   From the discussions we had at the pull request that s_input code were
>> being changed/removed, It became clear to me that omap3 drivers took one
>> direction, and s5p drivers took another direction, in terms on how to
>> associate the V4L2 device nodes with the IP blocks.
>
>  From what I remember the s5p drivers converged/are converging on the same
> approach as omap3. I don't believe there is any discussion anymore on what is
> the correct method.

With also doesn't support generic apps. Not sure if this is an improvement.

Two drivers fully following the API specs can use different and incompatible
approaches from the POV of an userspace application, as now there are several
different ways of implementing the very same thing, and those SoC drivers
are not doing what was agreed when we decided to add the MC API: properly implement
the V4L2 API, to allow existing applications to use them.

>>>> All these libraries are on Laurent's site. Can we please move it to
>>>> linuxtv?
>>
>> Yes, please.
>>
>>>> Mauro, wouldn't it be a good idea to create a media-utils.git and merge
>>>> v4l-utils, dvb-apps and these new media utils/libs in there?
>>
>> I like that idea. I remember that some dvb people argued against when we
>> first come to it, but I think that merging both is the right thing to do.
>>
>> In any case, libmediactl/libv4l2subdev should, IMHO, be part of the
>> v4l-utils.
>>
>> I suggest to open a separate thread for this subject.
>>
>> For stable distros, merging packages are painful, as their policies may
>> forbid package source removal. So, maybe it makes sense to have something
>> like: "./configure --disable-[feature]" in order to allow them to keep
>> maintaining separate sources for separate parts of a media-utils tree.
>> That also means that a "--disable-libv4l" would force libv4l-aware
>> applications to be built statically linked.
>
> Seems very complicated to me. But I'll start a separate thread for this.

It is not that complicated, but it will require some time for doing that. Autoconf
stripts are capable of doing things like that, but time is required to add
those patches into it.

>
> ...
>
>>>> Whether or not you include a scaler in the default pipeline is optional
>>>> as far as I am concerned.
>>
>> I think that such default pipeline should include a scaler, especially if
>> the sensor(s)/demod(s) on such pipeline don't have it.
>
> That would be the ideal situation, yes, but for now I'd be happy just to get a
> picture out of an SoC :-)

:)

Mauro
