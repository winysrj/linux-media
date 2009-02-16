Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:41113 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZBPTNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 14:13:38 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF6003BTAQNWGE0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 16 Feb 2009 14:13:37 -0500 (EST)
Date: Mon, 16 Feb 2009 14:13:35 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-reply-to: <20090216153148.6f2aa408@pedra.chehab.org>
To: linux-media@vger.kernel.org
Cc: Trent Piepho <xyzzy@speakeasy.org>, e9hack <e9hack@googlemail.com>,
	linux-dvb@linuxtv.org
Message-id: <4999BADF.6070106@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4986507C.1050609@googlemail.com>
 <200902151336.17202@orion.escape-edv.de>
 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
 <20090216153148.6f2aa408@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hartmut, Oliver and Trent: Thanks for helping with this issue. I've just
> reverted the changeset. We still need a fix at dm1105, au0828-dvb and maybe
> other drivers that call the filtering routines inside IRQ's.

Fix the demux, add a worker thread and allow drivers to call it directly.

I'm not a big fan of videobuf_dvb or having each driver do it's own thing as an 
alternative.

Fixing the demux... Would this require and extra buffer copy? probably, but it's 
a trade-off between  the amount of spent during code management on a driver by 
driver basis vs wrestling with videobuf_dvb and all of problems highlighted on 
the ML over the last 2 years.

demux->register_driver()
demux->deliver_payload()
demux->unregister_driver()

Then deprecate sw_filter....N() methods.

That would simplify drivers significantly, at the expense of another buffer copy 
while deliver-payload() clones the buffer into its internal state to be more timely.

- Steve

