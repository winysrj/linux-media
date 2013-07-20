Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:65382 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3GTIuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 04:50:21 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so4094546lbv.27
        for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 01:50:19 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Jul 2013 13:20:19 +0430
Message-ID: <CAOdeS+jQ3R3q4cwAy8rVLazF0SOmVHr3Af_rXSS5=0-x7RNVJQ@mail.gmail.com>
Subject: Is it Possible to get GSE using TBS6925
From: "M.Rashid Zamani" <mohammadrashidzamani@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am wondering if it is possible to capture GSE with my TBS6925. I
found a patch for TBS6925 linux driver from Christian Prähauser[1] to
support multistream in linux. But the Patch is for an old version of
the driver. When I tried to apply the patch on liplianin driver
(s2-37) I realized that the source code has changed, and already
included some of the changes. Since it has been almost a year since
the last post in this field I wanted to know if any further
investigation has happened on the mater, and if any one was able to
capture GSE.

In dvbnet homepage[2] I can see there is a gse-testing tool, but no
download link! Has anyone used that tool? Does any one have the tool!?

Any help would be appreciated.
Thank you in advance.
Cheers


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg42465.html
[2] http://www.cosy.sbg.ac.at/~cpraehaus/dvb-net.shtml
