Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62051 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab1KQKlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:41:07 -0500
Received: by vcbfk1 with SMTP id fk1so1485841vcb.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 02:41:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <006a01cc9e29$19da33c0$4d8e9b40$%szyprowski@samsung.com>
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
	<201111081501.00656.laurent.pinchart@ideasonboard.com>
	<004e01cc9e22$c1c0b390$45421ab0$%szyprowski@samsung.com>
	<201111081543.43122.laurent.pinchart@ideasonboard.com>
	<006a01cc9e29$19da33c0$4d8e9b40$%szyprowski@samsung.com>
Date: Thu, 17 Nov 2011 11:41:05 +0100
Message-ID: <CACKLOr2AnJtga7+vjUYQDbhzuZimX1iSHaW+rUVR+62iH_0JuA@mail.gmail.com>
Subject: Re: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
From: javier Martin <javier.martin@vista-silicon.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
what is the current status of this patch? Do you plan to send an
improved version?

I want to test it against my mem2mem driver I recently submitted
(emma-PrP) and a UVC camera in order to transform YUYV to YUV420.

Provided we ignore the locking  problems you have mentioned is it in a
'working' state?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
