Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0CKHE4f020511
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 15:17:14 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0CKGd0q007721
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 15:16:40 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Mon, 12 Jan 2009 14:16:28 -0600
Message-ID: <A24693684029E5489D1D202277BE894416429BCC@dlee02.ent.ti.com>
In-Reply-To: <200812161807.37601.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: RE: [REVIEW PATCH 08/14] OMAP: CAM: Add ISP Core
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

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]

<snip>

> > +               {
> > +                       .id = V4L2_CID_PRIVATE_ISP_COLOR_FX,
> > +                       .type = V4L2_CTRL_TYPE_INTEGER,
> > +                       .name = "Color Effects",
> 
> What does this do? It definitely looks like this should be a menu, not
> an integer control. Forcing color to B&W is something that other hardware
> can do as well, so I think this is a very good candidate for a generic
> user control, rather than driver specific.

This basically enables some common color effects on image processing:
- Default colors (i.e. original captured colors)
- Sepia colored images
- B&W colored images.

I think its generic enough to propose for a new generic user CID.

Ok, so, should I keep the Private CID as a menu type ctrl by now?

> 
> > +                       .minimum = PREV_DEFAULT_COLOR,
> > +                       .maximum = PREV_BW_COLOR,
> > +                       .step = 1,
> > +                       .default_value = PREV_DEFAULT_COLOR,
> > +               },
> > +               .current_value = PREV_DEFAULT_COLOR,
> > +       }
> > +};
> > +

<snip>

> > +
> > +       if (((isp_obj.if_status == ISP_PARLL) && (if_t == ISP_CSIA)) ||
> > +                               ((isp_obj.if_status == ISP_CSIA) &&
> > +                               (if_t == ISP_PARLL)) ||
> > +                               ((isp_obj.if_status == ISP_CSIA) &&
> > +                               (if_t == ISP_CSIB)) ||
> > +                               ((isp_obj.if_status == ISP_CSIB) &&
> > +                               (if_t == ISP_CSIA)) ||
> > +                               (isp_obj.if_status == 0)) {
> 
> Hard to understand. Why not:
> 
>        if ((isp_obj.if_status == ISP_PARLL && if_t == ISP_CSIA) ||
>            (isp_obj.if_status == ISP_CSIA && if_t == ISP_PARLL) ||
>            (isp_obj.if_status == ISP_CSIA && if_t == ISP_CSIB) ||
>            (isp_obj.if_status == ISP_CSIB && if_t == ISP_CSIA) ||
>            isp_obj.if_status == 0) {
> 

Done

> > +               isp_obj.if_status |= if_t;
> > +               return 0;
> > +       } else {
> > +               DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination Serial- \
> > +                       Parallel interface\n");
> > +               return -EINVAL;
> > +       }
> > +}
> > +EXPORT_SYMBOL(isp_request_interface);

<snip>

> > +       /* CONTROL_ */
> > +       omap_writel(
> > +               /* CSIb receiver data/clock or data/strobe mode */
> > +               (config->u.csi.signalling << 10)
> > +               | BIT(12)       /* Enable differential transceiver */
> > +               | BIT(13)       /* Disable reset */
> > +#ifdef TERM_RESISTOR
> 
> What is this define? It doesn't seem to be documented.

This define is to enable/disable an OMAP34xx internal resistor for CSIb (CCP2) camera port.

A comment along its declaration should be enough?

Thanks for your time.

Regards,
Sergio

> 
> Regards,
> 
> 	Hans
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
