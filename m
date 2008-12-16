Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGKPoC4006005
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 15:25:50 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGKPDF5028112
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 15:25:14 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Date: Tue, 16 Dec 2008 14:24:56 -0600
Message-ID: <A24693684029E5489D1D202277BE894415FC92FD@dlee02.ent.ti.com>
In-Reply-To: <208cbae30812112203o6be4974epb87b3810e2de3581@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: RE: [REVIEW PATCH 13/14] OMAP: CAM: Add Lens Driver
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

> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Alexey Klimov
> Sent: Friday, December 12, 2008 12:03 AM

> On Thu, Dec 11, 2008 at 11:38 PM, Aguirre Rodriguez, Sergio Alberto
> <saaguirre@ti.com> wrote:
> > >From 1341b74f5a90e4aa079a4fcb4fe2127ff344cce7 Mon Sep 17 00:00:00 2001
> > From: Sergio Aguirre <saaguirre@ti.com>
> > Date: Thu, 11 Dec 2008 13:35:46 -0600
> > Subject: [PATCH] OMAP: CAM: Add Lens Driver
> >
> > This adds the DW9710 Lens driver
> >
> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---

> > +#define DRIVER_NAME  "dw9710"
> 
> Here you define DRIVER_NAME. I saw patch(for another module) that
> remover MODULE_NAME and places VIVI_MODULE_NAME there. Here it is:
> http://linuxtv.org/hg/v4l-dvb/rev/58b95134acb8
> 
> May be it's better to define something like this: #define
> DW9710_DRIVER_NAME  "dw9710" ?
> 
> Probably it will help you to avoid possible namespace conflicts and
> code become a bit more readible.
[Aguirre, Sergio] You're right. Thanks.

> 
> > +static int
> > +dw9710_probe(struct i2c_client *client, const struct i2c_device_id
> *id);
> > +static int __exit dw9710_remove(struct i2c_client *client);
> > +
> > +struct dw9710_device {
> > +       const struct dw9710_platform_data *pdata;
> > +       struct v4l2_int_device *v4l2_int_device;
> > +       struct i2c_client *i2c_client;
> > +       int opened;
> > +       u16 current_lens_posn;
> > +       u16 saved_lens_posn;
> > +       int state;
> > +       int power_state;
> > +};
> > +
> > +static const struct i2c_device_id dw9710_id[] = {
> > +       { DW9710_NAME, 0 },
> > +       { }
> > +};
> 
> Hmmm, looks like you already defined DW9710_NAME in header-file. Why
> didn't you reformat to use _one_ define for this and previous place ?
> 
> > +MODULE_DEVICE_TABLE(i2c, dw9710_id);
> > +
> > +static struct i2c_driver dw9710_i2c_driver = {
> > +       .driver = {
> > +               .name = DW9710_NAME,
> 
> Actually, the same thing here.
> 

[Aguirre, Sergio] Ok, done. Now I use only one define: DW9710_NAME. Thanks.

> > +static int
> > +find_vctrl(int id)
> > +{
> > +       int i;
> > +
> > +       if (id < V4L2_CID_BASE)
> > +               return -EDOM;
> > +
> > +       for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
> > +               if (video_control[i].qc.id == id)
> > +                       break;
> > +       if (i < 0)
> > +               i = -EINVAL;
> > +       return i;
> > +}
> 
> In this function you use return after if, and in second place you set
> i equals to -EINVAL, and then return. Probably, to make it more easily
> to read it's better to do such thing:
> 
> if (i < 0)
> return -EINVAL;
> 
[Aguirre, Sergio] Ok, I agree it's a bit confusing... I have rewritten the function to be more simple, is it ok now?:

static int find_vctrl(int id)
{
	int i;

	if (id < V4L2_CID_BASE)
		return -EDOM;

	for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--) {
		if (video_control[i].qc.id == id)
			return i;
	}

	return -EINVAL;
}

> > +       if (wposn != rposn) {
> > +               printk(KERN_ERR "W/R MISMATCH!\n");
> 
> If I were writing it, I'd do the following:
> 
> printk(KERN_ERR DRIVER_NAME "W/R MISMATCH!\n");
> 
> And driver-name have to be unique, see above.
> To be onest it's better to provide module name to dmesg if you(or any
> user) want to catch bad behavour.
[Aguirre, Sergio] Ok, point taken. Thanks.

> > +int dw9710_af_getfocus(u16 *value)
> > +{
> > +       int ret = -EINVAL;
> > +       u16 posn = 0;
> 
> Why just don't use int ret;
> And later in code use return -EINVAL; ?
> Anyway, you change ret variable with reg_read call.
[Aguirre, Sergio] Ok, Makes sense. Thanks.
> 
> > +       struct dw9710_device *af_dev = &dw9710;
> > +       struct i2c_client *client = af_dev->i2c_client;
> > +
> > +       if ((af_dev->power_state == V4L2_POWER_OFF) ||
> > +          (af_dev->power_state == V4L2_POWER_STANDBY))
> > +               return ret;
> > +
> > +       ret = camaf_reg_read(client, &posn);
> > +
> > +       if (ret) {
> > +               printk(KERN_ERR "Read of current Lens position
> failed\n");
> > +               return ret;
> > +       }
> > +       *value = CAMAF_DW9710_DATA_R(posn);
> > +       dw9710.current_lens_posn = CAMAF_DW9710_DATA_R(posn);
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL(dw9710_af_getfocus);

> > +       if ((on == V4L2_POWER_ON) && (lens->state == LENS_NOT_DETECTED))
> {
> > +               rval = dw9710_detect(c);
> > +               if (rval < 0) {
> > +                       dev_err(&c->dev, "Unable to detect "
> > +                               DRIVER_NAME " lens HW\n");
> > +                       printk(KERN_ERR "Unable to detect "
> > +                               DRIVER_NAME " lens HW\n");
> 
> Two thing here. As i know it's more preferable to use dev_macro
> instead of printk if possible.
> As i know(may be i'm wrong) it's not good to use DRIVER_NAME in dev_err
> here.
> Why do you print the same text two times here ?
[Aguirre, Sergio] Ok, cleaning this up. Thanks

> > +static int __init dw9710_init(void)
> > +{
> > +       int err = -EINVAL;
> 
> int err = something, and then changed with call to i2c..
> 
> This is all i can suggest, it's not about functionality, it's about
> coding style..
> Please, use dev_macros if possible instead of printk.
> 
[Aguirre, Sergio] Ok, will do that. Thanks

I really appreciate all your time doing this.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
