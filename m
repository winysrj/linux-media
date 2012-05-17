Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41344 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2EQCqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 22:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202201633100.2836@axis700.grange>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
	<1654816.MX2JJ87BEo@avalon>
	<1775349.d0yvHiVdjB@avalon>
	<20120217095554.GA5511@phenom.ffwll.local>
	<Pine.LNX.4.64.1202201633100.2836@axis700.grange>
Date: Thu, 17 May 2012 10:46:37 +0800
Message-ID: <CAGA24M+OEwi-ayBrXcMPg5PzndRF4mSr2dOOQAxhDCu6ShZLjQ@mail.gmail.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
From: Jun Nie <niej0001@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

    Is there any discussion on HDCP on the summit? It is tightly
coupled with HDMI and DVI and should be managed together with the
transmitter. But there is not code to handle HDCP in DRM/FB/V4L in
latest kernel. Any thoughts on HDCP? Or you guys think there is risk
to support it in kernel? Thanks for your comments!

Jun
