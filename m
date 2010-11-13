Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:59886 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab0KMJpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 04:45:21 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id B463FD48187
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 10:45:11 +0100 (CET)
Date: Sat, 13 Nov 2010 10:46:43 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-ID: <20101113104643.2b99e160@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3:

  [media] IR: add tv power scancode to rc6 mce keymap (2010-11-10 00:58:49 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.38

Jean-François Moine (16):
      gspca - ov519: Handle the snapshot on capture stop when CONFIG_INPUT=m
      gspca - ov519: Don't do USB exchanges after disconnection
      gspca - ov519: Change types '__xx' to 'xx'
      gspca - ov519: Reduce the size of some variables
      gspca - ov519: Define the sensor types in an enum
      gspca - ov519: Cleanup source
      gspca - ov519: Set their numbers in the ov519 and ov7670 register names
      gspca - ov519: Define the disabled controls in a table
      gspca - ov519: Propagate errors to higher level
      gspca - ov519: Clearer debug and error messages
      gspca - ov519: Check the disabled controls at start time only
      gspca - ov519: Simplify the LED control functions
      gspca - ov519: Change the ov519 start and stop sequences
      gspca - ov519: Initialize the ov519 snapshot register
      gspca - ov519: Re-initialize the webcam at resume time
      gspca - ov519: New sensor ov7660 with bridge ov530 (ov519)

Nicolas Kaiser (1):
      gspca - cpia1: Fix error check

 drivers/media/video/gspca/cpia1.c   |    2 +-
 drivers/media/video/gspca/ov519.c   | 1671 +++++++++++++++++++++--------------
 drivers/media/video/gspca/w996Xcf.c |  325 +++----
 3 files changed, 1131 insertions(+), 867 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
