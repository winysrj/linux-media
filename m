Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46484 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757366AbcIVWTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 18:19:16 -0400
Date: Fri, 23 Sep 2016 01:17:13 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Marty Plummer <netz.kernel@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: TW2866 i2c driver and solo6x10
Message-ID: <20160922221713.kvi3q4qcobye6m5b@acer>
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
 <20160919182033.qaom5ji4k43jsu24@acer>
 <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c69cbd-950e-ba01-5d6a-efdabe6f6d16@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So is the actual machine x86 or ARM?
Do the tw28xx chips behind the bus (i2c as you said) show up in any way
at all? Is something like i2c controller available? Or it's ARM and we
should tell kernel how to "find" the i2c line by feeding correct
devicetree to it?
