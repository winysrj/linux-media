Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:47450 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912Ab2FURFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 13:05:25 -0400
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: Zhu Sha Zang <zhushazang@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 21 Jun 2012 18:07:04 +0100
Subject: RE: DiBcom adapter problems
Message-ID: <C73E570AC040D442A4DD326F39F0F00E138E9533EE@SAPHIR.xi-lite.lan>
References: <4FDDE29B.9040500@gmail.com>
 <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>,<4FE31AB1.7020706@gmail.com>
In-Reply-To: <4FE31AB1.7020706@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
can you test the following patch.

regards,
Olivier

From: Olivier Grenie <olivier.grenie@parrot.com>
Date: Thu, 21 Jun 2012 18:57:14 +0200
Subject: [PATCH] [media] dvb frontend core: tuning in ISDB-T using DVB API v3
 The intend of this patch is to be able to tune ISDB-T using
 the DVB API v3

Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index aebcdf2..ee1cc10 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1531,6 +1531,13 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
                                delsys = desired_system;
                                break;
                        }
+
+                       /* check if the fe delivery system corresponds
+                          to the delivery system in cache */
+                       if (fe->ops.delsys[ncaps] == c->delivery_system) {
+                               delsys = c->delivery_system;
+                               break;
+                       }
                        ncaps++;
                }
                if (delsys == SYS_UNDEFINED) {
-- 
1.7.9.5

________________________________________
From: Zhu Sha Zang [zhushazang@gmail.com]
Sent: Thursday, June 21, 2012 2:59 PM
To: linux-media@vger.kernel.org
Cc: Olivier GRENIE
Subject: Re: DiBcom adapter problems

Ok, my kernel versions are 3.4.2 and 3.4.3.

The apps used to tune are

media-tv/w_scan - http://wirbel.htpc-forum.de/w_scan/index2.html
media-tv/linuxtv-dvb-apps (dvbscan) - http://www.linuxtv.org/
media-video/vlc - http://www.videolan.org/vlc/
media-video/kaffeine - http://kaffeine.kde.org/

A six month later i've already created a channels.conf and still working
with vlc.

A question: How to set debug parameter using modprobe?

Something like, "modrobe dib8000 debug=1; modprobe dvb-core debug=1"?


Thanks for now.

Em 19-06-2012 12:43, Olivier GRENIE escreveu:
> Hello,
> can you provide more information:
>      - kernel version
>      - more log information (not only the error message but also the log from the beginning, when you plug the device) with:
>            * the debug parameter of the dib8000 module set to 1
>            * the frontend_debug parameter of the dvb-core module set to 1
>      - which application do you use to tune the board
>
> regards,
> Olivier
> ________________________________________
> From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Rodolfo Timoteo da Silva [zhushazang@gmail.com]
> Sent: Sunday, June 17, 2012 3:58 PM
> To: linux-media@vger.kernel.org
> Subject: DiBcom adapter problems
>
> Hi, every time that i try to syntonize DVB-T channels i receive a
> message in kernel like in log1.txt arch.
>
> There are in log2.txt some usefull information about the device.
>
> My kernel/system is:
>
>
> Linux version 3.4.2-gentoo-r1-asgard (root@asgard) (gcc version 4.6.3
> (Gentoo 4.6.3 p1.3, pie-0.5.2) ) #1 SMP PREEMPT Thu Jun 14 07:45:19 BRT 2012
>
> Best Regards
>


--

---
Rodolfo Timóteo da Silva
Linux Counter: 359362
msn: zhushazang@gmail.com
skype: zhushazang

Ribeirão Preto - SP


