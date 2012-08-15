Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52908 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2HOQNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 12:13:24 -0400
Received: by bkwj10 with SMTP id j10so585734bkw.19
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:13:22 -0700 (PDT)
Message-ID: <502BCA9F.4040603@gmail.com>
Date: Wed, 15 Aug 2012 18:13:19 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com> <502A7EC3.7030803@samsung.com> <23599424.KTEC3Hhc5D@avalon>
In-Reply-To: <23599424.KTEC3Hhc5D@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/15/2012 12:06 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Tuesday 14 August 2012 18:37:23 Sylwester Nawrocki wrote:
>> On 08/14/2012 03:04 PM, Mauro Carvalho Chehab wrote:
>>> This one requires more testing:
>>>
>>> May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API
>>>           http://patchwork.linuxtv.org/patch/11268  Sylwester Nawrocki
>>> <s.nawrocki@samsung.com>
>> Hmm, this is not valid any more. Tomasz just posted a new patch series
>> that adds DMABUF importer and exporter feature altogether.
>>
>> [PATCHv8 00/26] Integration of videobuf2 with DMABUF
>>
>> I guess we need someone else to submit test patches for other H/W than just
>> Samsung SoCs. I'm not sure if we've got enough resources to port this to
>> other hardware. We have been using these features internally for some time
>> already. It's been 2 kernel releases and I can see only Ack tags from
>> Laurent on Tomasz's patch series, hence it seems there is no wide interest
>> in DMABUF support in V4L2 and this patch series is probably going to stay in
>> a fridge for another few kernel releases.
> 
> What would be required to push it to v3.7 ?

Mauro requested more test coverage on that, which is understood since 
this is a fairly important API enhancement and the V4L2 video overlay API 
replacement.

We need DMABUF support added at some webcam driver and a DRM driver with 
prime support (or some V4L2 output driver), I guess it would be best to 
have that in a PC environment. It looks like i915/radeon/nouveau drivers 
already have prime support.

The DRM driver could be an exporter of buffers that would be passed to
the webcam driver.

And except the kernel patches we would need a test application, similar
to that one: 
http://git.infradead.org/users/kmpark/public-apps/blob/a7e755629a74a7ac137882032a0f7b2480fa1490:/v4l2-drm-example/dmabuf-sharing.c

I haven't been closely following the DMABUF APIs development, I think
Tomasz could provide more details on that.

It's likely I'll get around and prepare a test case as outlined above
in coming days. Anyway, it would be appreciated if someone else could 
give this patch series a try.

--

Regards,
Sylwester
