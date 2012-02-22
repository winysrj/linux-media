Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50368 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab2BVLCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 06:02:31 -0500
Received: by lagu2 with SMTP id u2so8842966lag.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 03:02:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329906876-10733-1-git-send-email-javier.martin@vista-silicon.com>
References: <1329906876-10733-1-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 22 Feb 2012 12:02:29 +0100
Message-ID: <CACKLOr1m5O5i7hCOAN-5XvnO=W=Vek8TAe3q7TKKu7w16BwH8w@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] media i.MX27 camera: handle overflows properly.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
when you apply this patch don't forget to update two patches from the
Clean up series which depend on this one:

[PATCH v2 2/6] media: i.MX27 camera: Use list_first_entry() whenever possible.
[PATCH v2 6/6] media: i.MX27 camera: more efficient discard buffer handling.

The other ones apply fine as they are.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
