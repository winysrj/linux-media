Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:59369 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0AMIdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 03:33:01 -0500
Received: from [192.168.1.2] (151.49.4.3) by cp-out11.libero.it (8.5.119)
        id 4AE04A3D114C6F58 for linux-media@vger.kernel.org; Wed, 13 Jan 2010 09:33:00 +0100
To: linux-media@vger.kernel.org
Subject: Re: problem webcam gspca 2.6.32
Content-Disposition: inline
From: sacarde <sacarde@tiscali.it>
Date: Wed, 13 Jan 2010 09:32:59 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001130932.59955.sacarde@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alle sabato 09 gennaio 2010, hai scritto:
> On Sat, 9 Jan 2010 15:06:14 +0100

... Jean-Francois Moine write:
> I got the source of sunplus.c in the last kernel 2.6.32 and I build the
> attached patch. May you test it?

ok, I build with your patch diff-2.6.32

- now "mplayer tv:// "  works OK !!



- now "cheese -v" once it works and once no (I can view only black-window) 

...when works...
Probing devices with HAL...
Found device 0471:0322, getting capabilities...
Detected v4l2 device: USB Camera (0471:0322)
Driver: sunplus, version: 132864
Capabilities: 0x05000001

Probing supported video formats...
Device: USB Camera (0471:0322) (/dev/video0)
FractionRange: 0/1 - 100/1
video/x-raw-rgb 640 x 480 num_framerates 101
0/1 1/1 2/1 3/1 4/1 5/1 6/1 7/1 8/1 9/1 10 ... ...
... etc 


thanks 

sacarde@tiscali.it
