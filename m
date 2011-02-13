Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36026 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754762Ab1BMTjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 14:39:10 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: radio tuner but no V4L2_CAP_RADIO ?
Date: Sun, 13 Feb 2011 20:39:07 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102132039.07632.martin.dauskardt@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following cards have a Multi Standard tuner with radio:
KNC One TV-Station DVR (saa7134) FMD1216MEX
HVR1300 (cx88-blackbird) Philips FMD1216ME
/dev/radio0 is present and working.

Both drivers do not report the radio when using VIDIOC_QUERYCAP.

Is this a bug, or is there no clear specification that a driver must report 
this?

Is there are any other way to check radio for support (besides trying to open 
a matching radio device) ?
