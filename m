Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc2s15.hotmail.com ([157.55.1.154]:50781 "EHLO
	DUB004-OMC2S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbaGINNc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 09:13:32 -0400
Message-ID: <DUB123-W379FFAE53D93ACCE359F07ED0F0@phx.gbl>
From: Lukas Tribus <luky-37@hotmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Troubleshooting problematic DVB-T reception
Date: Wed, 9 Jul 2014 15:08:23 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,


I am trying to troubleshoot a (non-linux related) DVB-T issue and I basically
want to create statistics about both DVB and MPEG framing, errors, corruption,
missing frames, etc.

The reason is that I believe there is a problem on the transmitting radio
tower, RF is fine between the tower and me, but the actual payload (MPEG) is
somehow bogus, errored or sporadically misses frames (due to backhaul problems
or whatever).

If I would be able to create some statistics confirming that I see all the DVB
frames without any errors, but that the actual DVB payload (MPEG) has some
problems, I could convince the tower guys to actually fix the issue, instead
of blaming my antennas.


So, can anyone suggest a tool or method to troubleshoot this issue further?


tzap output for example confirms not a single BER error and the tuner keeps
full LOCK on the channel while the actual stream is stuttering.





I understand that this is not directly related to the DVB stack in the kernel,
and I'm sorry if this is thus off-topic, but I am not sure where else to ask.




Any help would be much appreciated!


Thanks,

Lukas

 		 	   		  