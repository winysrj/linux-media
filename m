Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63615 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2A3JHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 04:07:48 -0500
Received: by wics10 with SMTP id s10so3201125wic.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 01:07:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201270952250.32661@axis700.grange>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201270952250.32661@axis700.grange>
Date: Mon, 30 Jan 2012 10:07:44 +0100
Message-ID: <CACKLOr3ewaB_H3WOgXLoY4VkaCXdYRFpapNKOaOm-CVVNNmNMw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] media i.MX27 camera: migrate driver to videobuf2
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
thank you for your time.

On 27 January 2012 16:25, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> A general question for mx2-camera: does it now after removal of legacy
> i.MX27 support only support i.MX25 (state: unknown) and i.MX27 in eMMA
> mode?

I understand so.

I'll send a v3 of this patch fixing what you've pointed out.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
