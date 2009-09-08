Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:47160 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZIHQla (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 12:41:30 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KPN001MJVP8M6D0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 08 Sep 2009 12:41:32 -0400 (EDT)
Date: Tue, 08 Sep 2009 12:41:32 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [RFC] Allow bridge drivers to have better control over DVB
 frontend operations
In-reply-to: <37219a840909070955k6e3f61dek5bad39a72863e8d5@mail.gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>
Message-id: <4AA6893C.1030000@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <37219a840909012132l6c04af65hddecd2d52e196bcb@mail.gmail.com>
 <4AA12E17.4080006@iki.fi>
 <37219a840909040828i4b4c6781g2f2955a0fdba649b@mail.gmail.com>
 <37219a840909070955k6e3f61dek5bad39a72863e8d5@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I pushed the change to let dvb-usb drivers specify an
> fe_ioctl_override callback within the dvb_usb_adapter_properties
> structure.  Please check the repository for the latest changesets.
>
> I plan to ask Mauro to merge this tree at some point over this next
> week -- If anybody else has comments, please chime in :-)

I'm good with this RFC, it adds feature that enable the bridge (opt-in) to make 
intelligent decisions on behalf of complex products related to resource usage 
and tuning, something we've needed for a while.

Acked-By: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
