Return-path: <mchehab@gaivota>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37704 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0KFTEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 15:04:45 -0400
Received: by qyk10 with SMTP id 10so3779968qyk.19
        for <linux-media@vger.kernel.org>; Sat, 06 Nov 2010 12:04:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 6 Nov 2010 22:34:44 +0330
Message-ID: <AANLkTim9kkFuORZHwtC+Wd2BN8HJRxCtEr+2zP5P9cx3@mail.gmail.com>
Subject: Analog TV shoow has not sound
From: dehqan65 <dehqan65@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

In The Name Of God The compassionate merciful


Hello ;
Good day
i-humble have bought a usb hybrid dongel with tlg2300 chipset.
dvb-t works fine with vlc .
 .
1-but analog TV has not sound .(while there is no susppend and hibrenate before)
these 2 ways both have not sound with tv show:

mplayer -tv chanlist=us-bcast tv://

OR

vlc v4l2:///dev/video0  :input-slave=alsa://hw:1,0 :v4l2-standard=1
:v4l2-tuner-frequency=495250

audio codec of analog tv is :PCM S16LE (araw)
what is the problem , how to solve it ?
maybe you need this http://pastebin.com/dYwAQFxq

Regards dehqan
