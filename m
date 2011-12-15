Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37028 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1LOMBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:01:42 -0500
Received: by werm1 with SMTP id m1so70936wer.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 04:01:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE9DF50.20904@infradead.org>
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
	<4EE9C7FA.8070607@infradead.org>
	<CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com>
	<4EE9DF50.20904@infradead.org>
Date: Thu, 15 Dec 2011 13:01:40 +0100
Message-ID: <CACKLOr0KG9hS0a=qdYHfjrZzse2etbhPmCPpUjXwi5TLSqP5SA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The mx2_camera needs some code to forward calls to S_INPUT/S_ROUTING to
> tvp5150, in order to set the pipelines there.

This sounds like a sensible solution I will work on that soon.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
