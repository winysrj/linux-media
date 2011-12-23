Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47484 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1LWHyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 02:54:55 -0500
Received: by wibhm6 with SMTP id hm6so2982200wib.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 23:54:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112221652110.13700@axis700.grange>
References: <1324566720-14073-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1112221652110.13700@axis700.grange>
Date: Fri, 23 Dec 2011 08:54:53 +0100
Message-ID: <CACKLOr3DmazqCtV_wSNYRYMwboNWRxy11n_mX6S-i4DVToPv8Q@mail.gmail.com>
Subject: Re: [PATCH v2] media i.MX27 camera: Fix field_count handling.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
thank you for your comments.

On 23 December 2011 00:17, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Thu, 22 Dec 2011, Javier Martin wrote:
>
>> To properly detect frame loss the driver must keep
>> track of a frame_count.
>>
>> Furthermore, field_count use was erroneous because
>> in progressive format this must be incremented twice.
>
> Hm, sorry, why this? I just looked at vivi.c - the version before
> videobuf2 conversion - and it seems to only increment the count by one.

If you look at the videobuf-core code you'll notice that the value
assigned to v4l2_buf sequence field is (field_count >> 1):
http://lxr.linux.no/#linux+v3.1.6/drivers/media/video/videobuf-core.c#L370

Since mx2_camera driver only supports video formats which are either
progressive or provide both fields in the same buffer, this
"field_count" must be incremented twice so that the final sequence
number is OK.

>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/mx2_camera.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index ea1f4dc..ca76dd2 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -255,6 +255,7 @@ struct mx2_camera_dev {
>>       dma_addr_t              discard_buffer_dma;
>>       size_t                  discard_size;
>>       struct mx2_fmt_cfg      *emma_prp;
>> +     u32                     frame_count;
>
> The rule I usually follow, when choosing variable type is the following:
> does it really have to be fixed bit-width? The positive reply is pretty
> rare, it comes mostly if (a) the variable is used to store values read
> from or written to some (fixed-width) hardware registers, or (b) the
> variable belongs to a fixed ABI, that has to be the same on different
> (32-bit, 64-bit) systems, like (arguably) ioctl()s, data, transferred over
> the network or stored on a medium (filesystems,...). This doesn't seem to
> be the case here, so, I would just use an (unsigned) int.

Thanks for the tip. I hadn't thought of it that way. I just saw that
v4l2_buf.sequence was a __u32 and I thought it was convenient to use
the same type for this variable which is closely related to it

Anyway, let me send a second version of the patch since I've just
noticed this one doesn't reflect lost frames in the field_count field.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
