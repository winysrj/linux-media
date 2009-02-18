Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1IAbUpN025457
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 05:37:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1IAbGAu015685
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 05:37:16 -0500
Date: Wed, 18 Feb 2009 10:13:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Agustin <gatoguan-os@yahoo.com>
Message-ID: <20090218091340.GB7213@pengutronix.de>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50561.11594.qm@web32108.mail.mud.yahoo.com>
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

Hi,

On Tue, Feb 17, 2009 at 10:36:01AM -0800, Agustin wrote:
> Hi Guennadi,
> 
> I am trying to integrate your "mx3_camera" (soc-camera) driver into latest
> MXC kernel tree in order to be able to use it along with other drivers I need
> (specially USB and SDHC storage).
> 
> I am using branch "mxc-devel" from git://git.pengutronix.de/git/imx/linux-2.6

Please don't. Please use the mxc-master or mxc-master-flat branch instead. See
my mail recently posted here. Guennadis camera patches will probably fit better
on this tree.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
