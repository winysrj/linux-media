Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:35758 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab0CDXVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 18:21:19 -0500
Date: Thu, 4 Mar 2010 17:44:15 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: linux-media@vger.kernel.org
cc: Hans de Goede <hdegoede@redhat.com>
Subject: "Invalid module format"
Message-ID: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I just upgraded to the stock 2.6.33 kernel in Slackware-current. Also 
after having the troubles described below I cloned a completely new copy 
of the gspca tree from http://linuxtv.org/hg/~hgoede/gspca, intending to 
get some work done on a project recently started.

I did make menuconfig (preceded on the first occasion by make distclean, 
of course) and chose my options. Then I did make and make install. When I 
plugged in a camera, nothing. So I tried modprobe gspca_main and here is 
what happens

root@khayyam:/home/kilgota/linux/gspca/gspca_hans_new3/gspca# modprobe 
gspca_main
WARNING: Error inserting v4l1_compat 
(/lib/modules/2.6.33-smp/kernel/drivers/media/video/v4l1-compat.ko): 
Invalid module format
WARNING: Error inserting videodev 
(/lib/modules/2.6.33-smp/kernel/drivers/media/video/videodev.ko): Invalid 
module format
FATAL: Error inserting gspca_main 
(/lib/modules/2.6.33-smp/kernel/drivers/media/video/gspca/gspca_main.ko): 
Invalid module format
root@khayyam:/home/kilgota/linux/gspca/gspca_hans_new3/gspca#

Any suggestions?

Theodore Kilgore


