Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f112.google.com ([209.85.221.112]:51383 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZD0WEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 18:04:04 -0400
Received: by qyk10 with SMTP id 10so377212qyk.33
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2009 15:04:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 16:04:01 -0600
Message-ID: <4326ebb00904271504see16470x51e3cbb512e10870@mail.gmail.com>
Subject: How would I record the entire Transport Stream (all PIDs)?
From: Dale Hopkins <dale@lucidhelix.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have successfully opened up the frontend and tuned it to a QAM
channel.  I have setup a simple PES filter for the PAT on the DEMUX
and confirmed that I recieve 188 byte packets with PID=0.  Now I want
to be able to send all PIDs to the dvr device without having to setup
8192 PES filters.  Any suggestions?

Thanks,
Dale Hopkins
