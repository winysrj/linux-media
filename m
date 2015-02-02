Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33612 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbBBPjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:39:14 -0500
Received: by mail-yk0-f172.google.com with SMTP id 9so22190258ykp.3
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2015 07:39:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost>
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>
	<1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost>
Date: Mon, 2 Feb 2015 10:39:13 -0500
Message-ID: <CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com>
Subject: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
From: Steven Toth <stoth@kernellabs.com>
To: DCRYPT@telefonica.net
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>Basically, it starts working but after a while I get an "Event timed out" message and several i2c errors and VDR shuts down (some hours after reboot). As the web page mentions, I tested downgrading the PCIe bandwith from GEN2 to GEN1 without success. But after playing with different BIOS options, what did the trick was limiting the power-saving C-states. If I select "C7" as the maximum C-state, the card fails as described. After limiting the maximum C-state to "C6", it has been working for a whole weekend.

Good feedback on the C7 vs C6 power state, thanks.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
