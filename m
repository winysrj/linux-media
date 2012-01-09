Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55070 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2AILRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 06:17:54 -0500
Received: by wibhm6 with SMTP id hm6so2453310wib.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 03:17:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325494293-3968-1-git-send-email-javier.martin@vista-silicon.com>
References: <1325494293-3968-1-git-send-email-javier.martin@vista-silicon.com>
Date: Mon, 9 Jan 2012 12:17:53 +0100
Message-ID: <CACKLOr0W+_k7NaRpqwFHjXP99-4kr+diFt3SqHG_6FUpDdMqNw@mail.gmail.com>
Subject: Re: [PATCH] media i.MX27 camera: properly detect frame loss.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de, lethal@linux-sh.org,
	hans.verkuil@cisco.com, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
this is the patch I mentioned that fixes sequence count so that it
complies with v4l2 API.

Will you please merge?

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
