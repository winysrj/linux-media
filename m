Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:12833 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932634AbbIVJ6Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 05:58:16 -0400
From: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "divneil@outlook.com" <divneil@outlook.com>
Date: Tue, 22 Sep 2015 17:58:04 +0800
Subject: Driver private field for struct dmxdev_filter 
Message-ID: <C17522D12DF21D4F9DC8833224F23A870E7D7FBC@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am working on a solution, where the dvb demuxer solution is partly based on LDVB demux framework.
Due to some constraints posed by the lower layers of software stack, fops have been over-written.

I have allocated driver private per filter structure which I want to use in conjuction with struct dmxdev_filter without modifying file->private_data.
So, I would like to have a "void *priv" added to this structure. Thanks to share you view.

Regards,
Divneil
