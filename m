Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:58838 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab1JZEgR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 00:36:17 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9Q4aDeD001440
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 00:36:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 64BF91E0149
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 00:36:12 -0400 (EDT)
Message-ID: <4EA78E3C.2020308@lockie.ca>
Date: Wed, 26 Oct 2011 00:36:12 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: femon signal strength
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My signal strength is always above 0 but when I use -H, it is 0%.
Does that mean my signal strength is <0%?
Maybe femon should report 0.x%.

$ femon
FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
status SCVYL | signal 00b9 | snr 00b9 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

$ femon -H
FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
status SCVYL | signal   0% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK

Is it normal to have <0% signal strength and still get reception?
