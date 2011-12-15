Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53794 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1LOKYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:24:52 -0500
Received: by wgbdr13 with SMTP id dr13so3807124wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 02:24:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE9C7FA.8070607@infradead.org>
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
	<4EE9C7FA.8070607@infradead.org>
Date: Thu, 15 Dec 2011 11:24:51 +0100
Message-ID: <CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Changing this could break em28xx that might be expecting it
> to be set to composite1. On a quick look, the code there seems to be
> doing the right thing: during the probe procedure, it explicitly
> calls s_routing, in order to initialize the device input to the
> first input type found at the cards structure. So, this patch
> is likely harmless.
>
> Yet, why do you need to change it? Any bridge driver that uses it should
> be doing the same: at initialization, it should set the input to a
> value that it is compatible with the way the device is wired, and not
> to assume a particular arrangement.

What I'm trying to do with these patches and my previous one related
to mx2_camera,
is to be able to use mx2_camera host driver with tvp5150 video decoder.

I'm not sure how mx2_camera could be aware that the sensor or decoder
attached to it
needs s_routing function to be called with a certain parameter without
making it too board specific.
The only solution I could think of was assuming that if s_routing
function was not called at all,
the enabled input in tvp5150 would be the default COMPOSITE0 as it is
specified in the datasheet.

However, If you or anyone suggests a cleaner approach I'm totally
open. But still, changing default
value of the selected input in tvp5150 probe function is a bit dirty IMHO.

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
