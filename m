Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58268 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZFSPbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 11:31:49 -0400
Received: by ewy6 with SMTP id 6so2650821ewy.37
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 08:31:51 -0700 (PDT)
Message-ID: <4A3BAF65.3050807@gmail.com>
Date: Fri, 19 Jun 2009 16:31:49 +0100
From: pb <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Problems receiving hd channels from astra 19.2 with cx800 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am using a Tevii S460 DVB-S2 card in a linux environment. Useing the 
lasted v4l driver source.
Use mplayer to test the adapter.
Can receive BBC HD from astra 28.2 including the digital audio.
How ever when I try HD channels from Astra 19.2 I get error from the 
cx8802 driver, cx8802_start_dma() Failed. Unsupported value in .mpeg (0
Can receive 'normal' channels from astra 19.2.
Linux version 1.6.29-R5, latest v4l sources ( downloaded 4 days ago)
The S460 is the only PCI card in the system, motherboard NC62K from Jetway.
Does this sound familiar?

Regards
Peter
