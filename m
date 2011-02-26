Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50133 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1BZS6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 13:58:04 -0500
Received: by pxi15 with SMTP id 15so422298pxi.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 10:58:02 -0800 (PST)
From: Ben Collins <benmcollins13@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Request clarification on videobuf irqlock and vb_lock usage
Date: Sat, 26 Feb 2011 13:57:57 -0500
Message-Id: <022EECA1-5416-4173-B435-348531BB5049@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm trying to cleanup some deadlocks and random crashed in my v4l2 driver (solo6x10) and I cannot find definitive documentation on that clear usage of irqlock and vb_lock in a driver that uses videobuf.

When and where should I be using either of these to ensure I work synchronously with the videobuf-core?

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

