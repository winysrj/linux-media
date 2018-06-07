Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51328 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752880AbeFGHWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Jun 2018 03:22:00 -0400
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Tomasz Figa <tfiga@chromium.org>
Cc: LMML <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
 <20180605103328.176255-2-tfiga@chromium.org>
 <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b767d9d7-5a26-f6f8-3978-81e8d60769c2@xs4all.nl>
Date: Thu, 7 Jun 2018 09:21:49 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcOJ5Q2rHqGEmcStxxXj423a3ddKOSzvwRV6R5-UxhM+Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2018 03:10 PM, Dave Stevenson wrote:
> Hi Tomasz.
> 
> Thanks for formalising this.
> I'm working on a stateful V4L2 codec driver on the Raspberry Pi and
> was having to deduce various implementation details from other
> drivers. I know how much we all tend to hate having to write
> documentation, but it is useful to have.
> 
> On 5 June 2018 at 11:33, Tomasz Figa <tfiga@chromium.org> wrote:
>> Due to complexity of the video decoding process, the V4L2 drivers of
>> stateful decoder hardware require specific sequencies of V4L2 API calls
>> to be followed. These include capability enumeration, initialization,
>> decoding, seek, pause, dynamic resolution change, flush and end of
>> stream.
>>
>> Specifics of the above have been discussed during Media Workshops at
>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
>> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
>> originated at those events was later implemented by the drivers we already
>> have merged in mainline, such as s5p-mfc or mtk-vcodec.
>>
>> The only thing missing was the real specification included as a part of
>> Linux Media documentation. Fix it now and document the decoder part of
>> the Codec API.
>>
>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>> ---
>>  Documentation/media/uapi/v4l/dev-codec.rst | 771 +++++++++++++++++++++
>>  Documentation/media/uapi/v4l/v4l2.rst      |  14 +-
>>  2 files changed, 784 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
>> index c61e938bd8dc..0483b10c205e 100644
>> --- a/Documentation/media/uapi/v4l/dev-codec.rst
>> +++ b/Documentation/media/uapi/v4l/dev-codec.rst
>> @@ -34,3 +34,774 @@ the codec and reprogram it whenever another file handler gets access.
>>  This is different from the usual video node behavior where the video
>>  properties are global to the device (i.e. changing something through one
>>  file handle is visible through another file handle).
> 
> I know this isn't part of the changes, but raises a question in
> v4l2-compliance (so probably one for Hans).
> testUnlimitedOpens tries opening the device 100 times. On a normal
> device this isn't a significant overhead, but when you're allocating
> resources on a per instance basis it quickly adds up.
> Internally I have state that has a limit of 64 codec instances (either
> encode or decode), so either I allocate at start_streaming and fail on
> the 65th one, or I fail on open. I generally take the view that
> failing early is a good thing.
> Opinions? Is 100 instances of an M2M device really sensible?

Resources should not be allocated by the driver until needed (i.e. the
queue_setup op is a good place for that).

It is perfectly legal to open a video node just to call QUERYCAP to
see what it is, and I don't expect that to allocate any hardware resources.
And if I want to open it 100 times, then that should just work.

It is *always* wrong to limit the number of open arbitrarily.

Regards,

	Hans
