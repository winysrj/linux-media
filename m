Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57885 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2IEIb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 04:31:29 -0400
Received: by weyx8 with SMTP id x8so220187wey.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 01:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1209051028380.16676@axis700.grange>
References: <1345456164-12995-1-git-send-email-javier.martin@vista-silicon.com>
	<CACKLOr1HLSvvz8Bs_qgHuF1qjshwnsXqtcuS3q5uWmGhTkpxkg@mail.gmail.com>
	<Pine.LNX.4.64.1209051016360.16676@axis700.grange>
	<Pine.LNX.4.64.1209051028380.16676@axis700.grange>
Date: Wed, 5 Sep 2012 10:31:27 +0200
Message-ID: <CACKLOr375SAPS5y9z7HJ246_19esnW8yiMgjMM3zdEdE7zvK-Q@mail.gmail.com>
Subject: Re: [PATCH v3] media: mx2_camera: Don't modify non volatile
 parameters in try_fmt.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 September 2012 10:29, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Wed, 5 Sep 2012, Guennadi Liakhovetski wrote:
>
>> Hi Javier
>>
>> On Mon, 3 Sep 2012, javier Martin wrote:
>>
>> > Hi,
>> > Guennadi,did you pick this one?
>>
>> Wanted to do so, but
>
> I've applied this your patch with only that "memset()" line additionally
> removed. If this is ok with you, no need to re-send.

It's OK, thanks for fixing that for me.

Regards.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
