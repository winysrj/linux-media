Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48081 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab2G3Mze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 08:55:34 -0400
Received: by yenl2 with SMTP id l2so4729612yen.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 05:55:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207201330240.27906@axis700.grange>
References: <1342083809-19921-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1207201330240.27906@axis700.grange>
Date: Mon, 30 Jul 2012 14:55:34 +0200
Message-ID: <CACKLOr2sKVWCk3we_cP5MvnR6-WsaFwA9AC=fgp3iLm8B6mfEA@mail.gmail.com>
Subject: Re: [PATCH] media: mx2_camera: Remove MX2_CAMERA_SWAP16 and
 MX2_CAMERA_PACK_DIR_MSB flags.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, mchehab@redhat.com,
	linux@arm.linux.org.uk, kernel@pengutronix.de,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
thank you for yor ACKs.

On 20 July 2012 13:31, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Thu, 12 Jul 2012, Javier Martin wrote:
>
>> These flags are not used any longer and can be safely removed
>> since the following patch:
>> http://www.spinics.net/lists/linux-media/msg50165.html
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>
> For the ARM tree:
>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

forgive my ignorance on the matter. Could you please point me to the
git repository this patch should be merged?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
