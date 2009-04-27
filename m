Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:36262 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZD0OhM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 10:37:12 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIR00HY4KLY7W30@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 27 Apr 2009 10:37:11 -0400 (EDT)
Date: Mon, 27 Apr 2009 10:37:09 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] Nova HD S2 problem
In-reply-to: <380-220094127133828254@M2W042.mail2web.com>
To: linux-media@vger.kernel.org
Cc: mikeparkins@ntlworld.com
Message-id: <49F5C315.3070308@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <380-220094127133828254@M2W042.mail2web.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am using Mandriva Linux 2009.1 with 2.6.29.1 kernel. My Hauppauge Nova HD
> S2 (which I understand is known as an HVR4000lite in the DVB API) is not
> recognised on boot. Using lspci I see the vendor/device code is 0070:4096,
> whereas the API code (in cx88-cards.c) appears to expect 0070:6096 for this
> card.
> 
> Can anyone clue me in?

Re-seat the card.

- Steve
