Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZEMGYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 02:24:08 -0400
Date: Tue, 12 May 2009 23:22:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: Marc Haber <mh+linux-kernel@zugschlus.de>
Subject: Fw: tua6100_sleep: i2c error when trying to tune saa7146 based  DVB
 card
Message-Id: <20090512232212.6739ca15.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Begin forwarded message:

Date: Tue, 12 May 2009 09:42:35 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: tua6100_sleep: i2c error when trying to tune saa7146 based  DVB card


Recently, my entertainment PC has begun to refuse tuning to my
favorite stations, logging "tua6100_sleep: i2c error" when I try to do
so. Kaffeine says "can't tune DVB".

Other stations work just fine.

The box has a saa7146 equipped budget DVB-S card which used to work
fine previously. I have first seen this behavior in kernel 2.6.29, and
still see it in 2.6.29.3.

If you need any more data, please ask and I'll try to deliver it.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
