Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36328 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742Ab1LOJsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:48:39 -0500
Received: by vbbfc26 with SMTP id fc26so1355547vbb.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 01:48:39 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 17:48:39 +0800
Message-ID: <CAHG8p1A93tTu9Nz1s9ngDrMCRC98A3RVecYFSsrEHsU-zr_b2A@mail.gmail.com>
Subject: v4l: How bridge driver get subdev std?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Guennadi,

I'm wondering how does bridge driver get subdev std (not query)?
My case is that bridge needs to get subdev default std.

Regards,
Scott
