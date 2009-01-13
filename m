Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0D7ZJFB021072
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 02:35:19 -0500
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0D7YNvs000382
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 02:34:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Date: Tue, 13 Jan 2009 08:34:16 +0100
References: <A24693684029E5489D1D202277BE894416429BCC@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894416429BCC@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901130834.16645.hverkuil@xs4all.nl>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 08/14] OMAP: CAM: Add ISP Core
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

On Monday 12 January 2009 21:16:28 Aguirre Rodriguez, Sergio Alberto 
wrote:
> Hi,
>
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>
> <snip>
>
> > > +               {
> > > +                       .id = V4L2_CID_PRIVATE_ISP_COLOR_FX,
> > > +                       .type = V4L2_CTRL_TYPE_INTEGER,
> > > +                       .name = "Color Effects",
> >
> > What does this do? It definitely looks like this should be a menu,
> > not an integer control. Forcing color to B&W is something that
> > other hardware can do as well, so I think this is a very good
> > candidate for a generic user control, rather than driver specific.
>
> This basically enables some common color effects on image processing:
> - Default colors (i.e. original captured colors)
> - Sepia colored images
> - B&W colored images.
>
> I think its generic enough to propose for a new generic user CID.

Yes.

> Ok, so, should I keep the Private CID as a menu type ctrl by now?

No, just propose a new control for this. Shouldn't be a problem. The 
only suggestion that I have is that the user control has B&W as the 
second entry rather than the third. There are more devices that can 
choose between color and B&W, but this is the first device I know of 
that can do sepia. Having B&W as the second entry makes it easier for 
drivers to omit the sepia entry by just setting the max control value 
(= menu index) to B&W.

Note that in two weeks time I'm going to merge the V4L2 specification 
into our v4l-dvb repository. That should make it easy to add 
documentation for this new control as well.

>
> > > +                       .minimum = PREV_DEFAULT_COLOR,
> > > +                       .maximum = PREV_BW_COLOR,
> > > +                       .step = 1,
> > > +                       .default_value = PREV_DEFAULT_COLOR,
> > > +               },
> > > +               .current_value = PREV_DEFAULT_COLOR,
> > > +       }
> > > +};
> > > +
>
> <snip>
>
> > > +
> > > +       if (((isp_obj.if_status == ISP_PARLL) && (if_t ==
> > > ISP_CSIA)) || +                               ((isp_obj.if_status
> > > == ISP_CSIA) && +                               (if_t ==
> > > ISP_PARLL)) ||
> > > +                               ((isp_obj.if_status == ISP_CSIA)
> > > && +                               (if_t == ISP_CSIB)) ||
> > > +                               ((isp_obj.if_status == ISP_CSIB)
> > > && +                               (if_t == ISP_CSIA)) ||
> > > +                               (isp_obj.if_status == 0)) {
> >
> > Hard to understand. Why not:
> >
> >        if ((isp_obj.if_status == ISP_PARLL && if_t == ISP_CSIA) ||
> >            (isp_obj.if_status == ISP_CSIA && if_t == ISP_PARLL) ||
> >            (isp_obj.if_status == ISP_CSIA && if_t == ISP_CSIB) ||
> >            (isp_obj.if_status == ISP_CSIB && if_t == ISP_CSIA) ||
> >            isp_obj.if_status == 0) {
>
> Done
>
> > > +               isp_obj.if_status |= if_t;
> > > +               return 0;
> > > +       } else {
> > > +               DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination
> > > Serial- \ +                       Parallel interface\n");
> > > +               return -EINVAL;
> > > +       }
> > > +}
> > > +EXPORT_SYMBOL(isp_request_interface);
>
> <snip>
>
> > > +       /* CONTROL_ */
> > > +       omap_writel(
> > > +               /* CSIb receiver data/clock or data/strobe mode
> > > */ +               (config->u.csi.signalling << 10)
> > > +               | BIT(12)       /* Enable differential
> > > transceiver */ +               | BIT(13)       /* Disable reset
> > > */
> > > +#ifdef TERM_RESISTOR
> >
> > What is this define? It doesn't seem to be documented.
>
> This define is to enable/disable an OMAP34xx internal resistor for
> CSIb (CCP2) camera port.
>
> A comment along its declaration should be enough?

Yes. But shouldn't this be a module option, perhaps? Up to you, I'm just 
wondering.

> Thanks for your time.

No problem,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
