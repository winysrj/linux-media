Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55782
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdH0Pow (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 11:44:52 -0400
Date: Sun, 27 Aug 2017 12:44:37 -0300
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
Subject: Re: [PATCH v3 11/14] [media] cxd2880: Add DVB-T2 monitor and
 integration layer functions
Message-ID: <20170827124437.0125d8e8@vento.lan>
In-Reply-To: <20170816044341.21683-1-Yasunari.Takiguchi@sony.com>
References: <20170816041714.20551-1-Yasunari.Takiguchi@sony.com>
        <20170816044341.21683-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Aug 2017 13:43:41 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> Provide monitor and integration layer functions (DVB-T2)
> for the Sony CXD2880 DVB-T2/T tuner + demodulator driver.
> 
> [Change list]
> Changes in V3
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
>       -changed CXD2880_SLEEP to usleep_range
>       -replaced cxd2880_atomic_set to atomic_set
>       -modified return code
>       -modified coding style of if()  
>    drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
>       -modified return code
>       -changed hexadecimal code to lower case. 
>    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
>       -removed unnecessary cast
>       -changed cxd2880_math_log to intlog10
>       -modified return code
>       -modified coding style of if() 
>       -changed hexadecimal code to lower case. 
>    drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
>       -modified return code
> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
>  .../dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c    |  312 +++
>  .../dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h    |   64 +
>  .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.c             | 2622 ++++++++++++++++++++
>  .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.h             |  170 ++
>  4 files changed, 3168 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
> 
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
> new file mode 100644
> index 000000000000..ac049820d797
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.c
> @@ -0,0 +1,312 @@
> +/*
> + * cxd2880_integ_dvbt2.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer functions for DVB-T2
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
> +#include "cxd2880_tnrdmd_dvbt2.h"
> +#include "cxd2880_tnrdmd_dvbt2_mon.h"
> +#include "cxd2880_integ_dvbt2.h"
> +
> +static int dvbt2_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd,
> +				 enum cxd2880_dvbt2_profile
> +				 profile);
> +
> +static int dvbt2_wait_l1_post_lock(struct cxd2880_tnrdmd *tnr_dmd);
> +
> +int cxd2880_integ_dvbt2_tune(struct cxd2880_tnrdmd *tnr_dmd,
> +			     struct cxd2880_dvbt2_tune_param
> +			     *tune_param)
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
> +	if ((tune_param->bandwidth != CXD2880_DTV_BW_1_7_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_5_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_6_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_7_MHZ) &&
> +	    (tune_param->bandwidth != CXD2880_DTV_BW_8_MHZ)) {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if ((tune_param->profile != CXD2880_DVBT2_PROFILE_BASE) &&
> +	    (tune_param->profile != CXD2880_DVBT2_PROFILE_LITE))
> +		return -EINVAL;
> +
> +	ret = cxd2880_tnrdmd_dvbt2_tune1(tnr_dmd, tune_param);
> +	if (ret)
> +		return ret;
> +
> +	usleep_range(CXD2880_TNRDMD_WAIT_AGC_STABLE * 10000,
> +		     CXD2880_TNRDMD_WAIT_AGC_STABLE * 10000 + 1000);
> +
> +	ret = cxd2880_tnrdmd_dvbt2_tune2(tnr_dmd, tune_param);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt2_wait_demod_lock(tnr_dmd, tune_param->profile);
> +	if (ret)
> +		return ret;
> +
> +	ret = cxd2880_tnrdmd_dvbt2_diver_fef_setting(tnr_dmd);
> +	if (ret == -EBUSY)
> +		return -EAGAIN;
> +	else if (ret)
> +		return ret;
> +
> +	ret = dvbt2_wait_l1_post_lock(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 plp_not_found;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_data_plp_error(tnr_dmd,
> +							    &plp_not_found);
> +		if (ret == -EBUSY)
> +			return -EAGAIN;
> +		else if (ret)
> +			return ret;
> +
> +		if (plp_not_found) {
> +			ret = -0;
> +			tune_param->tune_info =
> +			    CXD2880_TNRDMD_DVBT2_TUNE_INFO_INVALID_PLP_ID;
> +		} else {
> +			tune_param->tune_info =
> +			    CXD2880_TNRDMD_DVBT2_TUNE_INFO_OK;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_integ_dvbt2_wait_ts_lock(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_profile
> +				     profile)
> +{

Same notes I made for DVB-T apply: it is up to userspace to wait for
device's lock. Are there any special reason why in this hardware
such lock should be done by the Kernel driver?

> +	int ret = 0;
> +	enum cxd2880_tnrdmd_lock_result lock =
> +	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
> +	u16 timeout = 0;
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
> +	if (profile == CXD2880_DVBT2_PROFILE_BASE)
> +		timeout = CXD2880_DVBT2_BASE_WAIT_TS_LOCK;
> +	else if (profile == CXD2880_DVBT2_PROFILE_LITE)
> +		timeout = CXD2880_DVBT2_LITE_WAIT_TS_LOCK;
> +	else
> +		return -EINVAL;
> +
> +	for (;;) {

Same note here: use while(1) {} for infinite loops. Extra care is
required to not hang the Kernel.

> +		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
> +		if (ret)
> +			return ret;
> +
> +		if (elapsed >= timeout)
> +			continue_wait = 0;
> +
> +		ret = cxd2880_tnrdmd_dvbt2_check_ts_lock(tnr_dmd, &lock);
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
> +					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
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
> +static int dvbt2_wait_demod_lock(struct cxd2880_tnrdmd *tnr_dmd,
> +				 enum cxd2880_dvbt2_profile
> +				 profile)
> +{
> +	int ret = 0;
> +	enum cxd2880_tnrdmd_lock_result lock =
> +	    CXD2880_TNRDMD_LOCK_RESULT_NOTDETECT;
> +	u16 timeout = 0;
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
> +	if (profile == CXD2880_DVBT2_PROFILE_BASE)
> +		timeout = CXD2880_DVBT2_BASE_WAIT_DMD_LOCK;
> +	else if ((profile == CXD2880_DVBT2_PROFILE_LITE) ||
> +		 (profile == CXD2880_DVBT2_PROFILE_ANY))
> +		timeout = CXD2880_DVBT2_LITE_WAIT_DMD_LOCK;
> +	else
> +		return -EPERM;
> +
> +	for (;;) {
> +		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed);
> +		if (ret)
> +			return ret;
> +
> +		if (elapsed >= timeout)
> +			continue_wait = 0;
> +
> +		ret = cxd2880_tnrdmd_dvbt2_check_demod_lock(tnr_dmd, &lock);
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
> +					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
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
> +static int dvbt2_wait_l1_post_lock(struct cxd2880_tnrdmd *tnr_dmd)
> +{
> +	int ret = 0;
> +	struct cxd2880_stopwatch timer;
> +	u8 continue_wait = 1;
> +	unsigned int elapsed = 0;
> +	u8 l1_post_valid;
> +
> +	if (!tnr_dmd)
> +		return -EINVAL;
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
> +		if (elapsed >= CXD2880_DVBT2_L1POST_TIMEOUT)
> +			continue_wait = 0;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_check_l1post_valid(tnr_dmd,
> +							    &l1_post_valid);
> +		if (ret)
> +			return ret;
> +
> +		if (l1_post_valid)
> +			return 0;
> +
> +		ret = cxd2880_integ_check_cancellation(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		if (continue_wait) {
> +			ret =
> +			    cxd2880_stopwatch_sleep(&timer,
> +					    CXD2880_DVBT2_WAIT_LOCK_INTVL);
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
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
> new file mode 100644
> index 000000000000..c7b1df6306df
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ_dvbt2.h
> @@ -0,0 +1,64 @@
> +/*
> + * cxd2880_integ_dvbt2.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * integration layer interface for DVB-T2
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
> +#ifndef CXD2880_INTEG_DVBT2_H
> +#define CXD2880_INTEG_DVBT2_H
> +
> +#include "cxd2880_tnrdmd.h"
> +#include "cxd2880_tnrdmd_dvbt2.h"
> +#include "cxd2880_integ.h"
> +
> +#define CXD2880_DVBT2_BASE_WAIT_DMD_LOCK     3500
> +#define CXD2880_DVBT2_BASE_WAIT_TS_LOCK	1500
> +#define CXD2880_DVBT2_LITE_WAIT_DMD_LOCK     5000
> +#define CXD2880_DVBT2_LITE_WAIT_TS_LOCK	2300
> +#define CXD2880_DVBT2_WAIT_LOCK_INTVL       10
> +#define CXD2880_DVBT2_L1POST_TIMEOUT	   500
> +
> +struct cxd2880_integ_dvbt2_scan_param {
> +	u32 start_frequency_khz;
> +	u32 end_frequency_khz;
> +	u32 step_frequency_khz;
> +	enum cxd2880_dtv_bandwidth bandwidth;
> +	enum cxd2880_dvbt2_profile t2_profile;
> +};
> +
> +struct cxd2880_integ_dvbt2_scan_result {
> +	u32 center_freq_khz;
> +	int tune_result;
> +	struct cxd2880_dvbt2_tune_param dvbt2_tune_param;
> +};
> +
> +int cxd2880_integ_dvbt2_tune(struct cxd2880_tnrdmd *tnr_dmd,
> +			     struct cxd2880_dvbt2_tune_param
> +			     *tune_param);
> +
> +int cxd2880_integ_dvbt2_wait_ts_lock(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_profile
> +				     profile);
> +
> +#endif
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
> new file mode 100644
> index 000000000000..62ee5d540dff
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
> @@ -0,0 +1,2622 @@
> +/*
> + * cxd2880_tnrdmd_dvbt2_mon.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * DVB-T2 monitor functions
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
> +#include "cxd2880_tnrdmd_dvbt2.h"
> +#include "cxd2880_tnrdmd_dvbt2_mon.h"
> +
> +#include "dvb_math.h"
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sync_stat(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *sync_stat,
> +				       u8 *ts_lock_stat,
> +				       u8 *unlock_detected)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!sync_stat) || (!ts_lock_stat) || (!unlock_detected))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 data;

Same notes that I made to other patches apply here.

> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x10, &data, sizeof(data));
> +		if (ret)
> +			return ret;
> +
> +		*sync_stat = data & 0x07;
> +		*ts_lock_stat = ((data & 0x20) ? 1 : 0);
> +		*unlock_detected = ((data & 0x10) ? 1 : 0);
> +	}
> +
> +	if (*sync_stat == 0x07)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(struct cxd2880_tnrdmd
> +					   *tnr_dmd,
> +					   u8 *sync_stat,
> +					   u8 *unlock_detected)
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
> +	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd->diver_sub, sync_stat,
> +					       &ts_lock_stat, unlock_detected);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_carrier_offset(struct cxd2880_tnrdmd
> +					    *tnr_dmd, int *offset)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!offset))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[4];
> +		u32 ctl_val = 0;
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state != 6) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x30, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		ctl_val =
> +		    ((data[0] & 0x0f) << 24) | (data[1] << 16) | (data[2] << 8)
> +		    | (data[3]);
> +		*offset = cxd2880_convert2s_complement(ctl_val, 28);
> +
> +		switch (tnr_dmd->bandwidth) {
> +		case CXD2880_DTV_BW_1_7_MHZ:
> +			*offset = -1 * ((*offset) / 582);
> +			break;
> +		case CXD2880_DTV_BW_5_MHZ:
> +		case CXD2880_DTV_BW_6_MHZ:
> +		case CXD2880_DTV_BW_7_MHZ:
> +		case CXD2880_DTV_BW_8_MHZ:
> +			*offset =
> +			    -1 * ((*offset) * tnr_dmd->bandwidth / 940);
> +			break;
> +		default:
> +			return -EPERM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_carrier_offset_sub(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd,
> +						int *offset)
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
> +	    cxd2880_tnrdmd_dvbt2_mon_carrier_offset(tnr_dmd->diver_sub, offset);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_pre(struct cxd2880_tnrdmd *tnr_dmd,
> +				    struct cxd2880_dvbt2_l1pre
> +				    *l1_pre)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!l1_pre))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[37];
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +		u8 version = 0;
> +		enum cxd2880_dvbt2_profile profile;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state < 5) {
> +			if (tnr_dmd->diver_mode ==
> +			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
> +				ret =
> +				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
> +				    (tnr_dmd, &sync_state, &unlock_detected);
> +				if (ret) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return ret;
> +				}
> +
> +				if (sync_state < 5) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return -EBUSY;
> +				}
> +			} else {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return -EBUSY;
> +			}
> +		}
> +
> +		ret = cxd2880_tnrdmd_dvbt2_mon_profile(tnr_dmd, &profile);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x61, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		l1_pre->type = (enum cxd2880_dvbt2_l1pre_type)data[0];
> +		l1_pre->bw_ext = data[1] & 0x01;
> +		l1_pre->s1 = (enum cxd2880_dvbt2_s1)(data[2] & 0x07);
> +		l1_pre->s2 = data[3] & 0x0f;
> +		l1_pre->l1_rep = data[4] & 0x01;
> +		l1_pre->gi = (enum cxd2880_dvbt2_guard)(data[5] & 0x07);
> +		l1_pre->papr = (enum cxd2880_dvbt2_papr)(data[6] & 0x0f);
> +		l1_pre->mod =
> +		    (enum cxd2880_dvbt2_l1post_constell)(data[7] & 0x0f);
> +		l1_pre->cr = (enum cxd2880_dvbt2_l1post_cr)(data[8] & 0x03);
> +		l1_pre->fec =
> +		    (enum cxd2880_dvbt2_l1post_fec_type)(data[9] & 0x03);
> +		l1_pre->l1_post_size = (data[10] & 0x03) << 16;
> +		l1_pre->l1_post_size |= (data[11]) << 8;
> +		l1_pre->l1_post_size |= (data[12]);
> +		l1_pre->l1_post_info_size = (data[13] & 0x03) << 16;
> +		l1_pre->l1_post_info_size |= (data[14]) << 8;
> +		l1_pre->l1_post_info_size |= (data[15]);
> +		l1_pre->pp = (enum cxd2880_dvbt2_pp)(data[16] & 0x0f);
> +		l1_pre->tx_id_availability = data[17];
> +		l1_pre->cell_id = (data[18] << 8);
> +		l1_pre->cell_id |= (data[19]);
> +		l1_pre->network_id = (data[20] << 8);
> +		l1_pre->network_id |= (data[21]);
> +		l1_pre->sys_id = (data[22] << 8);
> +		l1_pre->sys_id |= (data[23]);
> +		l1_pre->num_frames = data[24];
> +		l1_pre->num_symbols = (data[25] & 0x0f) << 8;
> +		l1_pre->num_symbols |= data[26];
> +		l1_pre->regen = data[27] & 0x07;
> +		l1_pre->post_ext = data[28] & 0x01;
> +		l1_pre->num_rf_freqs = data[29] & 0x07;
> +		l1_pre->rf_idx = data[30] & 0x07;
> +		version = (data[31] & 0x03) << 2;
> +		version |= (data[32] & 0xc0) >> 6;
> +		l1_pre->t2_version = (enum cxd2880_dvbt2_version)version;
> +		l1_pre->l1_post_scrambled = (data[32] & 0x20) >> 5;
> +		l1_pre->t2_base_lite = (data[32] & 0x10) >> 4;
> +		l1_pre->crc32 = (data[33] << 24);
> +		l1_pre->crc32 |= (data[34] << 16);
> +		l1_pre->crc32 |= (data[35] << 8);
> +		l1_pre->crc32 |= data[36];
> +
> +		if (profile == CXD2880_DVBT2_PROFILE_BASE) {
> +			switch ((l1_pre->s2 >> 1)) {
> +			case CXD2880_DVBT2_BASE_S2_M1K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M1K;
> +				break;
> +			case CXD2880_DVBT2_BASE_S2_M2K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M2K;
> +				break;
> +			case CXD2880_DVBT2_BASE_S2_M4K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M4K;
> +				break;
> +			case CXD2880_DVBT2_BASE_S2_M8K_G_DVBT:
> +			case CXD2880_DVBT2_BASE_S2_M8K_G_DVBT2:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M8K;
> +				break;
> +			case CXD2880_DVBT2_BASE_S2_M16K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M16K;
> +				break;
> +			case CXD2880_DVBT2_BASE_S2_M32K_G_DVBT:
> +			case CXD2880_DVBT2_BASE_S2_M32K_G_DVBT2:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M32K;
> +				break;
> +			default:
> +				return -EBUSY;
> +			}
> +		} else if (profile == CXD2880_DVBT2_PROFILE_LITE) {
> +			switch ((l1_pre->s2 >> 1)) {
> +			case CXD2880_DVBT2_LITE_S2_M2K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M2K;
> +				break;
> +			case CXD2880_DVBT2_LITE_S2_M4K_G_ANY:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M4K;
> +				break;
> +			case CXD2880_DVBT2_LITE_S2_M8K_G_DVBT:
> +			case CXD2880_DVBT2_LITE_S2_M8K_G_DVBT2:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M8K;
> +				break;
> +			case CXD2880_DVBT2_LITE_S2_M16K_G_DVBT:
> +			case CXD2880_DVBT2_LITE_S2_M16K_G_DVBT2:
> +				l1_pre->fft_mode = CXD2880_DVBT2_M16K;
> +				break;
> +			default:
> +				return -EBUSY;
> +			}
> +		} else {
> +			return -EBUSY;
> +		}
> +
> +		l1_pre->mixed = l1_pre->s2 & 0x01;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_version(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_version
> +				     *ver)
> +{
> +	int ret = 0;
> +	u8 version = 0;
> +
> +	if ((!tnr_dmd) || (!ver))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[2];
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state < 5) {
> +			if (tnr_dmd->diver_mode ==
> +			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
> +				ret =
> +				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
> +				    (tnr_dmd, &sync_state, &unlock_detected);
> +				if (ret) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return ret;
> +				}
> +
> +				if (sync_state < 5) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return -EBUSY;
> +				}
> +			} else {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return -EBUSY;
> +			}
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x80, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		version = ((data[0] & 0x03) << 2);
> +		version |= ((data[1] & 0xc0) >> 6);
> +		*ver = (enum cxd2880_dvbt2_version)version;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ofdm(struct cxd2880_tnrdmd *tnr_dmd,
> +				  struct cxd2880_dvbt2_ofdm *ofdm)
> +{
> +	if ((!tnr_dmd) || (!ofdm))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[5];
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +		int ret = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state != 6) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +
> +			ret = -EBUSY;
> +
> +			if (tnr_dmd->diver_mode ==
> +			    CXD2880_TNRDMD_DIVERMODE_MAIN)
> +				ret =
> +				    cxd2880_tnrdmd_dvbt2_mon_ofdm(
> +					tnr_dmd->diver_sub, ofdm);
> +
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x1d, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		ofdm->mixed = ((data[0] & 0x20) ? 1 : 0);
> +		ofdm->is_miso = ((data[0] & 0x10) >> 4);
> +		ofdm->mode = (enum cxd2880_dvbt2_mode)(data[0] & 0x07);
> +		ofdm->gi = (enum cxd2880_dvbt2_guard)((data[1] & 0x70) >> 4);
> +		ofdm->pp = (enum cxd2880_dvbt2_pp)(data[1] & 0x07);
> +		ofdm->bw_ext = (data[2] & 0x10) >> 4;
> +		ofdm->papr = (enum cxd2880_dvbt2_papr)(data[2] & 0x0f);
> +		ofdm->num_symbols = (data[3] << 8) | data[4];
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_data_plps(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *plp_ids,
> +				       u8 *num_plps)
> +{
> +	if ((!tnr_dmd) || (!num_plps))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 l1_post_ok = 0;
> +		int ret = 0;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret)
> +			return ret;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, &l1_post_ok, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!(l1_post_ok & 0x01)) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xc1, num_plps, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (*num_plps == 0) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EPERM;
> +		}
> +
> +		if (!plp_ids) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return 0;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xc2,
> +					     plp_ids,
> +					     ((*num_plps > 62) ?
> +					     62 : *num_plps));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (*num_plps > 62) {
> +			ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +						     CXD2880_IO_TGT_DMD,
> +						     0x00, 0x0c);
> +			if (ret) {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return ret;
> +			}
> +
> +			ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +						     CXD2880_IO_TGT_DMD,
> +						     0x10, plp_ids + 62,
> +						     *num_plps - 62);
> +			if (ret) {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return ret;
> +			}
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +	}
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_active_plp(struct cxd2880_tnrdmd
> +					*tnr_dmd,
> +					enum
> +					cxd2880_dvbt2_plp_btype
> +					type,
> +					struct cxd2880_dvbt2_plp
> +					*plp_info)
> +{
> +	if ((!tnr_dmd) || (!plp_info))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[20];
> +		u8 addr = 0;
> +		u8 index = 0;
> +		u8 l1_post_ok = 0;
> +		int ret = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, &l1_post_ok, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!l1_post_ok) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		if (type == CXD2880_DVBT2_PLP_COMMON)
> +			addr = 0xa9;
> +		else
> +			addr = 0x96;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     addr, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		if ((type == CXD2880_DVBT2_PLP_COMMON) && (data[13] == 0))
> +			return -EBUSY;
> +
> +		plp_info->id = data[index++];
> +		plp_info->type =
> +		    (enum cxd2880_dvbt2_plp_type)(data[index++] & 0x07);
> +		plp_info->payload =
> +		    (enum cxd2880_dvbt2_plp_payload)(data[index++] & 0x1f);
> +		plp_info->ff = data[index++] & 0x01;
> +		plp_info->first_rf_idx = data[index++] & 0x07;
> +		plp_info->first_frm_idx = data[index++];
> +		plp_info->group_id = data[index++];
> +		plp_info->plp_cr =
> +		    (enum cxd2880_dvbt2_plp_code_rate)(data[index++] & 0x07);
> +		plp_info->constell =
> +		    (enum cxd2880_dvbt2_plp_constell)(data[index++] & 0x07);
> +		plp_info->rot = data[index++] & 0x01;
> +		plp_info->fec =
> +		    (enum cxd2880_dvbt2_plp_fec)(data[index++] & 0x03);
> +		plp_info->num_blocks_max = (data[index++] & 0x03) << 8;
> +		plp_info->num_blocks_max |= data[index++];
> +		plp_info->frm_int = data[index++];
> +		plp_info->til_len = data[index++];
> +		plp_info->til_type = data[index++] & 0x01;
> +
> +		plp_info->in_band_a_flag = data[index++] & 0x01;
> +		plp_info->rsvd = data[index++] << 8;
> +		plp_info->rsvd |= data[index++];
> +
> +		plp_info->in_band_b_flag =
> +		    (plp_info->rsvd & 0x8000) >> 15;
> +		plp_info->plp_mode =
> +		    (enum cxd2880_dvbt2_plp_mode)((plp_info->rsvd & 0x000c) >>
> +						  2);
> +		plp_info->static_flag = (plp_info->rsvd & 0x0002) >> 1;
> +		plp_info->static_padding_flag = plp_info->rsvd & 0x0001;
> +		plp_info->rsvd = (plp_info->rsvd & 0x7ff0) >> 4;
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_data_plp_error(struct cxd2880_tnrdmd
> +					    *tnr_dmd,
> +					    u8 *plp_error)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!plp_error))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 data;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if ((data & 0x01) == 0x00) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xc0, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		*plp_error = data & 0x01;
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_change(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *l1_change)
> +{
> +	if ((!tnr_dmd) || (!l1_change))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data;
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +		int ret = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state < 5) {
> +			if (tnr_dmd->diver_mode ==
> +			    CXD2880_TNRDMD_DIVERMODE_MAIN) {
> +				ret =
> +				    cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub
> +				    (tnr_dmd, &sync_state, &unlock_detected);
> +				if (ret) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return ret;
> +				}
> +
> +				if (sync_state < 5) {
> +					slvt_unfreeze_reg(tnr_dmd);
> +					return -EBUSY;
> +				}
> +			} else {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return -EBUSY;
> +			}
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x5f, &data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		*l1_change = data & 0x01;
> +		if (*l1_change) {
> +			ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +						     CXD2880_IO_TGT_DMD,
> +						     0x00, 0x22);
> +			if (ret) {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return ret;
> +			}
> +
> +			ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +						     CXD2880_IO_TGT_DMD,
> +						     0x16, 0x01);
> +			if (ret) {
> +				slvt_unfreeze_reg(tnr_dmd);
> +				return ret;
> +			}
> +		}
> +		slvt_unfreeze_reg(tnr_dmd);
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_post(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     struct cxd2880_dvbt2_l1post
> +				     *l1_post)
> +{
> +	if ((!tnr_dmd) || (!l1_post))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[16];
> +		int ret = 0;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, data, sizeof(data));
> +		if (ret)
> +			return ret;
> +
> +		if (!(data[0] & 0x01))
> +			return -EBUSY;
> +
> +		l1_post->sub_slices_per_frame = (data[1] & 0x7f) << 8;
> +		l1_post->sub_slices_per_frame |= data[2];
> +		l1_post->num_plps = data[3];
> +		l1_post->num_aux = data[4] & 0x0f;
> +		l1_post->aux_cfg_rfu = data[5];
> +		l1_post->rf_idx = data[6] & 0x07;
> +		l1_post->freq = data[7] << 24;
> +		l1_post->freq |= data[8] << 16;
> +		l1_post->freq |= data[9] << 8;
> +		l1_post->freq |= data[10];
> +		l1_post->fef_type = data[11] & 0x0f;
> +		l1_post->fef_length = data[12] << 16;
> +		l1_post->fef_length |= data[13] << 8;
> +		l1_post->fef_length |= data[14];
> +		l1_post->fef_intvl = data[15];
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_bbheader(struct cxd2880_tnrdmd
> +				      *tnr_dmd,
> +				      enum cxd2880_dvbt2_plp_btype
> +				      type,
> +				      struct cxd2880_dvbt2_bbheader
> +				      *bbheader)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!bbheader))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!ts_lock) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	if (type == CXD2880_DVBT2_PLP_COMMON) {
> +		u8 l1_post_ok;
> +		u8 data;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, &l1_post_ok, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!(l1_post_ok & 0x01)) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xb6, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (data == 0) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	{
> +		u8 data[14];
> +		u8 addr = 0;
> +
> +		if (type == CXD2880_DVBT2_PLP_COMMON)
> +			addr = 0x51;
> +		else
> +			addr = 0x42;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     addr, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		bbheader->stream_input =
> +		    (enum cxd2880_dvbt2_stream)((data[0] >> 6) & 0x03);
> +		bbheader->is_single_input_stream = (data[0] >> 5) & 0x01;
> +		bbheader->is_constant_coding_modulation =
> +		    (data[0] >> 4) & 0x01;
> +		bbheader->issy_indicator = (data[0] >> 3) & 0x01;
> +		bbheader->null_packet_deletion = (data[0] >> 2) & 0x01;
> +		bbheader->ext = data[0] & 0x03;
> +
> +		bbheader->input_stream_identifier = data[1];
> +		bbheader->plp_mode =
> +		    (data[3] & 0x01) ? CXD2880_DVBT2_PLP_MODE_HEM :
> +		    CXD2880_DVBT2_PLP_MODE_NM;
> +		bbheader->data_field_length = (data[4] << 8) | data[5];
> +
> +		if (bbheader->plp_mode == CXD2880_DVBT2_PLP_MODE_NM) {
> +			bbheader->user_packet_length =
> +			    (data[6] << 8) | data[7];
> +			bbheader->sync_byte = data[8];
> +			bbheader->issy = 0;
> +		} else {
> +			bbheader->user_packet_length = 0;
> +			bbheader->sync_byte = 0;
> +			bbheader->issy =
> +			    (data[11] << 16) | (data[12] << 8) | data[13];
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_in_bandb_ts_rate(struct cxd2880_tnrdmd
> +					      *tnr_dmd,
> +					      enum
> +					      cxd2880_dvbt2_plp_btype
> +					      type,
> +					      u32 *ts_rate_bps)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ts_rate_bps))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!ts_lock) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	{
> +		u8 l1_post_ok = 0;
> +		u8 addr = 0;
> +		u8 data = 0;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x86, &l1_post_ok, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!(l1_post_ok & 0x01)) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		if (type == CXD2880_DVBT2_PLP_COMMON)
> +			addr = 0xba;
> +		else
> +			addr = 0xa7;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     addr, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if ((data & 0x80) == 0x00) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x25);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	{
> +		u8 data[4];
> +		u8 addr = 0;
> +
> +		if (type == CXD2880_DVBT2_PLP_COMMON)
> +			addr = 0xa6;
> +		else
> +			addr = 0xaa;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     addr, &data[0], 4);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		*ts_rate_bps = ((data[0] & 0x07) << 24) | (data[1] << 16) |
> +			       (data[2] << 8) | data[3];
> +	}
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(struct cxd2880_tnrdmd
> +					    *tnr_dmd,
> +					    enum
> +					    cxd2880_tnrdmd_spectrum_sense
> +					    *sense)
> +{
> +	int ret = 0;
> +	u8 sync_state = 0;
> +	u8 ts_lock = 0;
> +	u8 early_unlock = 0;
> +
> +	if ((!tnr_dmd) || (!sense))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state, &ts_lock,
> +					       &early_unlock);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	if (sync_state != 6) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		ret = -EBUSY;
> +
> +		if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_MAIN)
> +			ret =
> +			    cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(
> +				tnr_dmd->diver_sub, sense);
> +
> +		return ret;
> +	}
> +
> +	{
> +		u8 data = 0;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x2f, &data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		*sense =
> +		    (data & 0x01) ? CXD2880_TNRDMD_SPECTRUM_INV :
> +		    CXD2880_TNRDMD_SPECTRUM_NORMAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dvbt2_read_snr_reg(struct cxd2880_tnrdmd *tnr_dmd,
> +			      u16 *reg_value)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!reg_value))
> +		return -EINVAL;
> +
> +	{
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +		u8 data[2];
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state != 6) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x13, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		*reg_value = (data[0] << 8) | data[1];
> +	}
> +
> +	return ret;
> +}
> +
> +static int dvbt2_calc_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +			  u32 reg_value, int *snr)
> +{
> +	if ((!tnr_dmd) || (!snr))
> +		return -EINVAL;
> +
> +	if (reg_value == 0)
> +		return -EBUSY;
> +
> +	if (reg_value > 10876)
> +		reg_value = 10876;
> +
> +	*snr = intlog10(reg_value) - intlog10(12600 - reg_value);
> +	*snr = (*snr + 839) / 1678 + 32000;
> +
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +				 int *snr)
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SINGLE) {
> +		ret = dvbt2_read_snr_reg(tnr_dmd, &reg_value);
> +		if (ret)
> +			return ret;
> +
> +		ret = dvbt2_calc_snr(tnr_dmd, reg_value, snr);
> +		if (ret)
> +			return ret;
> +	} else {
> +		int snr_main = 0;
> +		int snr_sub = 0;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_snr_diver(tnr_dmd, snr, &snr_main,
> +						       &snr_sub);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_snr_diver(struct cxd2880_tnrdmd
> +				       *tnr_dmd, int *snr,
> +				       int *snr_main, int *snr_sub)
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = dvbt2_read_snr_reg(tnr_dmd, &reg_value);
> +	if (!ret) {
> +		ret = dvbt2_calc_snr(tnr_dmd, reg_value, snr_main);
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
> +	ret = dvbt2_read_snr_reg(tnr_dmd->diver_sub, &reg_value);
> +	if (!ret) {
> +		ret = dvbt2_calc_snr(tnr_dmd->diver_sub, reg_value, snr_sub);
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
> +	ret = dvbt2_calc_snr(tnr_dmd, reg_value_sum, snr);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_pre_ldpcber(struct cxd2880_tnrdmd
> +					 *tnr_dmd, u32 *ber)
> +{
> +	int ret = 0;
> +	u32 bit_error = 0;
> +	u32 period_exp = 0;
> +	u32 n_ldpc = 0;
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	{
> +		u8 data[5];
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x3c, data, sizeof(data));
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!(data[0] & 0x01)) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		bit_error =
> +		    ((data[1] & 0x0f) << 24) | (data[2] << 16) | (data[3] << 8)
> +		    | data[4];
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xa0, data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (((enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03)) ==
> +		    CXD2880_DVBT2_FEC_LDPC_16K)
> +			n_ldpc = 16200;
> +		else
> +			n_ldpc = 64800;
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x20);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x6f, data, 1);
> +		if (ret)
> +			return ret;
> +
> +		period_exp = data[0] & 0x0f;
> +	}
> +
> +	if (bit_error > ((1U << period_exp) * n_ldpc))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		if (period_exp >= 4) {
> +			div = (1U << (period_exp - 4)) * (n_ldpc / 200);
> +
> +			Q = (bit_error * 5) / div;
> +			R = (bit_error * 5) % div;
> +
> +			R *= 625;
> +			Q = Q * 625 + R / div;
> +			R = R % div;
> +		} else {
> +			div = (1U << period_exp) * (n_ldpc / 200);
> +
> +			Q = (bit_error * 10) / div;
> +			R = (bit_error * 10) % div;
> +
> +			R *= 5000;
> +			Q = Q * 5000 + R / div;
> +			R = R % div;
> +		}
> +
> +		if (div / 2 <= R)
> +			*ber = Q + 1;
> +		else
> +			*ber = Q;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_post_bchfer(struct cxd2880_tnrdmd
> +					 *tnr_dmd, u32 *fer)
> +{
> +	int ret = 0;
> +	u32 fec_error = 0;
> +	u32 period = 0;
> +
> +	if ((!tnr_dmd) || (!fer))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 data[2];
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x1b, data, 2);
> +		if (ret)
> +			return ret;
> +
> +		if (!(data[0] & 0x80))
> +			return -EBUSY;
> +
> +		fec_error = ((data[0] & 0x7f) << 8) | (data[1]);
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x20);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x72, data, 1);
> +		if (ret)
> +			return ret;
> +
> +		period = (1 << (data[0] & 0x0f));
> +	}
> +
> +	if ((period == 0) || (fec_error > period))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		div = period;
> +
> +		Q = (fec_error * 1000) / div;
> +		R = (fec_error * 1000) % div;
> +
> +		R *= 1000;
> +		Q = Q * 1000 + R / div;
> +		R = R % div;
> +
> +		if ((div != 1) && (div / 2 <= R))
> +			*fer = Q + 1;
> +		else
> +			*fer = Q;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_pre_bchber(struct cxd2880_tnrdmd
> +					*tnr_dmd, u32 *ber)
> +{
> +	int ret = 0;
> +	u32 bit_error = 0;
> +	u32 period_exp = 0;
> +	u32 n_bch = 0;
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[3];
> +		enum cxd2880_dvbt2_plp_fec plp_fec_type =
> +		    CXD2880_DVBT2_FEC_LDPC_16K;
> +		enum cxd2880_dvbt2_plp_code_rate plp_cr = CXD2880_DVBT2_R1_2;
> +
> +		static const u16 n_bch_bits_lookup[2][8] = {
> +			{7200, 9720, 10800, 11880, 12600, 13320, 5400, 6480},
> +			{32400, 38880, 43200, 48600, 51840, 54000, 21600, 25920}
> +		};
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x15, data, 3);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!(data[0] & 0x40)) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		bit_error = ((data[0] & 0x3f) << 16) | (data[1] << 8) | data[2];
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x9d, data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		plp_cr = (enum cxd2880_dvbt2_plp_code_rate)(data[0] & 0x07);
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xa0, data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		plp_fec_type = (enum cxd2880_dvbt2_plp_fec)(data[0] & 0x03);
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x20);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x72, data, 1);
> +		if (ret)
> +			return ret;
> +
> +		period_exp = data[0] & 0x0f;
> +
> +		if ((plp_fec_type > CXD2880_DVBT2_FEC_LDPC_64K) ||
> +		    (plp_cr > CXD2880_DVBT2_R2_5))
> +			return -EBUSY;
> +
> +		n_bch = n_bch_bits_lookup[plp_fec_type][plp_cr];
> +	}
> +
> +	if (bit_error > ((1U << period_exp) * n_bch))
> +		return -EBUSY;
> +
> +	{
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		if (period_exp >= 6) {
> +			div = (1U << (period_exp - 6)) * (n_bch / 40);
> +
> +			Q = (bit_error * 625) / div;
> +			R = (bit_error * 625) % div;
> +
> +			R *= 625;
> +			Q = Q * 625 + R / div;
> +			R = R % div;
> +		} else {
> +			div = (1U << period_exp) * (n_bch / 40);
> +
> +			Q = (bit_error * 1000) / div;
> +			R = (bit_error * 1000) % div;
> +
> +			R *= 25000;
> +			Q = Q * 25000 + R / div;
> +			R = R % div;
> +		}
> +
> +		if (div / 2 <= R)
> +			*ber = Q + 1;
> +		else
> +			*ber = Q;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_packet_error_number(struct
> +						 cxd2880_tnrdmd
> +						 *tnr_dmd,
> +						 u32 *pen)
> +{
> +	int ret = 0;
> +
> +	u8 data[3];
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x39, data, sizeof(data));
> +	if (ret)
> +		return ret;
> +
> +	if (!(data[0] & 0x01))
> +		return -EBUSY;
> +
> +	*pen = ((data[1] << 8) | data[2]);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sampling_offset(struct cxd2880_tnrdmd
> +					     *tnr_dmd, int *ppm)
> +{
> +	if ((!tnr_dmd) || (!ppm))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 ctl_val_reg[5];
> +		u8 nominal_rate_reg[5];
> +		u32 trl_ctl_val = 0;
> +		u32 trcg_nominal_rate = 0;
> +		int num;
> +		int den;
> +		int ret = 0;
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +		s8 diff_upper = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (sync_state != 6) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x34, ctl_val_reg,
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
> +					     0x10, nominal_rate_reg,
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
> +	return 0;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sampling_offset_sub(struct
> +						 cxd2880_tnrdmd
> +						 *tnr_dmd,
> +						 int *ppm)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!ppm))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode != CXD2880_TNRDMD_DIVERMODE_MAIN)
> +		return -EINVAL;
> +
> +	ret = cxd2880_tnrdmd_dvbt2_mon_sampling_offset(tnr_dmd->diver_sub, ppm);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_quality(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u8 *quality)
> +{
> +	int ret = 0;
> +	int snr = 0;
> +	int snr_rel = 0;
> +	u32 ber = 0;
> +	u32 ber_sqi = 0;
> +	enum cxd2880_dvbt2_plp_constell qam;
> +	enum cxd2880_dvbt2_plp_code_rate code_rate;
> +
> +	static const int snr_nordig_p1_db_1000[4][8] = {
> +		{3500, 4700, 5600, 6600, 7200, 7700, 1300, 2200},
> +		{8700, 10100, 11400, 12500, 13300, 13800, 6000, 7200},
> +		{13000, 14800, 16200, 17700, 18700, 19400, 9800, 11100},
> +		{17000, 19400, 20800, 22900, 24300, 25100, 13200, 14800},
> +	};
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_dvbt2_mon_pre_bchber(tnr_dmd, &ber);
> +	if (ret)
> +		return ret;
> +
> +	ret = cxd2880_tnrdmd_dvbt2_mon_snr(tnr_dmd, &snr);
> +	if (ret)
> +		return ret;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt2_mon_qam(tnr_dmd, CXD2880_DVBT2_PLP_DATA, &qam);
> +	if (ret)
> +		return ret;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt2_mon_code_rate(tnr_dmd, CXD2880_DVBT2_PLP_DATA,
> +					       &code_rate);
> +	if (ret)
> +		return ret;
> +
> +	if ((code_rate > CXD2880_DVBT2_R2_5) || (qam > CXD2880_DVBT2_QAM256))
> +		return -EPERM;
> +
> +	if (ber > 100000)
> +		ber_sqi = 0;
> +	else if (ber >= 100)
> +		ber_sqi = 6667;
> +	else
> +		ber_sqi = 16667;
> +
> +	snr_rel = snr - snr_nordig_p1_db_1000[qam][code_rate];
> +
> +	if (snr_rel < -3000) {
> +		*quality = 0;
> +	} else if (snr_rel <= 3000) {
> +		u32 temp_sqi =
> +		    (((snr_rel + 3000) * ber_sqi) + 500000) / 1000000;
> +		*quality = (temp_sqi > 100) ? 100 : (u8)temp_sqi;
> +	} else {
> +		*quality = 100;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ts_rate(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u32 *ts_rate_kbps)
> +{
> +	int ret = 0;
> +	u32 rd_smooth_dp = 0;
> +	u32 ep_ck_nume = 0;
> +	u32 ep_ck_deno = 0;
> +	u8 issy_on_data = 0;
> +
> +	if ((!tnr_dmd) || (!ts_rate_kbps))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 data[12];
> +		u8 sync_state = 0;
> +		u8 ts_lock = 0;
> +		u8 unlock_detected = 0;
> +
> +		ret = slvt_freeze_reg(tnr_dmd);
> +		if (ret)
> +			return ret;
> +
> +		ret =
> +		    cxd2880_tnrdmd_dvbt2_mon_sync_stat(tnr_dmd, &sync_state,
> +						       &ts_lock,
> +						       &unlock_detected);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (!ts_lock) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x23, data, 12);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		rd_smooth_dp = (data[0] & 0x1f) << 24;
> +		rd_smooth_dp |= data[1] << 16;
> +		rd_smooth_dp |= data[2] << 8;
> +		rd_smooth_dp |= data[3];
> +
> +		if (rd_smooth_dp < 214958) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ep_ck_nume = (data[4] & 0x3f) << 24;
> +		ep_ck_nume |= data[5] << 16;
> +		ep_ck_nume |= data[6] << 8;
> +		ep_ck_nume |= data[7];
> +
> +		ep_ck_deno = (data[8] & 0x3f) << 24;
> +		ep_ck_deno |= data[9] << 16;
> +		ep_ck_deno |= data[10] << 8;
> +		ep_ck_deno |= data[11];
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x41, data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		issy_on_data = data[0] & 0x01;
> +
> +		slvt_unfreeze_reg(tnr_dmd);
> +	}
> +
> +	if (issy_on_data) {
> +		if ((ep_ck_deno == 0) || (ep_ck_nume == 0) ||
> +		    (ep_ck_deno >= ep_ck_nume))
> +			return -EBUSY;
> +	}
> +
> +	{
> +		u32 ick_x100;
> +		u32 div = 0;
> +		u32 Q = 0;
> +		u32 R = 0;
> +
> +		switch (tnr_dmd->clk_mode) {
> +		case CXD2880_TNRDMD_CLOCKMODE_A:
> +			ick_x100 = 8228;
> +			break;
> +		case CXD2880_TNRDMD_CLOCKMODE_B:
> +			ick_x100 = 9330;
> +			break;
> +		case CXD2880_TNRDMD_CLOCKMODE_C:
> +			ick_x100 = 9600;
> +			break;
> +		default:
> +			return -EPERM;
> +		}
> +
> +		div = rd_smooth_dp;
> +
> +		Q = ick_x100 * 262144U / div;
> +		R = ick_x100 * 262144U % div;
> +
> +		R *= 5U;
> +		Q = Q * 5 + R / div;
> +		R = R % div;
> +
> +		R *= 2U;
> +		Q = Q * 2 + R / div;
> +		R = R % div;
> +
> +		if (div / 2 <= R)
> +			*ts_rate_kbps = Q + 1;
> +		else
> +			*ts_rate_kbps = Q;
> +	}
> +
> +	if (issy_on_data) {
> +		u32 diff = ep_ck_nume - ep_ck_deno;
> +
> +		while (diff > 0x7fff) {
> +			diff >>= 1;
> +			ep_ck_nume >>= 1;
> +		}
> +
> +		*ts_rate_kbps -=
> +		    (*ts_rate_kbps * diff + ep_ck_nume / 2) / ep_ck_nume;
> +	}
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
> +				 u32 *per)
> +{
> +	int ret = 0;
> +	u32 packet_error = 0;
> +	u32 period = 0;
> +
> +	if (!tnr_dmd || !per)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	{
> +		u8 rdata[3];
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x0b);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x18, rdata, 3);
> +		if (ret)
> +			return ret;
> +
> +		if ((rdata[0] & 0x01) == 0)
> +			return -EBUSY;
> +
> +		packet_error = (rdata[1] << 8) | rdata[2];
> +
> +		ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x00, 0x24);
> +		if (ret)
> +			return ret;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xdc, rdata, 1);
> +		if (ret)
> +			return ret;
> +
> +		period = 1U << (rdata[0] & 0x0f);
> +	}
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
> +int cxd2880_tnrdmd_dvbt2_mon_qam(struct cxd2880_tnrdmd *tnr_dmd,
> +				 enum cxd2880_dvbt2_plp_btype type,
> +				 enum cxd2880_dvbt2_plp_constell *qam)
> +{
> +	u8 data;
> +	u8 l1_post_ok = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!qam))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x86, &l1_post_ok, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	if (!(l1_post_ok & 0x01)) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return -EBUSY;
> +	}
> +
> +	if (type == CXD2880_DVBT2_PLP_COMMON) {
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xb6, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (data == 0) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xb1, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +	} else {
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x9e, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	*qam = (enum cxd2880_dvbt2_plp_constell)(data & 0x07);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_code_rate(struct cxd2880_tnrdmd
> +				       *tnr_dmd,
> +				       enum cxd2880_dvbt2_plp_btype
> +				       type,
> +				       enum
> +				       cxd2880_dvbt2_plp_code_rate
> +				       *code_rate)
> +{
> +	u8 data;
> +	u8 l1_post_ok = 0;
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!code_rate))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->diver_mode == CXD2880_TNRDMD_DIVERMODE_SUB)
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = slvt_freeze_reg(tnr_dmd);
> +	if (ret)
> +		return ret;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x86, &l1_post_ok, 1);
> +	if (ret) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return ret;
> +	}
> +
> +	if (!(l1_post_ok & 0x01)) {
> +		slvt_unfreeze_reg(tnr_dmd);
> +		return -EBUSY;
> +	}
> +
> +	if (type == CXD2880_DVBT2_PLP_COMMON) {
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xb6, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +
> +		if (data == 0) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return -EBUSY;
> +		}
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0xb0, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +	} else {
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x9d, &data, 1);
> +		if (ret) {
> +			slvt_unfreeze_reg(tnr_dmd);
> +			return ret;
> +		}
> +	}
> +
> +	slvt_unfreeze_reg(tnr_dmd);
> +
> +	*code_rate = (enum cxd2880_dvbt2_plp_code_rate)(data & 0x07);
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_profile(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_profile
> +				     *profile)
> +{
> +	int ret = 0;
> +
> +	if ((!tnr_dmd) || (!profile))
> +		return -EINVAL;
> +
> +	if (tnr_dmd->state != CXD2880_TNRDMD_STATE_ACTIVE)
> +		return -EPERM;
> +
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = tnr_dmd->io->write_reg(tnr_dmd->io,
> +				     CXD2880_IO_TGT_DMD,
> +				     0x00, 0x0b);
> +	if (ret)
> +		return ret;
> +
> +	{
> +		u8 data;
> +
> +		ret = tnr_dmd->io->read_regs(tnr_dmd->io,
> +					     CXD2880_IO_TGT_DMD,
> +					     0x22, &data, sizeof(data));
> +		if (ret)
> +			return ret;
> +
> +		if (data & 0x02) {
> +			if (data & 0x01)
> +				*profile = CXD2880_DVBT2_PROFILE_LITE;
> +			else
> +				*profile = CXD2880_DVBT2_PROFILE_BASE;
> +		} else {
> +			ret = -EBUSY;
> +			if (tnr_dmd->diver_mode ==
> +			    CXD2880_TNRDMD_DIVERMODE_MAIN)
> +				ret =
> +				    cxd2880_tnrdmd_dvbt2_mon_profile(
> +					tnr_dmd->diver_sub, profile);
> +
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int dvbt2_calc_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +			  int rf_lvl, u8 *ssi)
> +{
> +	enum cxd2880_dvbt2_plp_constell qam;
> +	enum cxd2880_dvbt2_plp_code_rate code_rate;
> +	int prel;
> +	int temp_ssi = 0;
> +	int ret = 0;
> +
> +	static const int ref_dbm_1000[4][8] = {
> +		{-96000, -95000, -94000, -93000, -92000, -92000, -98000,
> +		 -97000},
> +		{-91000, -89000, -88000, -87000, -86000, -86000, -93000,
> +		 -92000},
> +		{-86000, -85000, -83000, -82000, -81000, -80000, -89000,
> +		 -88000},
> +		{-82000, -80000, -78000, -76000, -75000, -74000, -86000,
> +		 -84000},
> +	};
> +
> +	if ((!tnr_dmd) || (!ssi))
> +		return -EINVAL;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt2_mon_qam(tnr_dmd, CXD2880_DVBT2_PLP_DATA, &qam);
> +	if (ret)
> +		return ret;
> +
> +	ret =
> +	    cxd2880_tnrdmd_dvbt2_mon_code_rate(tnr_dmd, CXD2880_DVBT2_PLP_DATA,
> +					       &code_rate);
> +	if (ret)
> +		return ret;
> +
> +	if ((code_rate > CXD2880_DVBT2_R2_5) || (qam > CXD2880_DVBT2_QAM256))
> +		return -EPERM;
> +
> +	prel = rf_lvl - ref_dbm_1000[qam][code_rate];
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
> +int cxd2880_tnrdmd_dvbt2_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +				 u8 *ssi)
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd, &rf_lvl);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt2_calc_ssi(tnr_dmd, rf_lvl, ssi);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ssi_sub(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u8 *ssi)
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
> +	if (tnr_dmd->sys != CXD2880_DTV_SYS_DVBT2)
> +		return -EPERM;
> +
> +	ret = cxd2880_tnrdmd_mon_rf_lvl(tnr_dmd->diver_sub, &rf_lvl);
> +	if (ret)
> +		return ret;
> +
> +	ret = dvbt2_calc_ssi(tnr_dmd, rf_lvl, ssi);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
> new file mode 100644
> index 000000000000..f7b2f618e80f
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
> @@ -0,0 +1,170 @@
> +/*
> + * cxd2880_tnrdmd_dvbt2_mon.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * DVB-T2 monitor interface
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
> +#ifndef CXD2880_TNRDMD_DVBT2_MON_H
> +#define CXD2880_TNRDMD_DVBT2_MON_H
> +
> +#include "cxd2880_tnrdmd.h"
> +#include "cxd2880_dvbt2.h"
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sync_stat(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *sync_stat,
> +				       u8 *ts_lock_stat,
> +				       u8 *unlock_detected);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sync_stat_sub(struct cxd2880_tnrdmd
> +					   *tnr_dmd,
> +					   u8 *sync_stat,
> +					   u8 *unlock_detected);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_carrier_offset(struct cxd2880_tnrdmd
> +					    *tnr_dmd, int *offset);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_carrier_offset_sub(struct
> +						cxd2880_tnrdmd
> +						*tnr_dmd,
> +						int *offset);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_pre(struct cxd2880_tnrdmd *tnr_dmd,
> +				    struct cxd2880_dvbt2_l1pre
> +				    *l1_pre);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_version(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_version
> +				     *ver);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ofdm(struct cxd2880_tnrdmd *tnr_dmd,
> +				  struct cxd2880_dvbt2_ofdm *ofdm);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_data_plps(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *plp_ids,
> +				       u8 *num_plps);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_active_plp(struct cxd2880_tnrdmd
> +					*tnr_dmd,
> +					enum
> +					cxd2880_dvbt2_plp_btype
> +					type,
> +					struct cxd2880_dvbt2_plp
> +					*plp_info);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_data_plp_error(struct cxd2880_tnrdmd
> +					    *tnr_dmd,
> +					    u8 *plp_error);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_change(struct cxd2880_tnrdmd
> +				       *tnr_dmd, u8 *l1_change);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_l1_post(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     struct cxd2880_dvbt2_l1post
> +				     *l1_post);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_bbheader(struct cxd2880_tnrdmd
> +				      *tnr_dmd,
> +				      enum cxd2880_dvbt2_plp_btype
> +				      type,
> +				      struct cxd2880_dvbt2_bbheader
> +				      *bbheader);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_in_bandb_ts_rate(struct cxd2880_tnrdmd
> +					      *tnr_dmd,
> +					      enum
> +					      cxd2880_dvbt2_plp_btype
> +					      type,
> +					      u32 *ts_rate_bps);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_spectrum_sense(struct cxd2880_tnrdmd
> +					    *tnr_dmd,
> +					    enum
> +					    cxd2880_tnrdmd_spectrum_sense
> +					    *sense);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_snr(struct cxd2880_tnrdmd *tnr_dmd,
> +				 int *snr);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_snr_diver(struct cxd2880_tnrdmd
> +				       *tnr_dmd, int *snr,
> +				       int *snr_main,
> +				       int *snr_sub);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_pre_ldpcber(struct cxd2880_tnrdmd
> +					 *tnr_dmd, u32 *ber);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_post_bchfer(struct cxd2880_tnrdmd
> +					 *tnr_dmd, u32 *fer);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_pre_bchber(struct cxd2880_tnrdmd
> +					*tnr_dmd, u32 *ber);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_packet_error_number(struct
> +						 cxd2880_tnrdmd
> +						 *tnr_dmd,
> +						 u32 *pen);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sampling_offset(struct cxd2880_tnrdmd
> +					     *tnr_dmd, int *ppm);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_sampling_offset_sub(struct
> +						 cxd2880_tnrdmd
> +						 *tnr_dmd,
> +						 int *ppm);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ts_rate(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u32 *ts_rate_kbps);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_quality(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u8 *quality);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_per(struct cxd2880_tnrdmd *tnr_dmd,
> +				 u32 *per);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_qam(struct cxd2880_tnrdmd *tnr_dmd,
> +				 enum cxd2880_dvbt2_plp_btype type,
> +				 enum cxd2880_dvbt2_plp_constell
> +				 *qam);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_code_rate(struct cxd2880_tnrdmd
> +				       *tnr_dmd,
> +				       enum cxd2880_dvbt2_plp_btype
> +				       type,
> +				       enum
> +				       cxd2880_dvbt2_plp_code_rate
> +				       *code_rate);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_profile(struct cxd2880_tnrdmd
> +				     *tnr_dmd,
> +				     enum cxd2880_dvbt2_profile
> +				     *profile);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ssi(struct cxd2880_tnrdmd *tnr_dmd,
> +				 u8 *ssi);
> +
> +int cxd2880_tnrdmd_dvbt2_mon_ssi_sub(struct cxd2880_tnrdmd
> +				     *tnr_dmd, u8 *ssi);
> +
> +#endif



Thanks,
Mauro
