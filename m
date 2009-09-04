Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:25522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbZIDRJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 13:09:26 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1135108fge.1
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2009 10:09:28 -0700 (PDT)
Message-ID: <4AA149C6.9070308@googlemail.com>
Date: Fri, 04 Sep 2009 18:09:26 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Question on video device in /dev for S460 card cx88
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Quick question regarding video devices that show up when using a cx88 base S460
(tevii) DVB-S2 card.

I see two devices in /dev
/dev/video0 and /dev/vbi0 related to the cx88 based dvb-s2 card.
What are those devices, is the video0 the video out of the card after the
demuxer? If so, should that device not show up in /dev/dvb/adapterN ??

What is the /dev/vbi0 device?

Regards
Peter

