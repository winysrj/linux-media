Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:19164 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCWVik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 17:38:40 -0400
Message-ID: <49C7F302.6030004@oracle.com>
Date: Mon, 23 Mar 2009 13:37:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 23 (media/video/hdpvr)
References: <20090323205454.d0cbf721.sfr@canb.auug.org.au> <49C7D965.5080202@oracle.com> <20090323204940.GA5079@aniel>
In-Reply-To: <20090323204940.GA5079@aniel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Janne Grunau wrote:
> Hi,
> 
> On Mon, Mar 23, 2009 at 11:48:05AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Changes since 20090320:
>>> The v4l-dvb tree gained a build failure for which I have reverted 3 commits.
>> drivers/built-in.o: In function `hdpvr_disconnect':
>> hdpvr-core.c:(.text+0xf3894): undefined reference to `i2c_del_adapter'
>> drivers/built-in.o: In function `hdpvr_register_i2c_adapter':
>> (.text+0xf4145): undefined reference to `i2c_add_adapter'
>>
>>
>> CONFIG_I2C is not enabled.
> 
> following patch should fix that.

Ack.  Thanks.

> Janne
> 
> ps: Mauro, I'll send a pull request shortly


-- 
~Randy
