Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55761
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751174AbdH0Per (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 11:34:47 -0400
Date: Sun, 27 Aug 2017 12:34:30 -0300
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
Subject: Re: [PATCH v3 09/14] [media] cxd2880: Add DVB-T monitor and
 integration layer functions
Message-ID: <20170827123425.4be7c458@vento.lan>
In-Reply-To: <20170816044142.21587-1-Yasunari.Takiguchi@sony.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
        <20170816044142.21587-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Aug 2017 13:41:42 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> Provide monitor and integration layer functions (DVB-T)
> for the Sony CXD2880 DVB-T2/T tuner + demodulator driver.
> 
> [Change list]
> Changes in V3
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
>       -changed CXD2880_SLEEP to usleep_range
>       -chnaged cxd2880_atomic_set to atomic_set
>       -modified return code
>       -modified coding style of if() 
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
>       -modified return code
>    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
>       -removed unnecessary cast
>       -changed cxd2880_math_log to intlog10
>       -changed hexadecimal code to lower case. 
>    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
>       -modified return code
> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
>  .../dvb-frontends/cxd2880/cxd2880_integ_dvbt.c     |  198 ++++
>  .../dvb-frontends/cxd2880/cxd2880_integ_dvbt.h     |   58 +
>  .../cxd2880/cxd2880_tnrdmd_dvbt_mon.c              | 1227 ++++++++++++++++++++
>  .../cxd2880/cxd2880_tnrdmd_dvbt_mon.h              |  106 ++
>  4 files changed, 1589 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
> 
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
> new file mode 100644
> index 000000000000..729cb0939203
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.c
> @@ -0,0 +1,198 @@
> +/*
> + * cxd2880_integ_dvbt.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer functions for DVB-T
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
> +#include "cxd2880_tnrdmd_dvbt.h"
> +#include "cxd2880_integ_dvbt.h"
> +
> +static int dvbt_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd);
> +
> +int cxd2880_integ_dvbt_tune(struct cxd2880_tnrdmd *tnr_dmd,
> +			    struct cxd2880_dvbt_tune_param
> +			    *tune_param)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!tune_param))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if ((tnr_dmd->state != CXD2880_TNRDMD_STATE_SLEEP) &&
> +	    (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE))
> +		return -EPERM;
> +
> +	atomic_set(&tnr_dmd->cancel, 0);
> +
> +	if ((tune_param->bandwidth != CXD2880_DTV_BW_5_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_6_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_7_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_8_MHZ)) {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ret = cxd2880_tnrdmd_dvbt_tune1(tnr_dmd, tune_param);
> +	if (ret)
> +		return ret;
> +
> +	usleep_range(CXD2880_TNRDMD_WAIT_AGC_STABLE * 10000,
> +		     CXD2880_TNRDMD_WAIT_AGC_STABLE * 10000 + 1000);
> +
> +	ret = cxd2880_tnrdmd_dvbt_tune2(tnr_dmd, tune_param);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt_wait_demod_lock(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +int cxd2880_integ_dvbt_wait_ts_lock(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	int ret = 0;
> +	enum cxd2880_tnrdmd_lock_result lock =
> +	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
> +	struct cxd2880_stopwatch timer;
> +	u8 continue_wait = 1;
> +	unsigned int elapsed = 0;
> +
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	ret = cxd2880_stopwatch_start(&timer);
> +	if (ret)
> +		return ret;
> +
> +	for (;;) {
> +		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
> +		if (ret)
> +			return ret;
> +
> +		if (elapsed >= CXD2880_DVBT_WAIT_TS_LOCK)
> +			continue_wait = 0;
> +
> +		ret = cxd2880_tnrdmd_dvbt_check_ts_lock(tnr_dmd, &lock);
> +		if (ret)
> +			return ret;
> +
> +		switch (lock) {
> +		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
> +			return 0;
> +
> +		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
> +			return -EAGAIN;
> +
> +		default:
> +			break;
> +		}
> +
> +		ret = cxd2880_integ_check_cancellation(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		if (continue_wait) {
> +			ret =
> +			    cxd2880_stopwatch_sleep(&timer,
> +					    CXD2880_DVBT_WAIT_LOCK_INTVL);
> +			if (ret)
> +				return ret;
> +		} else {
> +			ret = -ETIME;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int dvbt_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd)

I can't actually see why you want a function to wait for demod to lock,
as this is usually done in userspace.

Are there any reason why such wait can't be performed on userspace?

> +{
> +	int ret = 0;
> +	enum cxd2880_tnrdmd_lock_result lock =
> +	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
> +	struct cxd2880_stopwatch timer;
> +	u8 continue_wait = 1;
> +	unsigned int elapsed = 0;
> +
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	ret = cxd2880_stopwatch_start(&timer);
> +	if (ret)
> +		return ret;
> +
> +	for (;;) {

No. Please use, instead:

	while (1) {
	}

as it is clearer that this is an infinite loop. Btw, extra care should
be taken with that, in order to not hang out the Kernel, specially
if the code in question is not inside a kthread.


> +		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
> +		if (ret)
> +			return ret;
> +
> +		if (elapsed >= CXD2880_DVBT_WAIT_DMD_LOCK)
> +			continue_wait = 0;
> +
> +		ret = cxd2880_tnrdmd_dvbt_check_demod_lock(tnr_dmd, &lock);
> +		if (ret)
> +			return ret;
> +
> +		switch (lock) {
> +		case CXD2880_TNRDMD_LOCK_RESULT_LOCKED:
> +			return 0;
> +
> +		case CXD2880_TNRDMD_LOCK_RESULT_UNLOCKED:
> +			return -EAGAIN;
> +
> +		default:
> +			break;
> +		}
> +
> +		ret = cxd2880_integ_check_cancellation(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		if (continue_wait) {
> +			ret =
> +			    cxd2880_stopwatch_sleep(&timer,
> +					    CXD2880_DVBT_WAIT_LOCK_INTVL);
> +			if (ret)
> +				return ret;
> +		} else {
> +			ret = -ETIME;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
> new file mode 100644
> index 000000000000..07f9b71a3006
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt.h
> @@ -0,0 +1,58 @@
> +/*
> + * cxd2880_integ_dvbt.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer interface for DVB-T
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
> +#ifndef CXD2880_INTEG_DVBT_H
> +#define CXD2880_INTEG_DVBT_H
> +
> +#include "cxd2880_tnrdmd.h"
> +#include "cxd2880_tnrdmd_dvbt.h"
> +#include "cxd2880_integ.h"
> +
> +#define CXD2880_DVBT_WAIT_DMD_LOCK	1000
> +#define CXD2880_DVBT_WAIT_TS_LOCK	1000
> +#define CXD2880_DVBT_WAIT_LOCK_INTVL	10
> +
> +struct cxd2880_integ_dvbt_scan_param {
> +	u32 start_frequency_khz;
> +	u32 end_frequency_khz;
> +	u32 step_frequency_khz;
> +	enum cxd2880_dtv_bandwidth bandwidth;
> +};
> +
> +struct cxd2880_integ_dvbt_scan_result {
> +	u32 center_freq_khz;
> +	int tune_result;
> +	struct cxd2880_dvbt_tune_param dvbt_tune_param;
> +};
> +
> +int cxd2880_integ_dvbt_tune(struct cxd2880_tnrdmd *tnr_dmd,
> +			    struct cxd2880_dvbt_tune_param
> +			    *tune_param);
> +
> +int cxd2880_integ_dvbt_wait_ts_lock(struct cxd2880_tnrdmd
> +				    *tnr_dmd);
> +
> +#endif
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
> new file mode 100644
> index 000000000000..37396a071727
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
> @@ -0,0 +1,1227 @@
> +/*
> + * cxd2880_tnrdmd_dvbt_mon.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * DVB-T monitor functions
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
> +#include "cxd2880_tnrdmd_mon.h"
> +#include "cxd2880_tnrdmd_dvbt.h"
> +#include "cxd2880_tnrdmd_dvbt_mon.h"
> +
> +#include "dvb_math.h"
> +
> +static int is_tps_locked(struct cxd2880_tnrdmd *tnr_dmd);
> +
> +int cxd2880_tnrdmd_dvbt_mon_sync_stat(struct cxd2880_tnrdmd
> +				      *tnr_dmd, u8 *sync_stat,
> +				      u8 *ts_lock_stat,
> +				      u8 *unlock_detected)
> +{
> +	u8 rdata = 0x00;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!sync_stat) || (!ts_lock_stat) || (!unlock_detected))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x10, &rdata, 1);
> +	if (ret)
> +		return ret;
> +
> +	*unlock_detected = (rdata & 0x10) ? 1 : 0;
> +	*sync_stat = rdata & 0x07;
> +	*ts_lock_stat = (rdata & 0x20) ? 1 : 0;
> +
> +	if (*sync_stat == 0x07)
> +		return -EBUSY;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(struct cxd2880_tnrdmd
> +					  *tnr_dmd, u8 *sync_stat,
> +					  u8 *unlock_detected)
> +{
> +	u8 ts_lock_stat = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!sync_stat) || (!unlock_detected))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd->diver_sub, sync_stat,
> +					      &ts_lock_stat, unlock_detected);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_mode_guard(struct cxd2880_tnrdmd
> +				       *tnr_dmd,
> +				       enum cxd2880_dvbt_mode
> +				       *mode,
> +				       enum cxd2880_dvbt_guard
> +				       *guard)
> +{
> +	u8 rdata = 0x00;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!mode) || (!guard))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = is_tps_locked(tnr_dmd);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
> +			ret =
> +			    cxd2880_tnrdmd_dvbt_mon_mode_guard(
> +					tnr_dmd->diver_sub, mode, guard);
> +
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x1b, &rdata, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	*mode = (enum cxd2880_dvbt_mode)((rdata >> 2) & 0x03);
> +	*guard = (enum cxd2880_dvbt_guard)(rdata & 0x03);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_carrier_offset(struct cxd2880_tnrdmd
> +					   *tnr_dmd, int *offset)
> +{
> +	u8 rdata[4];
> +	u32 ctl_val = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!offset))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = is_tps_locked(tnr_dmd);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x1d, rdata, 4);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	ctl_val =
> +	    ((rdata[0] & 0x1f) << 24) | (rdata[1] << 16) | (rdata[2] << 8) |
> +	    (rdata[3]);
> +	*offset = cxd2880_convert2s_complement(ctl_val, 29);
> +	*offset = -1 * ((*offset) * tnr_dmd->bandwidth / 235);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_carrier_offset_sub(struct
> +					       cxd2880_tnrdmd
> +					       *tnr_dmd,
> +					       int *offset)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!offset))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt_mon_carrier_offset(tnr_dmd->diver_sub, offset);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_pre_viterbiber(struct cxd2880_tnrdmd
> +					   *tnr_dmd, u32 *ber)
> +{
> +	u8 rdata[2];
> +	u32 bit_error = 0;
> +	u32 period = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ber))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x10);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x39, rdata, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	if ((rdata[0] & 0x01) == 0) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return -EBUSY;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x22, rdata, 2);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	bit_error = (rdata[0] << 8) | rdata[1];
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x6f, rdata, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	period = ((rdata[0] & 0x07) == 0) ? 256 : (0x1000 << (rdata[0] & 0x07));
> +
> +	if ((period == 0) || (bit_error > period))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		div = period / 128;
> +
> +		Q = (bit_error * 3125) / div;
> +		R = (bit_error * 3125) % div;
> +
> +		R *= 25;
> +		Q = Q * 25 + R / div;
> +		R = R % div;
> +
> +		if (div / 2 <= R)
> +			*ber = Q + 1;
> +		else
> +			*ber = Q;
> +	}
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_pre_rsber(struct cxd2880_tnrdmd
> +				      *tnr_dmd, u32 *ber)
> +{
> +	u8 rdata[3];
> +	u32 bit_error = 0;
> +	u32 period_exp = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ber))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x15, rdata, 3);
> +	if (ret)
> +		return ret;
> +
> +	if ((rdata[0] & 0x40) == 0)
> +		return -EBUSY;
> +
> +	bit_error = ((rdata[0] & 0x3f) << 16) | (rdata[1] << 8) | rdata[2];
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x10);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x60, rdata, 1);
> +	if (ret)
> +		return ret;
> +
> +	period_exp = (rdata[0] & 0x1f);
> +
> +	if ((period_exp <= 11) && (bit_error > (1U << period_exp) * 204 * 8))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		if (period_exp <= 8)
> +			div = (1U << period_exp) * 51;
> +		else
> +			div = (1U << 8) * 51;
> +
> +		Q = (bit_error * 250) / div;
> +		R = (bit_error * 250) % div;
> +
> +		R *= 1250;
> +		Q = Q * 1250 + R / div;
> +		R = R % div;
> +
> +		if (period_exp > 8) {
> +			*ber =
> +			    (Q + (1 << (period_exp - 9))) >> (period_exp - 8);
> +		} else {
> +			if (div / 2 <= R)
> +				*ber = Q + 1;
> +			else
> +				*ber = Q;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_tps_info(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     struct cxd2880_dvbt_tpsinfo
> +				     *info)
> +{
> +	u8 rdata[7];
> +	u8 cell_id_ok = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!info))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = is_tps_locked(tnr_dmd);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
> +			ret =
> +			    cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd->diver_sub,
> +							     info);
> +
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x29, rdata, 7);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x11);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0xd5, &cell_id_ok, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	info->constellation =
> +	    (enum cxd2880_dvbt_constellation)((rdata[0] >> 6) & 0x03);
> +	info->hierarchy = (enum cxd2880_dvbt_hierarchy)((rdata[0] >> 3) & 0x07);
> +	info->rate_hp = (enum cxd2880_dvbt_coderate)(rdata[0] & 0x07);
> +	info->rate_lp = (enum cxd2880_dvbt_coderate)((rdata[1] >> 5) & 0x07);
> +	info->guard = (enum cxd2880_dvbt_guard)((rdata[1] >> 3) & 0x03);
> +	info->mode = (enum cxd2880_dvbt_mode)((rdata[1] >> 1) & 0x03);
> +	info->fnum = (rdata[2] >> 6) & 0x03;
> +	info->length_indicator = rdata[2] & 0x3f;
> +	info->cell_id = (rdata[3] << 8) | rdata[4];
> +	info->reserved_even = rdata[5] & 0x3f;
> +	info->reserved_odd = rdata[6] & 0x3f;
> +
> +	info->cell_id_ok = cell_id_ok & 0x01;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_packet_error_number(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd,
> +						u32 *pen)
> +{
> +	u8 rdata[3];
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!pen))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x26, rdata, 3);
> +	if (ret)
> +		return ret;
> +
> +	if (!(rdata[0] & 0x01))
> +		return -EBUSY;
> +
> +	*pen = (rdata[1] << 8) | rdata[2];
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_spectrum_sense(struct cxd2880_tnrdmd
> +					   *tnr_dmd,
> +					    enum
> +					    cxd2880_tnrdmd_spectrum_sense
> +					    *sense)
> +{
> +	u8 data = 0;
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!sense))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = is_tps_locked(tnr_dmd);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
> +			ret = cxd2880_tnrdmd_dvbt_mon_spectrum_sense(
> +					tnr_dmd->diver_sub, sense);
> +
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x1c, &data, sizeof(data));
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	*sense =
> +	    (data & 0x01) ? CXD2880_TNRDMD_SPECTRUM_INV :
> +	    CXD2880_TNRDMD_SPECTRUM_NORMAL;
> +
> +	return ret;
> +}
> +
> +static int dvbt_read_snr_reg(struct cxd2880_tnrdmd *tnr_dmd,
> +			     u16 *reg_value)
> +{
> +	u8 rdata[2];
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!reg_value))
> +		return -EINVAL;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = is_tps_locked(tnr_dmd);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x13, rdata, 2);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	*reg_value = (rdata[0] << 8) | rdata[1];
> +
> +	return ret;
> +}
> +
> +static int dvbt_calc_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +			 u32 reg_value, int *snr)
> +{
> +	if ((!tnr_dmd) || (!snr))
> +		return -EINVAL;
> +
> +	if (reg_value == 0)
> +		return -EBUSY;
> +
> +	if (reg_value > 4996)
> +		reg_value = 4996;
> +
> +	*snr = intlog10(reg_value) - intlog10(5350 - reg_value);
> +	*snr = (*snr + 839) / 1678 + 28500;
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +				int *snr)
> +{
> +	u16 reg_value = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!snr))
> +		return -EINVAL;
> +
> +	*snr = -1000 * 1000;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
> +		ret = dvbt_read_snr_reg(tnr_dmd, &reg_value);
> +		if (ret)
> +			return ret;
> +
> +		ret = dvbt_calc_snr(tnr_dmd, reg_value, snr);
> +		if (ret)
> +			return ret;
> +	} else {
> +		int snr_main = 0;
> +		int snr_sub = 0;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt_mon_snr_diver(tnr_dmd, snr, &snr_main,
> +						      &snr_sub);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_snr_diver(struct cxd2880_tnrdmd
> +				      *tnr_dmd, int *snr,
> +				      int *snr_main, int *snr_sub)
> +{
> +	u16 reg_value = 0;
> +	u32 reg_value_sum = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!snr) || (!snr_main) || (!snr_sub))
> +		return -EINVAL;
> +
> +	*snr = -1000 * 1000;
> +	*snr_main = -1000 * 1000;
> +	*snr_sub = -1000 * 1000;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = dvbt_read_snr_reg(tnr_dmd, &reg_value);
> +	if (!ret) {
> +		ret = dvbt_calc_snr(tnr_dmd, reg_value, snr_main);
> +		if (ret)
> +			reg_value = 0;
> +	} else if (ret == -EBUSY) {
> +		reg_value = 0;
> +	} else {
> +		return ret;
> +	}
> +
> +	reg_value_sum += reg_value;
> +
> +	ret = dvbt_read_snr_reg(tnr_dmd->diver_sub, &reg_value);
> +	if (!ret) {
> +		ret = dvbt_calc_snr(tnr_dmd->diver_sub, reg_value, snr_sub);
> +		if (ret)
> +			reg_value = 0;
> +	} else if (ret == -EBUSY) {
> +		reg_value = 0;
> +	} else {
> +		return ret;
> +	}
> +
> +	reg_value_sum += reg_value;
> +
> +	ret = dvbt_calc_snr(tnr_dmd, reg_value_sum, snr);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_sampling_offset(struct cxd2880_tnrdmd
> +					    *tnr_dmd, int *ppm)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ppm))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	{
> +		u8 ctl_val_reg[5];
> +		u8 nominal_rate_reg[5];
> +		u32 trl_ctl_val = 0;
> +		u32 trcg_nominal_rate = 0;
> +		int num;
> +		int den;
> +		s8 diff_upper = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret = is_tps_locked(tnr_dmd);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0d);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x21, ctl_val_reg,
> +					     sizeof(ctl_val_reg));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x04);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x60, nominal_rate_reg,
> +					     sizeof(nominal_rate_reg));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		diff_upper =
> +		    (ctl_val_reg[0] & 0x7f) - (nominal_rate_reg[0] & 0x7f);
> +
> +		if ((diff_upper < -1) || (diff_upper > 1))
> +			return -EBUSY;
> +
> +		trl_ctl_val = ctl_val_reg[1] << 24;
> +		trl_ctl_val |= ctl_val_reg[2] << 16;
> +		trl_ctl_val |= ctl_val_reg[3] << 8;
> +		trl_ctl_val |= ctl_val_reg[4];
> +
> +		trcg_nominal_rate = nominal_rate_reg[1] << 24;
> +		trcg_nominal_rate |= nominal_rate_reg[2] << 16;
> +		trcg_nominal_rate |= nominal_rate_reg[3] << 8;
> +		trcg_nominal_rate |= nominal_rate_reg[4];
> +
> +		trl_ctl_val >>= 1;
> +		trcg_nominal_rate >>= 1;
> +
> +		if (diff_upper == 1)
> +			num =
> +			    (int)((trl_ctl_val + 0x80000000u) -
> +				  trcg_nominal_rate);
> +		else if (diff_upper == -1)
> +			num =
> +			    -(int)((trcg_nominal_rate + 0x80000000u) -
> +				   trl_ctl_val);
> +		else
> +			num = (int)(trl_ctl_val - trcg_nominal_rate);
> +
> +		den = (nominal_rate_reg[0] & 0x7f) << 24;
> +		den |= nominal_rate_reg[1] << 16;
> +		den |= nominal_rate_reg[2] << 8;
> +		den |= nominal_rate_reg[3];
> +		den = (den + (390625 / 2)) / 390625;
> +
> +		den >>= 1;
> +
> +		if (num >= 0)
> +			*ppm = (num + (den / 2)) / den;
> +		else
> +			*ppm = (num - (den / 2)) / den;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_sampling_offset_sub(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd, int *ppm)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ppm))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	ret = cxd2880_tnrdmd_dvbt_mon_sampling_offset(tnr_dmd->diver_sub, ppm);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_quality(struct cxd2880_tnrdmd *tnr_dmd,
> +				    u8 *quality)
> +{
> +	struct cxd2880_dvbt_tpsinfo tps;
> +	enum cxd2880_dvbt_profile profile = CXD2880_DVBT_PROFILE_HP;
> +	u32 ber = 0;
> +	int sn = 0;
> +	int sn_rel = 0;
> +	int ber_sqi = 0;
> +
> +	static const int nordig_non_hdvbt_db_1000[3][5] = {
> +		{5100, 6900, 7900, 8900, 9700},
> +		{10800, 13100, 14600, 15600, 16000},
> +		{16500, 18700, 20200, 21600, 22500}
> +	};
> +
> +	static const int nordig_hier_hp_dvbt_db_1000[3][2][5] = {
> +		{
> +		 {9100, 12000, 13600, 15000, 16600},
> +		 {10900, 14100, 15700, 19400, 20600}
> +		 },
> +		{

As explained before, we actually use:

		}, {

Still, better to move all those static consts out of the functions,
as it improves the code reading.

> +		 {6800, 9100, 10400, 11900, 12700},
> +		 {8500, 11000, 12800, 15000, 16000}
> +		 },
> +		{
> +		 {5800, 7900, 9100, 10300, 12100},
> +		 {8000, 9300, 11600, 13000, 12900}
> +		}
> +	};
> +
> +	static const int nordig_hier_lp_dvbt_db_1000[3][2][5] = {
> +		{
> +		 {12500, 14300, 15300, 16300, 16900},
> +		 {16700, 19100, 20900, 22500, 23700}
> +		 },
> +		{
> +		 {15000, 17200, 18400, 19100, 20100},
> +		 {18500, 21200, 23600, 24700, 25900}
> +		 },
> +		{
> +		 {19500, 21400, 22500, 23700, 24700},
> +		 {21900, 24200, 25600, 26900, 27800}
> +		}
> +	};
> +
> +	int ret = 0;

no need to initialize.

> +
> +	if ((!tnr_dmd) || (!quality))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd, &tps);
> +	if (ret)
> +		return ret;
> +
> +	if (tps.hierarchy != CXD2880_DVBT_HIERARCHY_NON) {
> +		u8 data = 0;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x10);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x67, &data, 1);
> +		if (ret)
> +			return ret;
> +
> +		profile =
> +		    ((data & 0x01) ==
> +		     0x01) ? CXD2880_DVBT_PROFILE_LP : CXD2880_DVBT_PROFILE_HP;
> +	}
> +
> +	ret = cxd2880_tnrdmd_dvbt_mon_pre_rsber(tnr_dmd, &ber);
> +	if (ret)
> +		return ret;
> +
> +	ret = cxd2880_tnrdmd_dvbt_mon_snr(tnr_dmd, &sn);
> +	if (ret)
> +		return ret;
> +
> +	if ((tps.constellation >= CXD2880_DVBT_CONSTELLATION_RESERVED_3) ||
> +	    (tps.rate_hp >= CXD2880_DVBT_CODERATE_RESERVED_5) ||
> +	    (tps.rate_lp >= CXD2880_DVBT_CODERATE_RESERVED_5) ||
> +	    (tps.hierarchy > CXD2880_DVBT_HIERARCHY_4)) {
> +		return -EPERM;
> +	}
> +
> +	if ((tps.hierarchy != CXD2880_DVBT_HIERARCHY_NON) &&
> +	    (tps.constellation == CXD2880_DVBT_CONSTELLATION_QPSK))
> +		return -EPERM;
> +
> +	if (tps.hierarchy == CXD2880_DVBT_HIERARCHY_NON)
> +		sn_rel =
> +		    sn -
> +		    nordig_non_hdvbt_db_1000[tps.constellation][tps.rate_hp];
> +	else if (profile == CXD2880_DVBT_PROFILE_LP)
> +		sn_rel =
> +		    sn - nordig_hier_lp_dvbt_db_1000[tps.hierarchy - 1]
> +						    [tps.constellation - 1]
> +						    [tps.rate_lp];
> +	else
> +		sn_rel =
> +		    sn - nordig_hier_hp_dvbt_db_1000[tps.hierarchy - 1]
> +						    [tps.constellation - 1]
> +						    [tps.rate_hp];
> +
> +	if (ber > 10000) {
> +		ber_sqi = 0;
> +	} else if (ber > 1) {
> +		ber_sqi = (int)((intlog10(ber) + 8388) / 16777);
> +		ber_sqi = 20 * (7 * 1000 - (ber_sqi)) - 40 * 1000;
> +	} else {
> +		ber_sqi = 100 * 1000;
> +	}
> +
> +	if (sn_rel < -7 * 1000) {
> +		*quality = 0;
> +	} else if (sn_rel < 3 * 1000) {
> +		int tmp_sqi = (((sn_rel - (3 * 1000)) / 10) + 1000);
> +		*quality =
> +		    (u8)(((tmp_sqi * ber_sqi) +
> +			   (1000000 / 2)) / (1000000)) & 0xff;
> +	} else {
> +		*quality = (u8)((ber_sqi + 500) / 1000);
> +	}
> +
> +	if (*quality > 100)
> +		*quality = 100;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
> +				u32 *per)
> +{
> +	u32 packet_error = 0;
> +	u32 period = 0;
> +	u8 rdata[3];
> +
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!per))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0d);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x18, rdata, 3);
> +	if (ret)
> +		return ret;
> +
> +	if ((rdata[0] & 0x01) == 0)
> +		return -EBUSY;
> +
> +	packet_error = (rdata[1] << 8) | rdata[2];
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x10);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x5c, rdata, 1);
> +	if (ret)
> +		return ret;
> +
> +	period = 1U << (rdata[0] & 0x0f);
> +
> +	if ((period == 0) || (packet_error > period))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		div = period;
> +
> +		Q = (packet_error * 1000) / div;
> +		R = (packet_error * 1000) % div;
> +
> +		R *= 1000;
> +		Q = Q * 1000 + R / div;
> +		R = R % div;
> +
> +		if ((div != 1) && (div / 2 <= R))
> +			*per = Q + 1;
> +		else
> +			*per = Q;
> +	}
> +
> +	return ret;
> +}
> +
> +static int dvbt_calc_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +			 int rf_lvl, u8 *ssi)
> +{
> +	struct cxd2880_dvbt_tpsinfo tps;
> +	int prel;
> +	int temp_ssi = 0;
> +	int ret = 0;
> +
> +	static const int ref_dbm_1000[3][5] = {
> +		{-93000, -91000, -90000, -89000, -88000},
> +		{-87000, -85000, -84000, -83000, -82000},
> +		{-82000, -80000, -78000, -77000, -76000},
> +	};
> +
> +	if ((!tnr_dmd) || (!ssi))
> +		return -EINVAL;
> +
> +	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(tnr_dmd, &tps);
> +	if (ret)
> +		return ret;
> +
> +	if ((tps.constellation >= CXD2880_DVBT_CONSTELLATION_RESERVED_3) ||
> +	    (tps.rate_hp >= CXD2880_DVBT_CODERATE_RESERVED_5))
> +		return -EPERM;
> +
> +	prel = rf_lvl - ref_dbm_1000[tps.constellation][tps.rate_hp];
> +
> +	if (prel < -15000)
> +		temp_ssi = 0;
> +	else if (prel < 0)
> +		temp_ssi = ((2 * (prel + 15000)) + 1500) / 3000;
> +	else if (prel < 20000)
> +		temp_ssi = (((4 * prel) + 500) / 1000) + 10;
> +	else if (prel < 35000)
> +		temp_ssi = (((2 * (prel - 20000)) + 1500) / 3000) + 90;
> +	else
> +		temp_ssi = 100;
> +
> +	*ssi = (temp_ssi > 100) ? 100 : (u8)temp_ssi;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +				u8 *ssi)
> +{
> +	int rf_lvl = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ssi))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd, &rf_lvl);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt_calc_ssi(tnr_dmd, rf_lvl, ssi);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt_mon_ssi_sub(struct cxd2880_tnrdmd *tnr_dmd,
> +				    u8 *ssi)
> +{
> +	int rf_lvl = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ssi))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd->diver_sub, &rf_lvl);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt_calc_ssi(tnr_dmd, rf_lvl, ssi);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +static int is_tps_locked(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	u8 sync = 0;
> +	u8 tslock = 0;
> +	u8 early_unlock = 0;
> +	int ret = 0;
> +
> +	if (!tnr_dmd)
> +		return -EINVAL;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt_mon_sync_stat(tnr_dmd, &sync, &tslock,
> +					      &early_unlock);
> +	if (ret)
> +		return ret;
> +
> +	if (sync != 6)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
> new file mode 100644
> index 000000000000..ce966270c69b
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
> @@ -0,0 +1,106 @@
> +/*
> + * cxd2880_tnrdmd_dvbt_mon.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * DVB-T monitor interface
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
> +#ifndef CXD2880_TNRDMD_DVBT_MON_H
> +#define CXD2880_TNRDMD_DVBT_MON_H
> +
> +#include "cxd2880_tnrdmd.h"
> +#include "cxd2880_dvbt.h"
> +
> +int cxd2880_tnrdmd_dvbt_mon_sync_stat(struct cxd2880_tnrdmd
> +				      *tnr_dmd, u8 *sync_stat,
> +				      u8 *ts_lock_stat,
> +				      u8 *unlock_detected);
> +
> +int cxd2880_tnrdmd_dvbt_mon_sync_stat_sub(struct cxd2880_tnrdmd
> +					  *tnr_dmd, u8 *sync_stat,
> +					  u8 *unlock_detected);
> +
> +int cxd2880_tnrdmd_dvbt_mon_mode_guard(struct cxd2880_tnrdmd
> +				       *tnr_dmd,
> +				       enum cxd2880_dvbt_mode
> +				       *mode,
> +				       enum cxd2880_dvbt_guard
> +				       *guard);
> +
> +int cxd2880_tnrdmd_dvbt_mon_carrier_offset(struct cxd2880_tnrdmd
> +					   *tnr_dmd, int *offset);
> +
> +int cxd2880_tnrdmd_dvbt_mon_carrier_offset_sub(struct
> +					       cxd2880_tnrdmd
> +					       *tnr_dmd,
> +					       int *offset);
> +
> +int cxd2880_tnrdmd_dvbt_mon_pre_viterbiber(struct cxd2880_tnrdmd
> +					   *tnr_dmd, u32 *ber);
> +
> +int cxd2880_tnrdmd_dvbt_mon_pre_rsber(struct cxd2880_tnrdmd
> +				      *tnr_dmd, u32 *ber);
> +
> +int cxd2880_tnrdmd_dvbt_mon_tps_info(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     struct cxd2880_dvbt_tpsinfo
> +				     *info);
> +
> +int cxd2880_tnrdmd_dvbt_mon_packet_error_number(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd,
> +						u32 *pen);
> +
> +int cxd2880_tnrdmd_dvbt_mon_spectrum_sense(struct cxd2880_tnrdmd
> +					   *tnr_dmd,
> +					   enum
> +					   cxd2880_tnrdmd_spectrum_sense
> +					   *sense);
> +
> +int cxd2880_tnrdmd_dvbt_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +				int *snr);
> +
> +int cxd2880_tnrdmd_dvbt_mon_snr_diver(struct cxd2880_tnrdmd
> +				      *tnr_dmd, int *snr,
> +				      int *snr_main, int *snr_sub);
> +
> +int cxd2880_tnrdmd_dvbt_mon_sampling_offset(struct cxd2880_tnrdmd
> +					    *tnr_dmd, int *ppm);
> +
> +int cxd2880_tnrdmd_dvbt_mon_sampling_offset_sub(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd,
> +						int *ppm);
> +
> +int cxd2880_tnrdmd_dvbt_mon_quality(struct cxd2880_tnrdmd *tnr_dmd,
> +				    u8 *quality);
> +
> +int cxd2880_tnrdmd_dvbt_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
> +				u32 *per);
> +
> +int cxd2880_tnrdmd_dvbt_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +				u8 *ssi);
> +
> +int cxd2880_tnrdmd_dvbt_mon_ssi_sub(struct cxd2880_tnrdmd *tnr_dmd,
> +				    u8 *ssi);
> +
> +#endif



Thanks,
Mauro
