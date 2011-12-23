Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40518 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1LWKtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 05:49:52 -0500
Received: by wgbds13 with SMTP id ds13so13395427wgb.1
        for <linux-media@vger.kernel.org>; Fri, 23 Dec 2011 02:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112231006200.1911@axis700.grange>
References: <1324566720-14073-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1112221652110.13700@axis700.grange>
	<CACKLOr3DmazqCtV_wSNYRYMwboNWRxy11n_mX6S-i4DVToPv8Q@mail.gmail.com>
	<Pine.LNX.4.64.1112231006200.1911@axis700.grange>
Date: Fri, 23 Dec 2011 11:49:51 +0100
Message-ID: <CACKLOr2MJre2mV24SLLMK6aLvMVCWCWCGePbTa+4Fh7RLQsDhw@mail.gmail.com>
Subject: Re: [PATCH v2] media i.MX27 camera: Fix field_count handling.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 December 2011 10:07, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 23 Dec 2011, javier Martin wrote:
>
>> Hi Guennadi,
>> thank you for your comments.
>>
>> On 23 December 2011 00:17, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> > On Thu, 22 Dec 2011, Javier Martin wrote:
>> >
>> >> To properly detect frame loss the driver must keep
>> >> track of a frame_count.
>> >>
>> >> Furthermore, field_count use was erroneous because
>> >> in progressive format this must be incremented twice.
>> >
>> > Hm, sorry, why this? I just looked at vivi.c - the version before
>> > videobuf2 conversion - and it seems to only increment the count by one.
>>
>> If you look at the videobuf-core code you'll notice that the value
>> assigned to v4l2_buf sequence field is (field_count >> 1):
>
> Right, i.e., field-count / 2. So, it really only counts _frames_, not
> fields, doesn't it?
>

Yes, v4l2_buf sequence field counts _frames_ but field_count counts
_fields_, that's why I increment field-count twice in my driver.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
