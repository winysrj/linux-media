Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:54751 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbcIMLC1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 07:02:27 -0400
Received: from dc8secmta1.synopsys.com (dc8secmta1.synopsys.com [10.13.218.200])
        by smtprelay.synopsys.com (Postfix) with ESMTP id 3266424E2007
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 04:02:26 -0700 (PDT)
Received: from dc8secmta1.internal.synopsys.com (dc8secmta1.internal.synopsys.com [127.0.0.1])
        by dc8secmta1.internal.synopsys.com (Service) with ESMTP id 2633927113
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 04:02:26 -0700 (PDT)
Received: from mailhost.synopsys.com (unknown [10.13.184.66])
        by dc8secmta1.internal.synopsys.com (Service) with ESMTP id 1001F27102
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 04:02:26 -0700 (PDT)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
        by mailhost.synopsys.com (Postfix) with ESMTP id F3A85C1F
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 04:02:25 -0700 (PDT)
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1.internal.synopsys.com [10.12.239.235])
        by mailhost.synopsys.com (Postfix) with ESMTP id EB4CAC1E
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2016 04:02:25 -0700 (PDT)
To: <linux-media@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: DV Timings handling
Message-ID: <57D7DCBD.4010608@synopsys.com>
Date: Tue, 13 Sep 2016 12:02:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I am writing a very simple v4l2 driver for HDMI video capturing
and I have a question regarding the DV timings. I have
implemented {g/s/query}_dv_timings in my driver but these ioctls
are not called when I try to use mplayer. If I grep mplayer code
I don't find any reference to these functions. Am I missing
something or is this not implemented in mplayer? If so, can you
refer any application that uses these ioctls?

Best regards,
Jose Miguel Abreu
