Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:52791 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZCZP7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 11:59:19 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KH400BMEF2O1H21@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 26 Mar 2009 11:59:13 -0400 (EDT)
Date: Thu, 26 Mar 2009 11:59:11 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: V4L2 Advanced Codec questions
To: linux-media@vger.kernel.org
Message-id: <49CBA64F.2080506@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I want to open a couple of HVR22xx items up for discussion.

The HVR-22xx analog encoder is capable of encoded to all kinds of video and 
audio codecs in various containers formats.

 From memory, wm9, mpeg4, mpeg2, divx, AAC, AC3, Windows audio codecs in asf, 
ts, ps, avi containers, depending on various firmware license enablements and 
configuration options. Maybe more, maybe, I'll draw up a complete list when I 
begin to focus on analog.

Any single encoder on the HVR22xx can produce (if licensed) any of the formats 
above. However, due to a lack of CPU horsepower in the RISC engine, the board is 
not completely symmetrical when the encoders are running concurrently. This is 
the main reason why Hauppauge have disabled these features in the windows driver.

It's possible for example to get two concurrent MPEG2 PS streams but only if the 
bitrate is limited to 6Mbps, which we also do in the windows driver.

Apart from the fact that we (the LinuxTV community) will need to determine 
what's possible concurrently, and what isn't, it does raise interesting issues 
for the V4L2 API.

So, how do we expose this advanced codec and hardware encoder limitation 
information through v4l2 to the applications?

Do we, don't we?

Suggestions?

- Steve


