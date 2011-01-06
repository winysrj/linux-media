Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56399 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1AFOPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 09:15:45 -0500
Received: by eye27 with SMTP id 27so7176185eye.19
        for <linux-media@vger.kernel.org>; Thu, 06 Jan 2011 06:15:44 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 6 Jan 2011 09:15:44 -0500
Message-ID: <AANLkTikxofcZihWzmcGbzOk-u68AnjuhYuy5CCDvWV6Y@mail.gmail.com>
Subject: Best driver for saa7164 w/ analog
From: James Crow <crow.jamesm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello list,

  I use a HVR-2250 with MythTV. I have been using the beta drivers
with analog support from Steven Toth for quite some time. I am now
experiencing failed recordings from the second tuner on the card. So
far I have not seen any failed analog recordings only failed DVB
(ClearQAM). I am wondering if the driver with analog support has been
merged into the main v4l-dvb tree and if I should update my driver.
The driver I currently use is tagged "8da3bd06a289".

If it matters, this is the error I see in the backend log from Myth:
2011-01-05 21:30:30.172 TVRec(4): ASK_RECORDING 4 29 0 0
2011-01-05 21:30:30.230 TVRec(12): ASK_RECORDING 12 29 0 0
2011-01-05 21:30:30.789 TVRec(3): ASK_RECORDING 3 29 0 0
2011-01-05 21:31:02.957 TVRec(3): Changing from RecordingOnly to None
2011-01-05 21:31:03.078 Finished recording Modern Family "Slow Down
Your Neighbors": channel 1131
2011-01-05 21:31:03.421 TVRec(3): Changing from None to RecordingOnly
2011-01-05 21:31:03.485 TVRec(3): HW Tuner: 3->3
2011-01-05 21:31:03.567 DVBSM(/dev/dvb/adapter1/frontend0), Warning:
Cannot measure Signal Strength
			eno: Invalid argument (22)
2011-01-05 21:31:03.609 DVBSM(/dev/dvb/adapter1/frontend0), Warning:
Cannot measure S/N
			eno: Invalid argument (22)
2011-01-05 21:31:03.745 AutoExpire: CalcParams(): Max required Free
Space: 3.0 GB w/freq: 7 min
2011-01-05 21:31:03.815 Started recording: "Cougar Town":"No Reason to
Cry": channel 1131 on cardid 3, sourceid 1
2011-01-05 21:31:03.910 Updating status for "Modern Family":"Slow Down
Your Neighbors" on cardid 3 (Tuning => Recorded)


Thanks,
James
