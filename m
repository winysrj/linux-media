Return-path: <video4linux-list-bounces@redhat.com>
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 7 Jan 2009 15:42:59 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403ECEDD6F4@dbde02.ent.ti.com>
In-Reply-To: <20090107073959.140cfcfd@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [REVIEW PATCH 1/2] OMAP3 ISP-Camera: Added BT656 support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> Sent: Wednesday, January 07, 2009 3:10 PM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; video4linux-list@redhat.com; linux-
> media@vger.kernel.org
> Subject: Re: [REVIEW PATCH 1/2] OMAP3 ISP-Camera: Added BT656
> support
> 
> On Wed,  7 Jan 2009 11:37:20 +0530
> hvaibhav@ti.com wrote:
> 
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Support for BT656 through TVP5146 decoder, works on top of
> > ISP-Camera patches posted by Sergio on 12th Dec 2008.
> >
> > The TVP514x driver patch has been accepted under V4L, will
> > be part of O-L in the next merge window. As of now you can
> > access the patches from -
> >
> >
> http://markmail.org/search/?q=TVP514x#query:TVP514x%20from%3A%22Hire
> math%2C%20Vaibhav%22%20extension%3Apatch+page:1+mid:b5pcj3sriwknm2cv
> +state:results
> >
> > ToDO List:
> >     - Add support for scaling and cropping
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > Signed-off-by: R Sivaraj <sivaraj@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  drivers/media/video/isp/isp.c     |  118 ++++++++++++++++++++---
> >  drivers/media/video/isp/isp.h     |    7 +-
> >  drivers/media/video/isp/ispccdc.c |  146 +++++++++++++++++++++++-
> ---
> >  drivers/media/video/isp/ispccdc.h |    9 ++
> >  drivers/media/video/omap34xxcam.c |  197
> +++++++++++++++++++++++++++++++++----
> >  drivers/media/video/omap34xxcam.h |    5 +
> >  6 files changed, 428 insertions(+), 54 deletions(-)
> >  mode change 100644 => 100755 drivers/media/video/isp/isp.c
> >  mode change 100644 => 100755 drivers/media/video/omap34xxcam.c
> >
> Your patch looks OK, but it touched
> drivers/media/video/omap34xxcam.c, that
> doesn't exist yet on my tree, so I can't apply it.
> 
> Could you please submit first the opam34 patch on linux-
> media@vger.kernel.org,
> in order to allow patchwork.kernel.org to track it also, and allow
> me to merge
> the files?
> 
[Hiremath, Vaibhav] Thanks Mauro for quick review. As I mentioned in the description this patch is build on top of ISP-Camera patches posted by Sergio on 12th Dec 2008. I am following up with Sergio on the same and will post the patches soon with review comment fixes.

> Cheers,
> Mauro


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
