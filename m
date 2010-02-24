Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34049 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757183Ab0BXQYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 11:24:46 -0500
Subject: Re: [linux-dvb] soft demux device
From: Roland Mieslinger <rmie@gmx.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <829000.26472.qm@web57006.mail.re3.yahoo.com>
References: <829000.26472.qm@web57006.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 17:24:39 +0100
Message-Id: <1267028679.4587.46.camel@buero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> I have just compiled v4l-dvb successfully. My aim is to develop some experimental dvb applications on top of this dvb kernel api. Initially, I do not want to use any hardware and would like to play with the recorded ts files I have. So, is there any software demux device available within this package or somewhere else? If so, how can I load this device and make it work on a given ts file circularly? On the other hand, I have no /dev/dvb node  at the moment, so should I do anything for this or would loading the driver create it automatically?
> 
> Thanks in advance.
> 
> Cheers,
> 
> Ozgur.

maybe this is a good starting point for you:

 "I wrote a Linux kernel module which provides one or more 
  virtual DVB adapters. When loaded, it creates a char device 
  of the form /dev/dvbloop<num> for every virtual DVB adapter.
  All Transport Stream packets written to a char device will
  be delivered on the corresponding virtual DVB adapter.

  You can get the sources at
  http://cpn.dyndns.org/projects/dvbloop.shtml

  Maybe somebody finds it useful.

  Cheers,
  Christian.
  -- 
  Christian Praehauser"

the link seems to be outdated, but the following is still
working https://svn.baycom.de/repos/dvbloop/.

A S2API patch is out as well:
http://www.vdrportal.de/board/attachment.php?attachmentid=24024

I've no idea if this is working well or not, I'm not using it myself.
YMWV

Roland

