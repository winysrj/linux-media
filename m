Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab2HQWEL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 18:04:11 -0400
Message-ID: <502EBFC3.2090205@redhat.com>
Date: Fri, 17 Aug 2012 19:03:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: DRM/V4L2 buffer sharing
References: <502A4CD1.1020108@redhat.com> <23599424.KTEC3Hhc5D@avalon> <502BCA9F.4040603@gmail.com> <2376005.crkqt4XIze@avalon> <502EB10D.8050006@gmail.com>
In-Reply-To: <502EB10D.8050006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-08-2012 18:01, Sylwester Nawrocki escreveu:
> Hi Laurent,
> 
> On 08/15/2012 11:09 PM, Laurent Pinchart wrote:
>> On Wednesday 15 August 2012 18:13:19 Sylwester Nawrocki wrote:
>>> On 08/15/2012 12:06 AM, Laurent Pinchart wrote:
>>>> On Tuesday 14 August 2012 18:37:23 Sylwester Nawrocki wrote:
>>>>> On 08/14/2012 03:04 PM, Mauro Carvalho Chehab wrote:
>>>>>> This one requires more testing:
>>>>>>
>>>>>> May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API
>>>>>>            http://patchwork.linuxtv.org/patch/11268  Sylwester Nawrocki
>>>>>> <s.nawrocki@samsung.com>
>>>>>
>>>>> Hmm, this is not valid any more. Tomasz just posted a new patch series
>>>>> that adds DMABUF importer and exporter feature altogether.
>>>>>
>>>>> [PATCHv8 00/26] Integration of videobuf2 with DMABUF
>>>>>
>>>>> I guess we need someone else to submit test patches for other H/W than
>>>>> just Samsung SoCs. I'm not sure if we've got enough resources to port
>>>>> this to other hardware. We have been using these features internally for
>>>>> some time already. It's been 2 kernel releases and I can see only Ack
>>>>> tags from Laurent on Tomasz's patch series, hence it seems there is no
>>>>> wide interest in DMABUF support in V4L2 and this patch series is probably
>>>>> going to stay in a fridge for another few kernel releases.
>>>>
>>>> What would be required to push it to v3.7 ?
>>>
>>> Mauro requested more test coverage on that, which is understood since this
>>> is a fairly important API enhancement and the V4L2 video overlay API
>>> replacement.
>>>
>>> We need DMABUF support added at some webcam driver and a DRM driver with
>>> prime support (or some V4L2 output driver), I guess it would be best to
>>> have that in a PC environment. It looks like i915/radeon/nouveau drivers
>>> already have prime support.
>>
>> uvcvideo has recently been moved to videobuf2, using vb2_vmalloc. I can easily
>> test that, except that I have no idea how to export buffers on the i915 side
>> when X is running. Have you looked into that ?
> 
> All right. Yes, I'm also not sure yet how to do it. I tried it on a laptop 
> with i915 driver, but in the running system drmModeGetResources() just fails 
> with EPERM. I've CCed dri-devel, so hopefully someone can shed some light
> on this.

Likely, you need to run with root permission to use it, or to write an Xorg
driver.

It is probably easier to get the V4L driver there, that uses the VIDIOC_OVERLAY
stuff, and make it work via DMABUF:
	http://cgit.freedesktop.org/xorg/driver/xf86-video-v4l/

In order to test it, xawtv has already the code needed to talk with the v4l
plugin.

What the plugin does is to export the video board as a XV extension, accessible
via xawtv. It currently talks with the display card also via XV, but I believe it
won't be hard to port it to work with DMABUF.

As the interface between xawtv and the v4l plugin is just Xv, changing the code
there from VIDIOC_OVERLAY to DMABUF should be trivial.

Regards,
Mauro

