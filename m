Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36710 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1LSHo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 02:44:59 -0500
Received: by wgbdr13 with SMTP id dr13so10181019wgb.1
        for <linux-media@vger.kernel.org>; Sun, 18 Dec 2011 23:44:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112190151.40165.laurent.pinchart@ideasonboard.com>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<CAHG8p1BLVgO1_vN+Wsk1R6awG+uAht1Z9w542naOO53XqVThOQ@mail.gmail.com>
	<Pine.LNX.4.64.1112161043280.6572@axis700.grange>
	<201112190151.40165.laurent.pinchart@ideasonboard.com>
Date: Mon, 19 Dec 2011 08:44:58 +0100
Message-ID: <CACKLOr3rTsiPsYK-hQBMo0wfHRqTNO95jdhXivvx6KUdCJBnnA@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
thank you for your comments.

Let me try to summarize the conclusions we've agreed here:
1.- soc-camera can support S_INPUT as long as I provide backwards
compatibility in case subdev does not support s_routing (i.e. I must
resend my patch returning input 0 in case s_routing is not supported).
2.- Board specific code must tell the subdevice which inputs are
really connected and how through platform data.

Is that OK?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
