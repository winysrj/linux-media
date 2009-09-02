Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41818 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZIBLsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 07:48:23 -0400
Received: by ewy2 with SMTP id 2so712868ewy.17
        for <linux-media@vger.kernel.org>; Wed, 02 Sep 2009 04:48:24 -0700 (PDT)
Message-ID: <4A9E5B88.50001@googlemail.com>
Date: Wed, 02 Sep 2009 12:48:24 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Should I see a videoN and audioN in /dev/dvb/adapterN??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I am using a S460 Tevii ( Cx88) and a nova T 500 card.
I see three adapter directories ( T 500 is dual tuner).
Each has demux0 frontend0 net0 and dvr0

Should I not see a video0 and audio0 in each of them too?
I see one /dev/video0 and one /dev/vbi0 that seems to belong to the S460 card

Regard
Peter
