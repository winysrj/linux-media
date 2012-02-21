Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2BUIja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 03:39:30 -0500
Date: Tue, 21 Feb 2012 09:39:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Subject: Re: [PATCH] media: i.MX27 camera: Add resizing support.
In-Reply-To: <CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1202210936420.18412@axis700.grange>
References: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1202201413300.2836@axis700.grange>
 <CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

One more thing occurred to me: I don't see anywhere in your patch checking 
for supported pixel (fourcc) formats. I don't think the PRP can resize 
arbitrary formats? Most likely these would be limited to some YUV, and, 
possibly, some RGB formats?

Thanks
Guennadi

On Tue, 21 Feb 2012, javier Martin wrote:

> Hi Guennadi,
> thank you for your review.
> 
> On 20 February 2012 15:13, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >> @@ -707,6 +732,74 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
> >>       writel(prp->cfg.irq_flags, pcdev->base_emma + PRP_INTR_CNTL);
> >>  }
> >>
> >> +static void mx2_prp_resize_commit(struct mx2_camera_dev *pcdev)
> >> +{
> >> +     int dir;
> >> +
> >> +     for (dir = RESIZE_DIR_H; dir <= RESIZE_DIR_V; dir++) {
> >> +             unsigned char *s = pcdev->resizing[dir].s;
> >> +             int len = pcdev->resizing[dir].len;
> >> +             unsigned int coeff[2] = {0, 0};
> >> +             unsigned int valid  = 0;
> >> +             int i;
> >> +
> >> +             if (len == 0)
> >> +                     continue;
> >> +
> >> +             for (i = RESIZE_NUM_MAX - 1; i >= 0; i--) {
> >> +                     int j;
> >> +
> >> +                     j = i > 9 ? 1 : 0;
> >> +                     coeff[j] = (coeff[j] << BC_COEF) |
> >> +                     (s[i] & (SZ_COEF - 1));
> >
> > Please, remember to indent line continuations.
> 
> Yes, sorry.
> 
> >
> >> +
> >> +                     if (i == 5 || i == 15)
> >> +                             coeff[j] <<= 1;
> >> +
> >> +                     valid = (valid << 1) | (s[i] >> BC_COEF);
> >> +             }
> >> +
> >> +             valid |= PRP_RZ_VALID_TBL_LEN(len);
> >> +
> >> +             if (pcdev->resizing[dir].algo == RESIZE_ALGO_BILINEAR)
> >> +                     valid |= PRP_RZ_VALID_BILINEAR;
> >> +
> >> +             if (pcdev->emma_prp->cfg.channel == 1) {
> >
> > Maybe put horizontal and vertical register addresses in an array too to
> > avoid this "if?" Just an idea - if you don't think, the code would look
> > nicer, just leave as is.
> 
> I don't know about that, we can't avoid the fact that the code would
> look more compact but I think it would be less clear.
> 
> >> +                     if (dir == RESIZE_DIR_H) {
> >> +                             writel(coeff[0], pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_HORI_COEF1);
> >> +                             writel(coeff[1], pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_HORI_COEF2);
> >> +                             writel(valid, pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_HORI_VALID);
> >> +                     } else {
> >> +                             writel(coeff[0], pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_VERT_COEF1);
> >> +                             writel(coeff[1], pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_VERT_COEF2);
> >> +                             writel(valid, pcdev->base_emma +
> >> +                                                     PRP_CH1_RZ_VERT_VALID);
> >> +                     }
> >> +             } else {
> >> +                     if (dir == RESIZE_DIR_H) {
> >> +                             writel(coeff[0], pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_HORI_COEF1);
> >> +                             writel(coeff[1], pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_HORI_COEF2);
> >> +                             writel(valid, pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_HORI_VALID);
> >> +                     } else {
> >> +                             writel(coeff[0], pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_VERT_COEF1);
> >> +                             writel(coeff[1], pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_VERT_COEF2);
> >> +                             writel(valid, pcdev->base_emma +
> >> +                                                     PRP_CH2_RZ_VERT_VALID);
> >> +                     }
> >> +             }
> >> +     }
> >> +}
> >> +
> >>  static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
> >>  {
> >>       struct soc_camera_device *icd = soc_camera_from_vb2q(q);
> >> @@ -773,6 +866,8 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
> >>               list_add_tail(&pcdev->buf_discard[1].queue,
> >>                                     &pcdev->discard);
> >>
> >> +             mx2_prp_resize_commit(pcdev);
> >> +
> >>               mx27_camera_emma_buf_init(icd, bytesperline);
> >>
> >>               if (prp->cfg.channel == 1) {
> >> @@ -1059,6 +1154,119 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
> >>       return formats;
> >>  }
> >>
> >> +static int mx2_emmaprp_resize(struct mx2_camera_dev *pcdev,
> >> +                           struct v4l2_mbus_framefmt *mf_in,
> >> +                           struct v4l2_pix_format *pix_out)
> >> +{
> >> +     int num, den;
> >> +     unsigned long m;
> >> +     int i, dir;
> >> +
> >> +     for (dir = RESIZE_DIR_H; dir <= RESIZE_DIR_V; dir++) {
> >> +             unsigned char *s = pcdev->resizing[dir].s;
> >> +             int len = 0;
> >> +             int in, out;
> >> +
> >> +             if (dir == RESIZE_DIR_H) {
> >> +                     in = mf_in->width;
> >> +                     out = pix_out->width;
> >> +             } else {
> >> +                     in = mf_in->height;
> >> +                     out = pix_out->height;
> >> +             }
> >> +
> >> +             if (in < out)
> >> +                     return -EINVAL;
> >> +             else if (in == out)
> >> +                     continue;
> >> +
> >> +             /* Calculate ratio */
> >> +             m = gcd(in, out);
> >> +             num = in / m;
> >> +             den = out / m;
> >> +             if (num > RESIZE_NUM_MAX)
> >> +                     return -EINVAL;
> >> +
> >> +             if ((num >= 2 * den) && (den == 1) &&
> >> +                 (num < 9) && (!(num & 0x01))) {
> >> +                     int sum = 0;
> >> +                     int j;
> >> +
> >> +                     /* Average scaling for > 2:1 ratios */
> >
> > ">=" rather than ">"
> 
> You are right.
> 
> >> +                     /* Support can be added for num >=9 and odd values */
> >
> > So, this is only used for downscaling by 1/2, 1/4, 1/6, and 1/8?
> 
> Yes.
> 
> >> +
> >> +                     pcdev->resizing[dir].algo = RESIZE_ALGO_AVERAGING;
> >> +                     len = num;
> >> +
> >> +                     for (i = 0; i < (len / 2); i++)
> >> +                             s[i] = 8;
> >> +
> >> +                     do {
> >> +                             for (i = 0; i < (len / 2); i++) {
> >> +                                     s[i] = s[i] >> 1;
> >> +                                     sum = 0;
> >> +                                     for (j = 0; j < (len / 2); j++)
> >> +                                             sum += s[j];
> >> +                                     if (sum == 4)
> >> +                                             break;
> >> +                             }
> >> +                     } while (sum != 4);
> >> +
> >> +                     for (i = (len / 2); i < len; i++)
> >> +                             s[i] = s[len - i - 1];
> >> +
> >> +                     s[len - 1] |= SZ_COEF;
> >> +             } else {
> >> +                     /* bilinear scaling for < 2:1 ratios */
> >> +                     int v; /* overflow counter */
> >> +                     int coeff, nxt; /* table output */
> >> +                     int in_pos_inc = 2 * den;
> >> +                     int out_pos = num;
> >> +                     int out_pos_inc = 2 * num;
> >> +                     int init_carry = num - den;
> >> +                     int carry = init_carry;
> >> +
> >> +                     pcdev->resizing[dir].algo = RESIZE_ALGO_BILINEAR;
> >> +                     v = den + in_pos_inc;
> >> +                     do {
> >> +                             coeff = v - out_pos;
> >> +                             out_pos += out_pos_inc;
> >> +                             carry += out_pos_inc;
> >> +                             for (nxt = 0; v < out_pos; nxt++) {
> >> +                                     v += in_pos_inc;
> >> +                                     carry -= in_pos_inc;
> >> +                             }
> >> +
> >> +                             if (len > RESIZE_NUM_MAX)
> >> +                                     return -EINVAL;
> >> +
> >> +                             coeff = ((coeff << BC_COEF) +
> >> +                                     (in_pos_inc >> 1)) / in_pos_inc;
> >> +
> >> +                             if (coeff >= (SZ_COEF - 1))
> >> +                                     coeff--;
> >> +
> >> +                             coeff |= SZ_COEF;
> >> +                             s[len] = (unsigned char)coeff;
> >> +                             len++;
> >> +
> >> +                             for (i = 1; i < nxt; i++) {
> >> +                                     if (len >= RESIZE_NUM_MAX)
> >> +                                             return -EINVAL;
> >> +                                     s[len] = 0;
> >> +                                     len++;
> >> +                             }
> >> +                     } while (carry != init_carry);
> >> +             }
> >> +             pcdev->resizing[dir].len = len;
> >> +             if (dir == RESIZE_DIR_H)
> >> +                     mf_in->width = mf_in->width * den / num;
> >> +             else
> >> +                     mf_in->height = mf_in->height * den / num;
> >
> > Aren't your calculations exact, so that here you can just use
> > pix_out->width and pix_out->height?
> 
> Yes, they are. I can save these operations. Thank you.
> 
> >> +     }
> >> +     return 0;
> >> +}
> >> +
> >>  static int mx2_camera_set_fmt(struct soc_camera_device *icd,
> >>                              struct v4l2_format *f)
> >>  {
> >> @@ -1070,6 +1278,9 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
> >>       struct v4l2_mbus_framefmt mf;
> >>       int ret;
> >>
> >> +     dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
> >> +             __func__, pix->width, pix->height);
> >> +
> >>       xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> >>       if (!xlate) {
> >>               dev_warn(icd->parent, "Format %x not found\n",
> >> @@ -1087,6 +1298,18 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
> >>       if (ret < 0 && ret != -ENOIOCTLCMD)
> >>               return ret;
> >>
> >> +     /* Store width and height returned by the sensor for resizing */
> >> +     pcdev->s_width = mf.width;
> >> +     pcdev->s_height = mf.height;
> >> +     dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
> >> +             __func__, pcdev->s_width, pcdev->s_height);
> >> +
> >> +     memset(pcdev->resizing, 0, sizeof(struct emma_prp_resize) << 1);
> >
> > I think, just sizeof(pcdev->resizing) will do the trick.
> 
> No problem.
> 
> >> +     if (mf.width != pix->width || mf.height != pix->height) {
> >> +             if (mx2_emmaprp_resize(pcdev, &mf, pix) < 0)
> >> +                     return -EINVAL;
> >
> > Hmmm... This looks like a regression, not an improvement - you return more
> > errors now, than without this resizing support. Wouldn't it be possible to
> > fall back to the current behaviour if prp resizing is impossible?
> 
> You are right. I did this for testing purposes and forgot to update it.
> 
> >> +     }
> >> +
> >>       if (mf.code != xlate->code)
> >>               return -EINVAL;
> >>
> >> @@ -1100,6 +1323,9 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
> >>               pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
> >>                                               xlate->host_fmt->fourcc);
> >>
> >> +     dev_dbg(icd->parent, "%s: returned params: width = %d, height = %d\n",
> >> +             __func__, pix->width, pix->height);
> >> +
> >>       return 0;
> >>  }
> >>
> >> @@ -1109,11 +1335,16 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
> >>       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> >>       const struct soc_camera_format_xlate *xlate;
> >>       struct v4l2_pix_format *pix = &f->fmt.pix;
> >> -     struct v4l2_mbus_framefmt mf;
> >>       __u32 pixfmt = pix->pixelformat;
> >> +     struct v4l2_mbus_framefmt mf;
> >
> > This swap doesn't seem to be needed.
> 
> Fine, I'll fix it.
> 
> >> +     struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >> +     struct mx2_camera_dev *pcdev = ici->priv;
> >>       unsigned int width_limit;
> >>       int ret;
> >>
> >> +     dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
> >> +             __func__, pix->width, pix->height);
> >> +
> >>       xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> >>       if (pixfmt && !xlate) {
> >>               dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> >> @@ -1163,6 +1394,19 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
> >>       if (ret < 0)
> >>               return ret;
> >>
> >> +     /* Store width and height returned by the sensor for resizing */
> >> +     pcdev->s_width = mf.width;
> >> +     pcdev->s_height = mf.height;
> >
> > You don't need these in .try_fmt().
> 
> Right.
> 
> >> +     dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
> >> +             __func__, pcdev->s_width, pcdev->s_height);
> >> +
> >> +     /* If the sensor does not support image size try PrP resizing */
> >> +     memset(pcdev->resizing, 0, sizeof(struct emma_prp_resize) << 1);
> >
> > Same for sizeof()
> >
> >> +     if (mf.width != pix->width || mf.height != pix->height) {
> >> +             if (mx2_emmaprp_resize(pcdev, &mf, pix) < 0)
> >> +                     return -EINVAL;
> >
> > .try_fmt() really shouldn't fail.
> 
> It's the same issue as with s_fmt, I will fix it.
> 
> I'll try to send a v2 tomorrow.
> 
> Regards.
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
