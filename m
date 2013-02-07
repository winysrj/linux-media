Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41734 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab3BGN2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 08:28:51 -0500
Received: by mail-ie0-f178.google.com with SMTP id c13so3397377ieb.37
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 05:28:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360238951-7022-1-git-send-email-rahul.sharma@samsung.com>
References: <1360238951-7022-1-git-send-email-rahul.sharma@samsung.com>
Date: Thu, 7 Feb 2013 14:28:48 +0100
Message-ID: <CAKMK7uFQg8Wsibz8T0VBB8yJf3P=yTbRhhH3pTTGGxiYZo8dfA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] drm/edid: temporarily exposing generic
 edid-read interface from drm
From: Daniel Vetter <daniel@ffwll.ch>
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	alsa-devel@alsa-project.org, linux-fbdev@vger.kernel.org,
	broonie@opensource.wolfsonmicro.com, joshi@samsung.com,
	kyungmin.park@samsung.com, tomi.valkeinen@ti.com,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 7, 2013 at 1:09 PM, Rahul Sharma <rahul.sharma@samsung.com> wrote:
> It exposes generic interface from drm_edid.c to get the edid data and length
> by any display entity. Once I get clear idea about edid handling in CDF, I need
> to revert these temporary changes.

Just a quick reply about edid reading: One of the key results (at
least imo) of the fosdem cdf discussion was that we need to split up
the different parts of it clearly (i.e. abstract panel interface, dsi
support, discovery/dev matching, ...) to have more flexibility. One
idea is also to not use the panel interface for e.g. hdmi transcoders,
but only use the bus support (like dsi), since transcoders which
connect to external devices like hdmi need to expose _much_ more
features to the master driver and so it's better to have tighter
integration. Some of the things which need close cooperation between
drivers are e.g. edid reading, hotplug handling,
bpp/colorspace/restricted range stuff, ... I didn't read through the
patch which requires the exported drm edid stuff, but maybe this helps
a bit.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
