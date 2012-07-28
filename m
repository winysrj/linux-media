Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43492 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab2G1Qwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 12:52:37 -0400
Subject: Re: [PATCH] cx25840: Declare MODULE_FIRMWARE usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Date: Sat, 28 Jul 2012 12:52:01 -0400
In-Reply-To: <50128446.1010609@canonical.com>
References: <1343321059-124171-1-git-send-email-tim.gardner@canonical.com>
	 <1343339959.2575.3.camel@palomino.walls.org>
	 <50128446.1010609@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1343494323.2476.11.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-07-27 at 06:06 -0600, Tim Gardner wrote:
> On 07/26/2012 03:59 PM, Andy Walls wrote:
> > On Thu, 2012-07-26 at 10:44 -0600, Tim Gardner wrote:
> >> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> >> Cc: linux-media@vger.kernel.org
> >> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >> ---
> >>   drivers/media/video/cx25840/cx25840-firmware.c |   15 ++++++++++++---
> >>   1 file changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
> >> index 8150200..b3169f9 100644
> >> --- a/drivers/media/video/cx25840/cx25840-firmware.c
> >> +++ b/drivers/media/video/cx25840/cx25840-firmware.c
> >> @@ -61,6 +61,10 @@ static void end_fw_load(struct i2c_client *client)
> >>   	cx25840_write(client, 0x803, 0x03);
> >>   }
> >>
> >> +#define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
> >> +#define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
> >> +#define CX25840_FIRMWARE "v4l-cx25840.fw"
> >> +
> >>   static const char *get_fw_name(struct i2c_client *client)
> >>   {
> >>   	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
> >> @@ -68,10 +72,10 @@ static const char *get_fw_name(struct i2c_client *client)
> >>   	if (firmware[0])
> >>   		return firmware;
> >>   	if (is_cx2388x(state))
> >> -		return "v4l-cx23885-avcore-01.fw";
> >> +		return CX2388x_FIRMWARE;
> >>   	if (is_cx231xx(state))
> >> -		return "v4l-cx231xx-avcore-01.fw";
> >> -	return "v4l-cx25840.fw";
> >> +		return CX231xx_FIRMWARE;
> >> +	return CX25840_FIRMWARE;
> >>   }
> >>
> >>   static int check_fw_load(struct i2c_client *client, int size)
> >> @@ -164,3 +168,8 @@ int cx25840_loadfw(struct i2c_client *client)
> >>
> >>   	return check_fw_load(client, size);
> >>   }
> >> +
> >> +MODULE_FIRMWARE(CX2388x_FIRMWARE);
> >> +MODULE_FIRMWARE(CX231xx_FIRMWARE);
> >> +MODULE_FIRMWARE(CX25840_FIRMWARE);
> >> +
> >
> > How will the firmware attribute in the .module_info section be used?
> >
> > For any one model of TV capture device, the cx25840 only needs one of
> > the above firmware files.  The others need not exist.
> >
> > I would not want anything in user or kernel space to refuse to load the
> > module just because all 3 firmware files are not present.
> >
> > Regards,
> > Andy
> >
> 
> The MODULE_FIRMWARE macro is purely informational. Declaring the 
> firmware files that the driver _might_ use helps me pare down the 
> external firmware package to just those files that I know it must have.

Would it help if the MODULE_FIRMWARE text was more descriptive, e.g.:

MODULE_FIRMWARE(CX25840_FIRMWARE " CX25840/1/2/3 chips only");
MODULE_FIRMWARE(CX231xx_FIRMWARE " CX23100/1/2 chips only");
MODULE_FIRMWARE(CX2388x_FIRMWARE " CX23885/7/8 chips only");

Similarly for ivtv:

MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
MODULE_FIRMWARE(CX2341X_FIRM_DEC_FILENAME " PVR-350 only");
MODULE_FIRMWARE(IVTV_DECODE_INIT_MPEG_FILENAME " PVR-350 only");

and cx18:

MODULE_FIRMWARE(FWFILE); /* v4l-cx23418-dig.fw */
MODULE_FIRMWARE(CX18_CPU_FIRMWARE);
MODULE_FIRMWARE(CX18_APU_FIRMWARE);
MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE " Non-HVR-1600 cards");
MODULE_FIRMWARE(FWFILE " Yuan MPC-718 only");

or would that confuse some userspace tools?

>  
> This patch will have no runtime impact.

OK.  For the original patch:

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> Note that there are plenty of uses of the MODULE_FIRMWARE macro within 
> the kernel.
> 
> rtg


