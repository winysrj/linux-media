Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64941 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0CRLYU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 07:24:20 -0400
Subject: Re: DMX Input selection
From: Andy Walls <awalls@radix.net>
To: The Duke Forever <thedukevip@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4adcd9b21003170344j63f8b845ja1033d7ce590f978@mail.gmail.com>
References: <4adcd9b21003170344j63f8b845ja1033d7ce590f978@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 07:24:32 -0400
Message-Id: <1268911472.3084.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-03-17 at 11:44 +0100, The Duke Forever wrote:
> Hello,
> I'm currently developing a DVB test application without real hardware,
> instead, I'm using dvb_dummy_adapter (+dvb-core and dvb_dummy_fe)
> Testing PES filtering is OK, since I have read/write operations on the
> logical dvr device "/dev/dvb/adapter0/dvr0"
> I have problems with section filtering, I can't find a way to read
> data from a TS file.
> Methods I've tried :
> - Write data to DVR, set the demux to read data from DVR using ioctl
> "DMX_SET_SOURCE" -> seems that this ioctl is not implemented
> - As the section filter reads data from frontend, I've tried to write
> data to "/dev/dvb/adapter0/frontend0" so they can be read by the
> demux, but no luck, no writing operation available
> 
> Any suggestions please ?!

My dvb_dummy_adapter patch was a 1-hour hack just for "fun".  It does
nothing non-standard (hopefully) and adds no APIs.  IIRC, writing to the
frontend is not a valid operation in the DVB API.

I would suggest looking around for the dvbloopback (dvb_loopback ?)
patches.  They create a more complete dummy adapater and provide a
special (non-standard) character device node for injecting data as if it
came from the frontend.

Regards,
Andy


