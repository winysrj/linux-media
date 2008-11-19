Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ47lAq008826
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 23:07:47 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ46jj7032704
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 23:06:45 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Ben Dooks <ben-linux@fluff.org>, "Shah, Hardik" <hardik.shah@ti.com>
Date: Wed, 19 Nov 2008 09:36:15 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E8E6762A@dbde02.ent.ti.com>
In-Reply-To: <20081118181057.GA15652@fluff.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: RE: [Linux-fbdev-devel] [PATCHv3 1/4] OMAP 2/3 DSS Library
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



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Ben Dooks [mailto:ben-linux@fluff.org]
> Sent: Tuesday, November 18, 2008 11:41 PM
> To: Shah, Hardik
> Cc: video4linux-list@redhat.com; linux-omap@vger.kernel.org; linux-
> fbdev-devel@lists.sourceforge.net
> Subject: Re: [Linux-fbdev-devel] [PATCHv3 1/4] OMAP 2/3 DSS Library
> 
> On Tue, Nov 04, 2008 at 02:49:17PM +0530, Hardik Shah wrote:
> > Removed the io_p2v macro and used ioremap and
> > __raw_readl/__raw_writel instead.
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> >  		Hari Nagalla <hnagalla@ti.com>
> >  		Hardik Shah <hardik.shah@ti.com>
> >  		Manjunath Hadli <mrh@ti.com>
> >  		R Sivaraj <sivaraj@ti.com>
> >  		Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > ---
> >  arch/arm/plat-omap/Kconfig                 |    7 +
> >  arch/arm/plat-omap/Makefile                |    2 +-
> >  arch/arm/plat-omap/include/mach/omap-dss.h |  896 +++++++++++
> >  arch/arm/plat-omap/omap-dss.c              | 2268
> ++++++++++++++++++++++++++++
> 
> why is this huge driver under arch/arm/plat-omap?
> 
[Hiremath, Vaibhav] omap-dss.c is the OMAP-DSS library which will export low level API's to upper level driver (V4L2 and FBDEV). For more information please refer to the RFC which we had posted some time back, below is the link

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg02510.html


Again this is the old story on OMAP3-DSS development, there was parallel development from Nokia and we had acknowledged their design and implementation and started working/developing on top of it.

> >  4 files changed, 3172 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/plat-omap/include/mach/omap-dss.h
> >  create mode 100644 arch/arm/plat-omap/omap-dss.c

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
