Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35299 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750941AbdCBKoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 05:44:13 -0500
Message-ID: <1488449782.2301.6.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: implement encoder stop command
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Date: Thu, 02 Mar 2017 11:16:22 +0100
In-Reply-To: <CAH-u=833MgX4ZD07db4Reg+N6ch7Q35_7qt0Prn-6THYO0wFTQ@mail.gmail.com>
References: <20170302095144.32090-1-p.zabel@pengutronix.de>
         <CAH-u=833MgX4ZD07db4Reg+N6ch7Q35_7qt0Prn-6THYO0wFTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

On Thu, 2017-03-02 at 11:02 +0100, Jean-Michel Hautbois wrote:
> Hi Philipp,
> 
> 2017-03-02 10:51 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> > There is no need to call v4l2_m2m_try_schedule to kick off draining the
> > bitstream buffer for the encoder, but we have to wake up the destination
> > queue in case there are no new OUTPUT buffers to be encoded and userspace
> > is already polling for new CAPTURE buffers.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 47 +++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index e1a2e8c70db01..085bbdb0d361b 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -881,6 +881,47 @@ static int coda_g_selection(struct file *file, void *fh,
> >         return 0;
> >  }
> >
> > +static int coda_try_encoder_cmd(struct file *file, void *fh,
> > +                               struct v4l2_encoder_cmd *ec)
> > +{
> > +       if (ec->cmd != V4L2_ENC_CMD_STOP)
> > +               return -EINVAL;
> > +
> > +       if (ec->flags & V4L2_ENC_CMD_STOP_AT_GOP_END)
> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}
> > +
> > +static int coda_encoder_cmd(struct file *file, void *fh,
> > +                           struct v4l2_encoder_cmd *ec)
> > +{
> > +       struct coda_ctx *ctx = fh_to_ctx(fh);
> > +       struct vb2_queue *dst_vq;
> > +       int ret;
> > +
> > +       ret = coda_try_encoder_cmd(file, fh, ec);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* Ignore encoder stop command silently in decoder context */
> > +       if (ctx->inst_type != CODA_INST_ENCODER)
> > +               return 0;
> > +
> > +       /* Set the stream-end flag on this context */
> > +       ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
> 
> Why aren't you calling coda_bit_stream_end_flag() ?

Because that additionally does:

        /* If this context is currently running, update the hardware flag */
        if ((dev->devtype->product == CODA_960) &&
            coda_isbusy(dev) &&
            (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
                coda_write(dev, ctx->bit_stream_param,
                           CODA_REG_BIT_BIT_STREAM_PARAM);
        }

to kick a potentially hanging decode picture run. This is unnecessary in the
encoder case.
We only need the flag set to make coda_buf_is_end_of_stream return true
and thereby make coda_m2m_buf_done set the V4L2_BUF_FLAG_LAST on the
buffer and emit the EOS event.

regards
Philipp
