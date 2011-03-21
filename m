Return-path: <mchehab@pedra>
Received: from smtpauth22.prod.mesa1.secureserver.net ([64.202.165.44]:53762
	"HELO smtpauth22.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754484Ab1CUURn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 16:17:43 -0400
From: Gilles <gilles@gigadevices.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: linux soc-camera
Date: Mon, 21 Mar 2011 13:11:02 -0700
Message-Id: <E87D1C9E-5824-47BC-B8F5-4DD50C918A1F@gigadevices.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I am sorry to bother you but after hours of searching google without luck I thought I'd ask you what might take you 5 minutes to answer if you please would.

I have developed a custom hardware which can host one or two cameras and I am a little confused (mainly because I can't seem to find up-to-date documentation on how to do it) as to:

- Which files do I need to modify so that soc-camera "knows" where/how to access the hardware pins where the camera is connected to.

- I'm not sure I understand how the H/V sync works. My camera is connected to a parallel interface which is designed to do DMA into memory (clocked by the camera pixel clock). Don't the H/V signals need to generate an interrupt to reset the DMA addresses? It appears as the soc infrastructure does not require that but I don't understand how the drivers know that a new frame is available?

- Curently, the hardware I designed is designed to handle one camera at once but I have been asked if it would be possible to modify the hardware to run both cameras at once (which I can easily do). How would you recommend implementing stereo-vision? If both cameras are of the same kind (same driver), I am also a little confused how the same soc driver would know which one of the two hardwares it needs to bind to.

If you could just point me to *any* documentation that would explain (something up-to-date) how to adapt linux to match my hardware, I would GREATLY appreciate it as I am a bit lost.

Thank you,
Gilles
.
