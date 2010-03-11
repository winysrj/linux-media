Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35806.mail.mud.yahoo.com ([66.163.179.175]:30352 "HELO
	web35806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755321Ab0CKDux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 22:50:53 -0500
Message-ID: <977150.88015.qm@web35806.mail.mud.yahoo.com>
Date: Wed, 10 Mar 2010 19:50:52 -0800 (PST)
From: Amy Overmyer <aovermy@yahoo.com>
Subject: cx23885_wakeup: 32 buffers handled (should be 1)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see messages like : cx23885_wakeup: 32 buffers handled (should be 1) in my logs on my mythtv box. I take it they're coming from my DVICO dual express 7 tuner card. The message always contains those numbers (32 and should be 1). It doesn't seem to cause me any troubles, I'm just curious about the message. A quick perusal of the code in cx23885-core.c doesn't look like this is an actual error condition--i.e. it looks like the driver is handling multiple messages.



      
