Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:45647 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0FVRCZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 13:02:25 -0400
Received: by ywh36 with SMTP id 36so3311801ywh.4
        for <linux-media@vger.kernel.org>; Tue, 22 Jun 2010 10:02:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Jun 2010 22:32:23 +0530
Message-ID: <AANLkTikuPBKre8wjkGZ-fXhQc5ad_OmNtERvFslpPXvR@mail.gmail.com>
Subject: buffer management
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

While working on a driver, i stumbled up on this question. I have a
driver where the driver allocates it's buffers
(maybe it's better to term that the hardware requires it that way) in
the following fashion:

Buffer 1: SG list 1
Buffer 2: SG list 2
Buffer 3: SG list 3
Buffer 4: SG list 4
Buffer 5: SG list 5
Buffer 6: SG list 6
Buffer 7: SG list 7
Buffer 8: SG list 8

Now, on each video interrupt, I know which SG list i need to read
from. At this stage i do need to copy the
buffers associated with each of the SG lists at once. In this
scenario, I don't see how videobuf could be used,
while I keep getting this feeling that a simple copy_to_user of the
entire buffer could do the whole job in a
better way, since the buffers themselves are already managed and
initialized already. Am I correct in thinking
so, or is it that I am overlooking something ?

Comments ?

Thanks,
Manu
