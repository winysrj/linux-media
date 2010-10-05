Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab0JEAIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 20:08:00 -0400
Received: by wwj40 with SMTP id 40so4891772wwj.1
        for <linux-media@vger.kernel.org>; Mon, 04 Oct 2010 17:07:59 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Oct 2010 19:07:59 -0500
Message-ID: <AANLkTimHxwS0mdeHC=az0kq-L8uSKNJ57Qv4TS9=etNs@mail.gmail.com>
Subject: Help adding support for Hauppauge HVR-850 (latest version w/ USB ID 2040:b140)
From: Seth Jennings <spartacus06@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

The most recent version of the Hauppauge WinTV HVR-850 is currently
not supported.  The previous two hardware versions with USB ID
2040:651f and 2040:7240 are supported but the most recent version with
USB ID 2040:b140 is not.

I have identified the components in this new version (through a
combination of reading the .inf file for the Windows driver and
cracking the device open):

Interface Bridge: CX23100
Tuner: LGDT3305
Demodulator: TDA18271HDC2

More details in my post on the discussion page for the device on the
v4l-dvb wiki:
http://linuxtv.org/wiki/index.php/Talk:Hauppauge_WinTV-HVR-850#Possibly_Valuable_Information

I believe that all these components already have drivers available.  I
just don't have the experience to get them together in the cx231xx
module.

All previous HVR-850 and 950(Q) USB devices used the em28xx or au0828
bridge interface, so I don't have a template to work from in the
cx231xx module.  Discovering the gpio configuration is also beyond my
experience.

Any help?  Or any existing development on this that I don't know about?

Thanks,
Seth
