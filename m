Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:61817 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZBSTRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:10 -0500
Message-ID: <499DB030.7010206@kaiser-linux.li>
Date: Thu, 19 Feb 2009 20:17:04 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Jean-Francois Moine <moinejf@free.fr>,
	Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0902182305300.6388@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kilgota@banach.math.auburn.edu wrote:
> ID 0x093a:0x010e are working, because the image does not come out. Well,

Just if you don't know.....

ID 0x093a is the vendor ID from Pixart. Did MARS change the name to Pixart?

> What I found:
> 
> After shooting a raw frame, I get
> 
> FF FF 00 FF 96 64 D0 01 27 00 06 2D

There is the same Frame Header for the PAC207 and PAC7311 (FF FF 00 FF 
96 ..... 12 Bytes in total as I remember).
PAC207 does a line based compression and PAC7311 is jpeg based with a 
marker in front of each MCU. Both decompression are supported by libv4l :-)

The PAC207 can be configured to run in raw mode or compressed mode. The 
same should be possible to do with the PAC7311, but I could not find the 
right register to set this :-(

Don't know if this info helps you? (or you already know)

Thomas
