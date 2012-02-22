Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39754 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVIYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 03:24:36 -0500
Received: by vbjk17 with SMTP id k17so4772340vbj.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 00:24:36 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Feb 2012 17:24:35 +0900
Message-ID: <CAPLVkLtJH1yKkuoUSviL4Q8aKQM3GNvULkZPRQ62jzXo1hfC=g@mail.gmail.com>
Subject: Question about signal of struct v4l2_tuner
From: Joonyoung Shim <dofmind@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i saw a comment about signal field of struct v4l2_tuner from
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html#v4l2-tuner

__u32   signal  The signal strength if known, ranging from 0 to 65535.
Higher values indicate a better signal.

Some v4l2 radio drivers use directly signal strength value(unit: dbµV)
reading from hardware and some drivers transform the signal value to
above range from 0 to 65535.

I wonder which thing is proper way.

Thank.

-- 
- Joonyoung Shim
