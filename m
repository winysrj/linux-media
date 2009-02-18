Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1IBWw1g018926
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 06:32:58 -0500
Received: from web32101.mail.mud.yahoo.com (web32101.mail.mud.yahoo.com
	[68.142.207.115])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1IBWi7d032279
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 06:32:44 -0500
References: <50561.11594.qm@web32108.mail.mud.yahoo.com>
	<20090218091340.GB7213@pengutronix.de>
Date: Wed, 18 Feb 2009 03:32:43 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <25863.16869.qm@web32101.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux list <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: Rv: mx3-camera on current mxc kernel tree
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Sascha,



--- Sascha Hauer wrote:
> On Tue, Feb 17, 2009 at 10:36:01AM -0800, Agustin wrote:
> > I am using branch "mxc-devel" from git://git.pengutronix.de/git/imx/linux-2.6
> 
> Please don't. Please use the mxc-master or mxc-master-flat branch instead. See
> my mail recently posted here. Guennadis camera patches will probably fit better
> on this tree.

Well, I tried both 'mxc-master' and 'mxc-master-flat' but both seemed to have broken support for PCM037. Build stopped, complaining about missing "i2c.h" included from "pcm037.c". Probably the result of partial inegration of I2C support, which I need to have. On the other hand, 'mxc-devel' was buiding and working all right, that's why I am using it.

Will try again with 'master' branches...

Regards,
--Agustín.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
