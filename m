Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49069 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0HXNkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 09:40:05 -0400
Received: by pvg2 with SMTP id 2so2636621pvg.19
        for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 06:40:05 -0700 (PDT)
Message-ID: <4C73CBB1.4090605@brooks.nu>
Date: Tue, 24 Aug 2010 07:40:01 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Subject: OMAP ISP and Overlay
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

  Laurent,

So far I have the everything working with the OMAP ISP to where I can 
stream video on our custom board. On a previous generation of hardware 
with a completely different processor and sensor, we used the V4L2 
overlay feature to stream directly to our LCD for preview. I am 
wondering what the plans are for overlay support in the omap ISP? How 
does the overlay feature fit into the new media bus feature?

Thanks,
Lane
