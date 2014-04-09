Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45167 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaDIInH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 04:43:07 -0400
Received: by mail-qc0-f169.google.com with SMTP id i17so2387283qcy.28
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 01:43:06 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Apr 2014 10:43:06 +0200
Message-ID: <CAPz3gm=yPyEPQXoiwA4EtwRJkaKxgzXma8e2B4gDeUgF_ZEv9Q@mail.gmail.com>
Subject: Progressive and continuous record of a DVB stream
From: shacky <shacky83@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I need to make a continuous (H24) recording of some DVB-S and DVB-T
streams and I wish to let me to play it during its recording, without
waiting for the file closing.

The purpose is having something like a DVR which lets me to play a DVB
stream selecting a date/time, so I will also need to index every
recorded file trunk for channel, date and time (and I can make this in
a database).

I need to record every channel I find in the same MUX in a different TS file.

Is there any utility that could help me what I need?
Could you give me some advises, please?
I looked for some best practices but I didn't find anything special
regarding this question.

Thank you very much.
Bye!
