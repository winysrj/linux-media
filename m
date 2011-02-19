Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59123 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754450Ab1BSSxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 13:53:48 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: analogue tuners: radio volume much lower than TV volume
Date: Sat, 19 Feb 2011 19:53:46 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102191953.46187.martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

My PVR350 (ivtv) and my PVRUSB2 Model 29034 (pvrusb2) have a much lower volume 
when switching to radio. 

On the HVR1300 (cx88-blackbird, Philips FMD1216ME tuner) this is no problem; 
radio has same volume level.

The saa7134-based KNC One TV Station DVR (similar tuner: FMD1216MEX) has a 
very low audio volume on radio, even lower than the ivtv/pvrusb2 devices. 
Unfortunately it is not possible to set the volume. The radio device doesn't 
support V4L2_CID_AUDIO_VOLUME, and performing the ioctl on the video device 
causes a switch back to TV mode. 

Is there an explanation for this audio volume issue? Does it depend on the 
tuner type?
Should a driver internally sets a higher audio volume for radio mode, or is 
this against the V4L2 api?
