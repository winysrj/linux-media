Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57561 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CKMSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 08:18:18 -0400
Received: by mail-wg0-f41.google.com with SMTP id ds1so1987977wgb.4
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 05:18:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com>
References: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com>
Date: Mon, 11 Mar 2013 13:18:12 +0100
Message-ID: <CACKLOr3ueVjDMf8zDmdJ=mYucczsDq4X2sbn0mRKz+hvZFTZZw@mail.gmail.com>
Subject: Re: omap3isp: iommu register problem.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just found the following thread where te problem is explained:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/086364.html

The problem is related with the order iommu and omap3isp are probed
when both are built-in. If I load omap3isp as a module the problem is
gone.

However, according to the previous thread, omap3isp register should
return error but an oops should not be generated. So I think there is
a bug here anyway.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
