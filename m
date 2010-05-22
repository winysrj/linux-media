Return-path: <linux-media-owner@vger.kernel.org>
Received: from cain.gsoft.com.au ([203.31.81.10]:22117 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab0EVDry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 23:47:54 -0400
Subject: Re: DViCo Dual Fusion Express (cx23885) remote control issue
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <4BD151AB.7070701@vorgon.com>
Date: Sat, 22 May 2010 13:17:21 +0930
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8A1612AF-3E76-4CC8-8981-FADA2F7F50A5@dons.net.au>
References: <201004151519.58012.darius@dons.net.au> <201004222241.28624.darius@dons.net.au> <4BD0984E.4070609@vorgon.com> <201004231000.07508.darius@dons.net.au> <4BD151AB.7070701@vorgon.com>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 23/04/2010, at 17:22, Timothy D. Lenz wrote:
>> I haven't found any problems with tuners not working although I don't
>> often fire them both up at once.
>> 
> 
> [PATCH] FusionHDTV: Use quick reads for I2C IR device probing

I finally found some time to look at this and found..
https://patchwork.kernel.org/patch/86939/

However I don't see anything in /sys/bus/i2c/devices so I presume it's another issue :(


--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






