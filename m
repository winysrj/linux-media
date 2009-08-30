Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:45986 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZH3LrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 07:47:01 -0400
Received: by ywh26 with SMTP id 26so4853167ywh.5
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 04:47:02 -0700 (PDT)
Message-ID: <4A9A66B0.10202@gmail.com>
Date: Sun, 30 Aug 2009 17:16:56 +0530
From: Sudipto Sarkar <xtremethegreat1@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HP VGA Cam
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to write a driver for the HP VGA camera. USB ID: 15b8:6002. 
The sensor is 7131r, and the bridge is probably vc0323 (although the inf 
says it's vc0326). It's inf is the same inf which includes the po1200 
sensor, which was added in December last year (The HP 2.0 Megapixel 
camera). I am trying to use usbsnoop in a windows installation, but the 
log size just does not cease to come to a halt (as is specified in the 
microdia site), thereby leaving me unable to snoop the init sequence. 
What might be wrong?

Also, is this the same sensor as hv7131r, as in vc032x.c?
