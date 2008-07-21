Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6L9cXhc027691
	for <video4linux-list@redhat.com>; Mon, 21 Jul 2008 05:38:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6L9cKQW008467
	for <video4linux-list@redhat.com>; Mon, 21 Jul 2008 05:38:20 -0400
Date: Mon, 21 Jul 2008 05:38:18 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
In-Reply-To: <20080720223108.GC31640@orion>
Message-ID: <alpine.LFD.1.10.0807210535170.25866@bombadil.infradead.org>
References: <20080720223108.GC31640@orion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: v4l-dvb-maintainer@linuxtv.org, kernel-janitors@vger.kernel.org,
	video4linux-list@redhat.com
Subject: Re: [PATCH] v4l: replace __FUNCTION__ with __func__
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

Hi Alexander,

It is better to split drx397xD from the others. This driver still needs 
other fixes, and its mainstream submission will be postponed.

So, please, send it again, into two emails, one with drx, and the other 
with the other changes.

thanks,
Mauro.

On Mon, 21 Jul 2008, Alexander Beregalov wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
>
> v4l: replace __FUNCTION__ with __func__
>
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> ---
>
> drivers/media/dvb/frontends/drx397xD.c     |   34 ++++++++++++++--------------
> drivers/media/video/cx23885/cx23885-core.c |    2 +-
> include/media/saa7146.h                    |    2 +-
> include/media/v4l2-dev.h                   |    2 +-
> 4 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
> index 3cbed87..e19147b 100644
> --- a/drivers/media/dvb/frontends/drx397xD.c
> +++ b/drivers/media/dvb/frontends/drx397xD.c
> @@ -96,7 +96,7 @@ static void drx_release_fw(struct drx397xD_state *s)
> {
> 	fw_ix_t ix = s->chip_rev;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	write_lock(&fw[ix].lock);
> 	if (fw[ix].refcnt) {
> @@ -113,7 +113,7 @@ static int drx_load_fw(struct drx397xD_state *s, fw_ix_t ix)
> 	size_t size, len;
> 	int i = 0, j, rc = -EINVAL;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	if (ix < 0 || ix >= ARRAY_SIZE(fw))
> 		return -EINVAL;
> @@ -197,10 +197,10 @@ static int write_fw(struct drx397xD_state *s, blob_ix_t ix)
> 	int len, rc = 0, i = 0;
>
> 	if (ix < 0 || ix >= ARRAY_SIZE(blob_name)) {
> -		pr_debug("%s drx_fw_ix_t out of range\n", __FUNCTION__);
> +		pr_debug("%s drx_fw_ix_t out of range\n", __func__);
> 		return -EINVAL;
> 	}
> -	pr_debug("%s %s\n", __FUNCTION__, blob_name[ix]);
> +	pr_debug("%s %s\n", __func__, blob_name[ix]);
>
> 	read_lock(&fw[s->chip_rev].lock);
> 	data = fw[s->chip_rev].data[ix];
> @@ -305,7 +305,7 @@ static int PLL_Set(struct drx397xD_state *s,
> 	u32 f_tuner, f = fep->frequency;
> 	int rc;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	if ((f > s->frontend.ops.tuner_ops.info.frequency_max) ||
> 	    (f < s->frontend.ops.tuner_ops.info.frequency_min))
> @@ -325,7 +325,7 @@ static int PLL_Set(struct drx397xD_state *s,
> 		return rc;
>
> 	*df_tuner = f_tuner - f;
> -	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __FUNCTION__, f,
> +	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __func__, f,
> 		 f_tuner);
>
> 	return 0;
> @@ -340,7 +340,7 @@ static int SC_WaitForReady(struct drx397xD_state *s)
> 	int cnt = 1000;
> 	int rc;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	while (cnt--) {
> 		rc = RD16(s, 0x820043);
> @@ -354,7 +354,7 @@ static int SC_SendCommand(struct drx397xD_state *s, int cmd)
> {
> 	int rc;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	WR16(s, 0x820043, cmd);
> 	SC_WaitForReady(s);
> @@ -368,7 +368,7 @@ static int HI_Command(struct drx397xD_state *s, u16 cmd)
> {
> 	int rc, cnt = 1000;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	rc = WR16(s, 0x420032, cmd);
> 	if (rc < 0)
> @@ -389,7 +389,7 @@ static int HI_Command(struct drx397xD_state *s, u16 cmd)
> static int HI_CfgCommand(struct drx397xD_state *s)
> {
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	WR16(s, 0x420033, 0x3973);
> 	WR16(s, 0x420034, s->config.w50);	// code 4, log 4
> @@ -419,7 +419,7 @@ static int SetCfgIfAgc(struct drx397xD_state *s, struct drx397xD_CfgIfAgc *agc)
> 	u16 w0C = agc->w0C;
> 	int quot, rem, i, rc = -EINVAL;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	if (agc->w04 > 0x3ff)
> 		goto exit_rc;
> @@ -478,7 +478,7 @@ static int SetCfgRfAgc(struct drx397xD_state *s, struct drx397xD_CfgRfAgc *agc)
> 	u16 w06 = agc->w06;
> 	int rc = -1;
>
> -	pr_debug("%s %d 0x%x 0x%x\n", __FUNCTION__, agc->d00, w04, w06);
> +	pr_debug("%s %d 0x%x 0x%x\n", __func__, agc->d00, w04, w06);
>
> 	if (w04 > 0x3ff)
> 		goto exit_rc;
> @@ -554,7 +554,7 @@ static int CorrectSysClockDeviation(struct drx397xD_state *s)
> 	int lockstat;
> 	u32 clk, clk_limit;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	if (s->config.d5C == 0) {
> 		EXIT_RC(WR16(s, 0x08200e8, 0x010));
> @@ -598,7 +598,7 @@ static int CorrectSysClockDeviation(struct drx397xD_state *s)
>
> 	if (clk - s->config.f_osc * 1000 + clk_limit <= 2 * clk_limit) {
> 		s->f_osc = clk;
> -		pr_debug("%s: osc %d %d [Hz]\n", __FUNCTION__,
> +		pr_debug("%s: osc %d %d [Hz]\n", __func__,
> 			 s->config.f_osc * 1000, clk - s->config.f_osc * 1000);
> 	}
> 	rc = WR16(s, 0x08200e8, 0);
> @@ -610,7 +610,7 @@ static int ConfigureMPEGOutput(struct drx397xD_state *s, int type)
> {
> 	int rc, si, bp;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	si = s->config.wA0;
> 	if (s->config.w98 == 0) {
> @@ -646,7 +646,7 @@ static int drx_tune(struct drx397xD_state *s,
>
> 	int rc, df_tuner;
> 	int a, b, c, d;
> -	pr_debug("%s %d\n", __FUNCTION__, s->config.d60);
> +	pr_debug("%s %d\n", __func__, s->config.d60);
>
> 	if (s->config.d60 != 2)
> 		goto set_tuner;
> @@ -1082,7 +1082,7 @@ static int drx397x_init(struct dvb_frontend *fe)
> 	struct drx397xD_state *s = fe->demodulator_priv;
> 	int rc;
>
> -	pr_debug("%s\n", __FUNCTION__);
> +	pr_debug("%s\n", __func__);
>
> 	s->config.rfagc.d00 = 2;	/* 0x7c */
> 	s->config.rfagc.w04 = 0;
> diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
> index d17343e..5c20378 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -1311,7 +1311,7 @@ void cx23885_cancel_buffers(struct cx23885_tsport *port)
> 	struct cx23885_dev *dev = port->dev;
> 	struct cx23885_dmaqueue *q = &port->mpegq;
>
> -	dprintk(1, "%s()\n", __FUNCTION__);
> +	dprintk(1, "%s()\n", __func__);
> 	del_timer_sync(&q->timeout);
> 	cx23885_stop_dma(port);
> 	do_cancel_buffers(port, "cancel", 0);
> diff --git a/include/media/saa7146.h b/include/media/saa7146.h
> index 2f68f4c..c0802c8 100644
> --- a/include/media/saa7146.h
> +++ b/include/media/saa7146.h
> @@ -30,7 +30,7 @@ extern unsigned int saa7146_debug;
> 	#define DEBUG_VARIABLE saa7146_debug
> #endif
>
> -#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__FUNCTION__)
> +#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__func__)
> #define INFO(x) { printk("%s: ",KBUILD_MODNAME); printk x; }
>
> #define ERR(x) { DEBUG_PROLOG; printk x; }
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 3c93414..33f379b 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -375,7 +375,7 @@ video_device_create_file(struct video_device *vfd,
> {
> 	int ret = device_create_file(&vfd->class_dev, attr);
> 	if (ret < 0)
> -		printk(KERN_WARNING "%s error: %d\n", __FUNCTION__, ret);
> +		printk(KERN_WARNING "%s error: %d\n", __func__, ret);
> 	return ret;
> }
> static inline void
>
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
