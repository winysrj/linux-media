Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB28fCxI002829
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 03:41:12 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB28f1im017360
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 03:41:01 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Date: Tue, 2 Dec 2008 14:10:49 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904F1E7@dbde02.ent.ti.com>
In-Reply-To: <200812020034.53544.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>
Subject: RE: [PATCH 2/2] TVP514x Driver with Review comments fixed
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
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Tuesday, December 02, 2008 2:05 PM
> To: Hiremath, Vaibhav
> Cc: dbrownell@users.sourceforge.net; video4linux-list@redhat.com;
> davinci-linux-open-source-bounces@linux.davincidsp.com; linux-
> omap@vger.kernel.org; Jadav, Brijesh R; Shah, Hardik; Hadli,
> Manjunath; R, Sivaraj; Karicheri, Muralidharan
> Subject: Re: [PATCH 2/2] TVP514x Driver with Review comments fixed
> 
> On Monday 01 December 2008, David Brownell wrote:
> > >         - Pointer to init_reg_seq, which is pointer to array of
> structure
> > >           for tvp514x_regs. This is little bit ugly, since will
> have to
> > >           export tvp514x_regs structure.
> >
> > The platform_data should not hold such stuff; it's not board-
> specific.
> > I'd expect platform_data to hold regulator_init_data as needed to
> > instantiate the regulator; and maybe other stuff needed on this
> board
> > too.  Floor and ceiling parameters, maybe, unless they change at
> runtime.
> 
> Apologies, I was confusing this driver with another.  For a video
> codec, the platform_data should say things like which of the dozen
> or so input channels are wired up, and how; and how the outputs
> are encoded (8 bits, 2x 8 bits, 10 bits, 2x 10 bits, etc).  Nothing
> to do with regulators or DVFS.
> 
> And the id parameter to probe() is enough to tell whether this is
> a '46 device, with extra registers and input channels, or a '47
> that's less capable (but lower power, etc).
> 
> 
[Hiremath, Vaibhav] To avoid any more confusion, I will post the patch again for review, which will give you clear picture.

> > The init sequence wouldn't matter at all for i2c_get_clientdata(),
> > since it should only kick in during probe().
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
