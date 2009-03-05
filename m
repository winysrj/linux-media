Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:45524 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbZCESEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:04:47 -0500
Received: by fxm24 with SMTP id 24so46364fxm.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 10:04:44 -0800 (PST)
Date: Thu, 05 Mar 2009 14:04:31 -0400
From: Manu <eallaud@gmail.com>
Subject: Symbol rate limit for TT 3200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Message-Id: <1236276271.7491.1@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hi all,
I have been struggling for quite a while to lock on a DVB-S2 
transponder. And recently I got some information that they changed the 
symbol rate to 45MS/s which looks borderline to me. Can someone confirm 
that the TT 3200 can do that?
I also attach a log that I obtained when trying to lock on this 
transponder with the following parameters:
QPSK, FEC= 5/6, 45MS/s
The driver I used was Igor's (very recent) one with szap-s2. The status 
oscillates between 00 and 0b, it can take long to attain 0b which 
suggests long and unreliable lock (never got VITERBI, just demod lock
+sync).
Thx for any help
Bye
Emmanuel
