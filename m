Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:37428 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbZEVPyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 11:54:52 -0400
Message-ID: <4A16CB54.9000705@oracle.com>
Date: Fri, 22 May 2009 08:57:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] v4l2: handle unregister for non-I2C builds
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>	<4A085455.5040108@oracle.com>	<20090522054847.GB14059@linux-sh.org> <20090522175554.19465733.sfr@canb.auug.org.au>
In-Reply-To: <20090522175554.19465733.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stephen Rothwell wrote:
> On Fri, 22 May 2009 14:48:47 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
>> On Mon, May 11, 2009 at 09:37:41AM -0700, Randy Dunlap wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Build fails when CONFIG_I2C=n, so handle that case in the if block:
>>>
>>> drivers/built-in.o: In function `v4l2_device_unregister':
>>> (.text+0x157821): undefined reference to `i2c_unregister_device'
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> This patch still has not been applied as far as I can tell, and builds
>> are still broken as a result, almost 2 weeks after the fact.
> 
> In fact there has been no updates to the v4l-dvb tree at all since
> May 11.  Mauro?

I got an 'hg' autocommit message for the patch on May-11, but that's
all I've seen/heard about it.

I'm really concerned about how slowly patches are merged for
linux-next trees... and not just for drivers/media/


> I have reverted the patch that caused the build breakage ... (commit
> d5bc7940d39649210f1affac1fa32f253cc45a81 "V4L/DVB (11673): v4l2-device:
> unregister i2c_clients when unregistering the v4l2_device").
> 
> [By the way, an alternative fix might be to just define
> V4L2_SUBDEV_FL_IS_I2C to be zero if CONFIG_I2C and CONFIG_I2C_MODULE are
> not defined (gcc should then just elide the offending code).]


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
