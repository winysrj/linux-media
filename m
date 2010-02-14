Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp108.mail.ukl.yahoo.com ([77.238.184.40]:45885 "HELO
	smtp108.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932126Ab0BNCAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 21:00:20 -0500
Message-ID: <4B775931.8020208@yahoo.it>
Date: Sun, 14 Feb 2010 03:00:17 +0100
From: SebaX75 <sebax75@yahoo.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Possible em28xx regression for Pinnacle Dazzle Tv Hybrid Stick 320E
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I've already wrote on the problem that I'll go to explain and that was 
already solved by Devin. It was solved and a call for tester was done, 
and all was working (em28xx DVB modeswitching change); logically I've 
used actual tree (updated with hg today).
Now the problem: with scandvb, during a scan for channels, the adapter 
is able to recognize and tune only the first mux found in the list, for 
all the other mux the output is "tuning failed"; I can change the mux 
order, but always only first mux is tuned and channel recognized.

Thanks in advance for support,
Sebastian
