Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw3a.lmco.com ([192.35.35.7]:52043 "EHLO mailgw3a.lmco.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZBJAO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 19:14:59 -0500
Received: from emss04g01.ems.lmco.com (relay4.ems.lmco.com [166.17.13.122])by mailgw3a.lmco.com  (LM-6) with ESMTP id n1A0EwDG010619for <linux-media@vger.kernel.org>; Mon, 9 Feb 2009 19:14:58 -0500 (EST)
Received: from CONVERSION2-DAEMON.lmco.com by lmco.com (PMDF V6.3-x14 #31428)
 id <0KET00E01Q0YQR@lmco.com> for linux-media@vger.kernel.org; Mon, 09 Feb 2009 19:14:58 -0500 (EST)
Received: from EMSS01I00.us.lmco.com ([137.249.139.145]) by lmco.com (PMDF V6.3-x14 #31428)
 with ESMTP id <0KET00A85Q0SIO@lmco.com> for linux-media@vger.kernel.org; Mon, 09 Feb 2009 19:14:53 -0500 (EST)
Date: Mon, 09 Feb 2009 16:14:50 -0800
From: "Williams, Phil A" <phil.a.williams@lmco.com>
Subject: Re: cx18, HVR-1600 Clear qam tuning
To: linux-media@vger.kernel.org
Message-id: <CCB65A8C741893429D41536D8B5F6D921CCFF080@emss01m15.us.lmco.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-class: urn:content-classes:message
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using an HVR-1600, having a heck of a time, and wanted to give this
patch a try. Can someone point me to a good wiki or howto on how to
incorporate this patch?

>Devin just commited a patch to improve the lock time of the
>cx24227/s5h1409 demodulator:
>
>http://linuxtv.org/hg/~dheitmueller/v4l-dvb-s5h1409/rev/6bb4e117a614
>
>I've tested it with my HVR-1600 and it improved things for me when
>tuning ATSC OTA.  You may wish to give it a try.

Thanks,

Phil/TW

