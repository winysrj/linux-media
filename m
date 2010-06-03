Return-path: <linux-media-owner@vger.kernel.org>
Received: from web113211.mail.gq1.yahoo.com ([98.136.164.164]:47587 "HELO
	web113211.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752139Ab0FCNSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 09:18:20 -0400
Message-ID: <113272.38986.qm@web113211.mail.gq1.yahoo.com>
Date: Thu, 3 Jun 2010 06:11:40 -0700 (PDT)
From: Don Kramer <gedaliah_atl@yahoo.com>
Subject: changed em28xx-cards-c; Plextor ConvertX AV100U now works!
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm new to this.  I wanted to get the Plextor ConvertX AV100U (with a eMPIA EM2820 chip) to run in Ubuntu 10.04. This was made circa 2004 and
to the best of my knowledge the only official drives for it are Windows XP.

This is the device:

http://www.overclockersonline.net/reviews/5000198/

and this is the board:

http://www.overclockersonline.net/images/articles/plextor/av100u/large/pcb.jpg

and by adding this code to em28xx-cards-c

{ USB_DEVICE(0x093b, 0xa003),
            .driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Plextor Corp. ConvertX AV100U A/V Capture Audio */

It works! 

I'm opening it as a capture device in VLC Player.  Video is high quality, only defect is a green bar on maybe the lower 15% of the screen.  So three questions:

1) how do I address the green bar?

2) how to I get audio?  I can see the device in Ubuntu under sound preferences. How do I identify what the audio device name is?

3) What is the process to submit this change to em28xx-cards-c for v4l2?

Thanks,

Don Kramer
Atlanta, GA.


      
