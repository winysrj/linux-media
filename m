Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJ8uVs003038
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:08:56 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALJ7v86013497
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:07:57 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Trilok Soni <soni.trilok@gmail.com>
Date: Sat, 22 Nov 2008 00:37:43 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E8E67E5E@dbde02.ent.ti.com>
In-Reply-To: <5d5443650811211012t238dd191t81680c45717d8337@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>
Subject: RE: [PATCH 2/2] TVP514x V4L int device driver support
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
> From: Trilok Soni [mailto:soni.trilok@gmail.com]
> Sent: Friday, November 21, 2008 11:43 PM
> To: Hiremath, Vaibhav
> Cc: video4linux-list@redhat.com; linux-omap@vger.kernel.org;
> davinci-linux-open-source-bounces@linux.davincidsp.com
> Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
> 
> Hi Vaibhav,
> 
> On Fri, Nov 21, 2008 at 8:52 PM,  <hvaibhav@ti.com> wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Added new V4L2 slave driver for TVP514x.
> >
> > The Driver interface has been tested on OMAP3EVM board
> > with TI daughter card (TVP5146). Soon the patch for Daughter card
> will
> > be posted on community.
> 
> You may want to add some of the TVP5146 video decoder capabilities
> in
> commit text. Useful for someone who just sees this chip for first
> time.
> 
[Hiremath, Vaibhav] Will take care next time.
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> >                Hardik Shah <hardik.shah@ti.com>
> >                Manjunath Hadli <mrh@ti.com>
> >                R Sivaraj <sivaraj@ti.com>
> >                Vaibhav Hiremath <hvaibhav@ti.com>
> >                Karicheri Muralidharan <m-karicheri2@ti.com>
> 
> I suggested to change this in another email.
> 
[Hiremath, Vaibhav] Point taken.
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-int-device.h>
> 
> Convention is is to put empty line between  #include <linux/xxx.h>
> and
> first #include <nonlinux/xxx.h> which is #include
> <media/v4l2-int-device.h>
> 
[Hiremath, Vaibhav] I had referred to the other driver files under media/video/ (e.g. tvp5150) which doesn't follow this. Not sure about actual convention, but it looks like line break is expected between standard include (linux or non-linux) and local include.
E.g.
include <linux/xxx.h>
include <media/yyy.h>

Include "zzz.h"


> > +#include <media/tvp514x.h>
> > +
> 
> > +
> > +/* List of image formats supported by TVP5146/47 decoder
> > + * Currently we are using 8 bit mode only, but can be
> > + * extended to 10/20 bit mode.
> > + */
> > +static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
> > +       {
> > +        .index = 0,
> > +        .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +        .flags = 0,
> > +        .description = "8-bit UYVY 4:2:2 Format",
> > +        .pixelformat = V4L2_PIX_FMT_UYVY,
> > +        }
> 
> Good to add "," after the last element.
> 
> > +static struct tvp514x_std_info tvp514x_std_list[] = {
> > +       {
> > +        .width = NTSC_NUM_ACTIVE_PIXELS,
> > +        .height = NTSC_NUM_ACTIVE_LINES,
> > +        .video_std = VIDEO_STD_NTSC_MJ_BIT,
> > +        .standard = {
> > +                     .index = 0,
> > +                     .id = V4L2_STD_NTSC,
> > +                     .name = "NTSC",
> > +                     .frameperiod = {1001, 30000},
> > +                     .framelines = 525}
> 
> "{" after 525 looks weird.
> 
> > +        },
> > +       {
> 
> You can put "{" with "}" to save one line . Like this
> 
> "}, {"
> 
[Hiremath, Vaibhav] Point taken.

> You may want to make similar changes at other places in the patch.
> 
> > +static enum tvp514x_std tvp514x_get_current_std(struct
> tvp514x_decoder
> > +                                               *decoder)
> > +{
> > +       u8 std, std_status;
> > +
> > +       if (tvp514x_read_reg(decoder->client, REG_VIDEO_STD,
> &std))
> > +               return STD_INVALID;
> > +
> > +       if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT) {
> > +               /* use the standard status register */
> > +               if (tvp514x_read_reg(decoder->client,
> REG_VIDEO_STD_STATUS,
> > +                                    &std_status))
> > +                       return STD_INVALID;
> > +       } else
> > +               std_status = std;       /* use the standard
> register itself */
> > +
> > +       switch (std_status & VIDEO_STD_MASK) {
> > +       case VIDEO_STD_NTSC_MJ_BIT:
> > +               return STD_NTSC_MJ;
> > +               break;
> 
> No need of " break" here.
> 
[Hiremath, Vaibhav] Point taken.

> > +
> > +       case VIDEO_STD_PAL_BDGHIN_BIT:
> > +               return STD_PAL_BDGHIN;
> > +               break;
> 
> Ditto.
> 
> > +
> > +       default:
> > +               return STD_INVALID;
> > +               break;
> 
> Tritto?
> 
> > +       }
> > +
> > +       return STD_INVALID;
> > +}
> > +
> 
> > +
> > +static int
> > +tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id)
> > +{
> 
> Mark this as __init please.
> 
[Hiremath, Vaibhav] Again valid point. I will update the patch with review comments and post it again. Please let me know if there are any more comments.

> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
