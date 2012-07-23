Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40565 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2GWL4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 07:56:50 -0400
Received: by wibhq12 with SMTP id hq12so2401008wib.1
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 04:56:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207231338.05141.hverkuil@xs4all.nl>
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
	<201207231338.05141.hverkuil@xs4all.nl>
Date: Mon, 23 Jul 2012 13:56:49 +0200
Message-ID: <CACKLOr14X3WsBov1caLJgt2m6Yk5ddp5-Ccq2bCZAkuDZ_1YDg@mail.gmail.com>
Subject: Re: [PATCH v7] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 July 2012 13:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon July 23 2012 13:31:01 Javier Martin wrote:
>> Coda is a range of video codecs from Chips&Media that
>> support H.264, H.263, MPEG4 and other video standards.
>>
>> Currently only support for the codadx6 included in the
>> i.MX27 SoC is added. H.264 and MPEG4 video encoding
>> are the only supported capabilities by now.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>> Changes since v6:
>>  - Cosmetic fixes pointed out by Sakari.
>>  - Now passes 'v4l2-compliance'.
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> Regards,
>
>         Hans

Thank you Hans.
Do you plan to make a new release of libv4l?

Sakari, Sylwester could I get an ack from you too?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
