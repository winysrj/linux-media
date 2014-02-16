Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp11.one.com ([195.47.247.117]:49205 "EHLO csmtp11.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaBPWAM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 17:00:12 -0500
Received: from [192.168.0.105] (4709ds1-gl.1.fullrate.dk [90.184.128.55])
	by csmtp11.one.com (Postfix) with ESMTPA id A74A7C03B6930
	for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 21:54:02 +0000 (UTC)
Message-ID: <53013379.70403@megahurts.dk>
Date: Sun, 16 Feb 2014 22:54:01 +0100
From: Rune Petersen <rune@megahurts.dk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Some questions timeout in rc_dev
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


The intent of the timeout member in the rc_dev struct is a little unclear to me.
In rc-core.h it is described as:
	@timeout: optional time after which device stops sending data.

But if I look at the usage, it is used to detect idle in ir_raw.c which again is 
used by the RC-6 decoder to detect end of RC-6 6A transmissions.

This leaves me with a few questions:
  - Without the timeout (which is optional) the RC-6 decoder will not work
    properly with RC-6 6A transmissions wouldn't that make it required?

  - Why are the timeout set in the individual drivers so varied, shouldn't it
    depend on the encoding rather then the hardware used?
    The timeout set in the drivers ranges from 2750us(redrat3)
    to 1000000us(fintek_cir) and all the way to weird(streamzap)

  - Why is the timeout value controlled by the IR driver, when it us only
    used	by the rc-core.
    Wouldn't it make sense to have the timeout initialized to a sane value
    in a single place?


I would like to get rc to a state where it just works for me without 
modifications, I "just" need to know which changes I can get away without 
breaking it for everybody else =)

As things are right now the RC input feel very sluggish and unresponsive using a 
RC-6 6A remote and a ite-cir receiver.


Rune
