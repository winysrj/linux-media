Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:35892 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZEZFnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 01:43:14 -0400
Received: by fxm12 with SMTP id 12so1764133fxm.37
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 22:43:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 May 2009 08:43:15 +0300
Message-ID: <eaf6cbc30905252243m2d6e1537vd255e49f289c0f33@mail.gmail.com>
Subject: Problem with SCM/Viaccess CAM
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
When inserting a SCM/Viaccess CAM, I get the following message:
dvb_ca adapter 0: DVB CAM did not respond :(

According to this:
http://linuxtv.org/hg/v4l-dvb/file/142fd6020df3/linux/Documentation/dvb/ci.txt
this CAM should work.

I'm using kernel 2.6.10.

Any help would be greatly appreciated,
Tomer
