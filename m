Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1LPJVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 04:21:31 -0500
Received: by wgbdr13 with SMTP id dr13so5864767wgb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 01:21:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112160909470.6572@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1112160909470.6572@axis700.grange>
Date: Fri, 16 Dec 2011 10:21:30 +0100
Message-ID: <CACKLOr0A=Ft9bVsLvo8_zX3nG8njnqd=PMG9fpWR2J1jZc-B3g@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, saaguirre@ti.com,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 December 2011 09:47, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> On Fri, 16 Dec 2011, Javier Martin wrote:
>
>> Some v4l-subdevs such as tvp5150 have multiple
>> inputs. This patch allows the user of a soc-camera
>> device to select between them.
>
> Sure, we can support it. But I've got a couple of remarks:
>
> First question: you probably also want to patch soc_camera_g_input() and
> soc_camera_enum_input(). But no, I do not know how. The video subdevice
> operations do not seem to provide a way to query subdevice routing
> capabilities, so, I've got no idea how we're supposed to support
> enum_input(). There is a g_input_status() method, but I'm not sure about
> its semantics. Would it return an error like -EINVAL on an unsupported
> index?

I would gladly implement also eum_input() and get_input() but I can't
test it since my device does not support "g_input_status" callback but
only "s_routing".

> Secondly, I would prefer to keep the current behaviour per default. I.e.,
> if the subdevice doesn't implement routing- / input-related operations, we
> should act as before - assume input 0 and return success.

Sure, it seems reasonable.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
