Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61379 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2GKKCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:02:50 -0400
Received: by wibhr14 with SMTP id hr14so946663wib.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 03:02:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207111145.51858.hverkuil@xs4all.nl>
References: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
	<1341996904-22893-2-git-send-email-javier.martin@vista-silicon.com>
	<201207111145.51858.hverkuil@xs4all.nl>
Date: Wed, 11 Jul 2012 12:02:48 +0200
Message-ID: <CACKLOr1xgjuGp-jshCaCBZwG4pbWsBSt9Cq9jUdd3PGjpHiXEQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: Add mem2mem deinterlacing driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
thank you for your comments.

On 11 July 2012 11:45, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Javier!
>
> Thanks for the patch.
>
> On Wed 11 July 2012 10:55:03 Javier Martin wrote:
>> Some video decoders such as tvp5150 provide separate
>> video fields (V4L2_FIELD_SEQ_TB). This driver uses
>> dmaengine to convert this format to V4L2_FIELD_INTERLACED_TB
>> (weaving) or V4L2_FIELD_NONE (line doubling)
>
> Which field is used for the line doubling? Top or bottom? Or is each field
> doubled, thus doubling the framerate?

No, just top field is used.
I don't know if it's worth defining a new field format for doubling fields.

> I also recommend adding SEQ_BT/INTERLACED_BT support: NTSC transmits the bottom
> field first, so it is useful to have support for that.

Adding that is quite easy but I cannot test it.
Maybe someone could add it later?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
