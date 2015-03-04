Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34643 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbbCDNnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 08:43:25 -0500
Received: by ykt10 with SMTP id 10so19998470ykt.1
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2015 05:43:24 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Mar 2015 08:43:24 -0500
Message-ID: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
Subject: HVR2205 / HVR2255 support
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, what's the plan to pull the LGDT3306A branch into tip? The
SAA7164/HVR2255 driver need this for demod support.

Hey folks, an update on this.

So I have the green-light to release my HVR2205 and HVR2255 board
related patches. I started merging them into tip earlier this week.
The HVR2205 is operational for DVB-T, although I have not tested
analog tv as yet.

The HVR2255 is the next on the list, I expect this to be trivial once
the HVR2205 work is complete.

Annoyingly, I'm traveling on business for the next 10 days or so. I
can't complete the work until I return - but I expect to complete this
entire exercise by 21st of this month.... So hold on a little longer
and keep watching this mailing list for further updates.

Thanks,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
