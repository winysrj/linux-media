Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59724 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751326AbdLMTNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 14:13:32 -0500
Date: Wed, 13 Dec 2017 17:13:19 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: <Yasunari.Takiguchi@sony.com>
Cc: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <tbird20d@gmail.com>,
        <frowand.list@gmail.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH v4 06/12] [media] cxd2880: Add integration layer for the
 driver
Message-ID: <20171213171319.675b39a6@vento.lan>
In-Reply-To: <20171013060834.21526-1-Yasunari.Takiguchi@sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171013060834.21526-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 15:08:34 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> These functions monitor the driver and watch for task completion.
> This is part of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

If I understand well, the goal here is to have thread that would
be waking up from time to time, right? Just use the infrastructure
that the Kernel has for it, like a kthread, or timer_setup() & friends.

Take a look at include/linux/timer.h, and just use what's already
defined.


> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
> 
> [Change list]
> Changes in V4   
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
>       -removed unnecessary initialization at variable declaration
> 
> Changes in V3
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
>       -changed cxd2880_atomic_read to atomic_read
>       -changed cxd2880_atomic_set to atomic_set
>       -modified return code
>       -modified coding style of if() 
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
>       -modified return code
> 
>  .../media/dvb-frontends/cxd2880/cxd2880_integ.c    | 98 ++++++++++++++++++++++
>  .../media/dvb-frontends/cxd2880/cxd2880_integ.h    | 44 ++++++++++
>  2 files changed, 142 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
> 
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
> new file mode 100644
> index 000000000000..7264fc355d6b
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
> @@ -0,0 +1,98 @@
> +/*
> + * cxd2880_integ.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer common functions
> + *
> + * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; version 2 of the License.
> + *
> + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
> + * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
> + * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
> + * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
> + * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
> + * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
> + * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "cxd2880_tnrdmd.h"
> +#include "cxd2880_tnrdmd_mon.h"
> +#include "cxd2880_integ.h"
> +
> +int cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	int ret;
> +	struct cxd2880_stopwatch timer;
> +	unsigned int elapsed_time = 0;
> +	u8 cpu_task_completed = 0;
> +
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	ret = cxd2880_tnrdmd_init1(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = cxd2880_stopwatch_start(&timer);
> +	if (ret)
> +		return ret;
> +
> +	while (1) {
> +		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed_time);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
> +						     &cpu_task_completed);
> +		if (ret)
> +			return ret;
> +
> +		if (cpu_task_completed)
> +			break;
> +
> +		if (elapsed_time > CXD2880_TNRDMD_WAIT_INIT_TIMEOUT)
> +			return -ETIME;
> +		ret =
> +		    cxd2880_stopwatch_sleep(&timer,
> +					    CXD2880_TNRDMD_WAIT_INIT_INTVL);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = cxd2880_tnrdmd_init2(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +int cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	atomic_set(&tnr_dmd->cancel, 1);
> +
> +	return 0;
> +}
> +
> +int cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	if (atomic_read(&tnr_dmd->cancel) != 0)
> +		return -ECANCELED;
> +
> +	return 0;
> +}
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
> new file mode 100644
> index 000000000000..2b4fe5c3743b
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
> @@ -0,0 +1,44 @@
> +/*
> + * cxd2880_integ.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer common interface
> + *
> + * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; version 2 of the License.
> + *
> + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
> + * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
> + * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
> + * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
> + * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
> + * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
> + * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef CXD2880_INTEG_H
> +#define CXD2880_INTEG_H
> +
> +#include "cxd2880_tnrdmd.h"
> +
> +#define CXD2880_TNRDMD_WAIT_INIT_TIMEOUT	500
> +#define CXD2880_TNRDMD_WAIT_INIT_INTVL	10
> +
> +#define CXD2880_TNRDMD_WAIT_AGC_STABLE		100
> +
> +int cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd);
> +
> +int cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd);
> +
> +int cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
> +				     *tnr_dmd);
> +
> +#endif



Thanks,
Mauro
