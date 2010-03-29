Return-path: <linux-media-owner@vger.kernel.org>
Received: from web113202.mail.gq1.yahoo.com ([98.136.165.123]:45102 "HELO
	web113202.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752272Ab0C2PIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 11:08:01 -0400
Message-ID: <904368.99706.qm@web113202.mail.gq1.yahoo.com>
Date: Mon, 29 Mar 2010 08:07:59 -0700 (PDT)
From: Don Kramer <gedaliah_atl@yahoo.com>
Subject: Plextor ConvertX AV100U update; works but have not gotten highest resolution yet
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Good news.  I have gotten the Plextor ConvertX AV100U to work in Linux.  It's this device:

http://www.overclockersonline.net/images/articles/plextor/av100u/large/pcb.jpg

with the eMPIA EM2820 chip. 

It requires this coding addition in em28xx-cards-c:

{ USB_DEVICE(0x093b, 0xa003),
            .driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Plextor Corp. ConvertX AV100U A/V Capture Audio */

So I have video.  Only problem is in VLC Player and kdenlive have not been able to get 720 x 480 resolution even through I know the device is capable of it.  Any advice?


      
