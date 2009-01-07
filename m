Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 7 Jan 2009 07:39:59 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hvaibhav@ti.com
Message-ID: <20090107073959.140cfcfd@pedra.chehab.org>
In-Reply-To: <1231308440-31122-1-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	<1231308440-31122-1-git-send-email-hvaibhav@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 1/2] OMAP3 ISP-Camera: Added BT656 support
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

On Wed,  7 Jan 2009 11:37:20 +0530
hvaibhav@ti.com wrote:

> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Support for BT656 through TVP5146 decoder, works on top of
> ISP-Camera patches posted by Sergio on 12th Dec 2008.
> 
> The TVP514x driver patch has been accepted under V4L, will
> be part of O-L in the next merge window. As of now you can
> access the patches from -
> 
> http://markmail.org/search/?q=TVP514x#query:TVP514x%20from%3A%22Hiremath%2C%20Vaibhav%22%20extension%3Apatch+page:1+mid:b5pcj3sriwknm2cv+state:results
> 
> ToDO List:
>     - Add support for scaling and cropping
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: R Sivaraj <sivaraj@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/isp/isp.c     |  118 ++++++++++++++++++++---
>  drivers/media/video/isp/isp.h     |    7 +-
>  drivers/media/video/isp/ispccdc.c |  146 +++++++++++++++++++++++----
>  drivers/media/video/isp/ispccdc.h |    9 ++
>  drivers/media/video/omap34xxcam.c |  197 +++++++++++++++++++++++++++++++++----
>  drivers/media/video/omap34xxcam.h |    5 +
>  6 files changed, 428 insertions(+), 54 deletions(-)
>  mode change 100644 => 100755 drivers/media/video/isp/isp.c
>  mode change 100644 => 100755 drivers/media/video/omap34xxcam.c
> 
Your patch looks OK, but it touched drivers/media/video/omap34xxcam.c, that
doesn't exist yet on my tree, so I can't apply it.

Could you please submit first the opam34 patch on linux-media@vger.kernel.org,
in order to allow patchwork.kernel.org to track it also, and allow me to merge
the files?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
