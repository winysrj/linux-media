Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:35172 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbZD0WRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 18:17:39 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIS0059C5XDM480@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 27 Apr 2009 18:17:38 -0400 (EDT)
Date: Mon, 27 Apr 2009 18:17:37 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: How would I record the entire Transport Stream (all PIDs)?
In-reply-to: <4326ebb00904271504see16470x51e3cbb512e10870@mail.gmail.com>
To: Dale Hopkins <dale@lucidhelix.com>
Cc: linux-media@vger.kernel.org
Message-id: <49F62F01.3000609@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4326ebb00904271504see16470x51e3cbb512e10870@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dale Hopkins wrote:
> I have successfully opened up the frontend and tuned it to a QAM
> channel.  I have setup a simple PES filter for the PAT on the DEMUX
> and confirmed that I recieve 188 byte packets with PID=0.  Now I want
> to be able to send all PIDs to the dvr device without having to setup
> 8192 PES filters.  Any suggestions?

Filter on PID 0x2000 for all transport packets.

- Steve
