Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41551 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZIWMPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 08:15:22 -0400
Received: by bwz6 with SMTP id 6so479119bwz.37
        for <linux-media@vger.kernel.org>; Wed, 23 Sep 2009 05:15:25 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 14:15:25 +0200
Message-ID: <3192d3cd0909230515v32090f55y2e3a582172420edc@mail.gmail.com>
Subject: PCI bridge driver
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi List,

I have looked at the documentation (v4l2-framework.txt) and have some
questions. I want to make use
of the subdevice stuff, but I don't know where to start. The
subdevices are connected through i2c and the
components may vary. So is there a good example driver to look at?

thanks,
-- 
Christian Gmeiner, B.Sc.
