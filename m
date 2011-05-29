Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56131 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1E2N1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 09:27:24 -0400
Received: by qyg14 with SMTP id 14so1594330qyg.19
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 06:27:23 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 29 May 2011 15:27:23 +0200
Message-ID: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
Subject: Capabilities of the Omap3 ISP driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Felix v. Hundelshausen" <felix.v.hundelshausen@live.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Laurent,

I'm on to a project that needs two synced separate small cameras for
stereovision. It's for harvesting tomatoes in fact :)

I was thinking about realizing this on an DM3730 with 2 aptina csi2
cameras that are used in snapshot mode. The questions that arise are:

- is the ISP driver capable of running 2 concurrent cameras?
- is it possible to simulate a kind of video stream that is externally
triggered (I would use a gpio line that simply triggers 10 times a
sec) or would there arise problems with the csi2 protocoll (timeouts
or similar)?

Best regards,

 Bastian Hecht
