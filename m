Return-path: <mchehab@pedra>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:54522
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab0JQF2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 01:28:53 -0400
Message-ID: <4CBA8992.1010504@comcast.net>
Date: Sat, 16 Oct 2010 22:28:50 -0700
From: Douglas Peale <Douglas_Peale@comcast.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Video4Linux Control Panel Preview uses wrong device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have two video devices in my system. Usually they are:
/dev/video0 A Microsoft LifeCam Cinema
/dev/video1 An ATI HDTV Wonder

but sometimes the devices get swapped.

I have been trying to debug the ATI HDTV Wonder, but ran into a problem with the Video4Linux Control Panel.

No mater how I start v4l2ucp such that it is displaying & editing /dev/video1, when I select preview, it selects /dev/video0
instead. I know that it is selecting /dev/video1 because I am trying to preview the ATI HDTV Wonder, but the blue LED on the web
cam comes on, and I get audio feedback from the microphone on the camera through my speakers.

I will be happy to provide more information if you will tell me what information you need (and how to get it, as my experience
with linux is limited.)

v4l2ucp Version 2.0.2
