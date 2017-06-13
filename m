Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48338
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752456AbdFMMTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 08:19:09 -0400
Date: Tue, 13 Jun 2017 09:18:55 -0300
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
Subject: Re: [PATCH v2 04/15] [media] cxd2880: Add math functions for the
 driver
Message-ID: <20170613091855.046d60a3@vento.lan>
In-Reply-To: <20170414022237.17269-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
        <20170414022237.17269-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Apr 2017 11:22:37 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> Provide some math support functions (fixed-point log functions)
> for the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

No need. The Kernel already provide log functions. You should use the
existing ones, instead of reinventing the wheel. The log2 functions
are at:
	include/linux/log2.h

We also have both log2 and log10 functions at:
	drivers/media/dvb-core/dvb_math.h

That should likely what you want.


> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
>  drivers/media/dvb-frontends/cxd2880/cxd2880_math.c | 89 ++++++++++++++++++++++
>  drivers/media/dvb-frontends/cxd2880/cxd2880_math.h | 40 ++++++++++
>  2 files changed, 129 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
>  create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
> 
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
> new file mode 100644
> index 000000000000..434c827898ff
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.c
> @@ -0,0 +1,89 @@
> +/*
> + * cxd2880_math.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * mathmatics functions
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
> +#include "cxd2880_math.h"
> +
> +#define MAX_BIT_PRECISION	  5
> +#define FRAC_BITMASK	    0x1F
> +#define LOG2_10_100X	     332
> +#define LOG2_E_100X	      144
> +
> +static const u8 log2_look_up[] = {
> +	0, 4,
> +	9, 13,
> +	17, 21,
> +	25, 29,
> +	32, 36,
> +	39, 43,
> +	46, 49,
> +	52, 55,
> +	58, 61,
> +	64, 67,
> +	70, 73,
> +	75, 78,
> +	81, 83,
> +	86, 88,
> +	91, 93,
> +	95, 98
> +};
> +
> +u32 cxd2880_math_log2(u32 x)
> +{
> +	u8 count = 0;
> +	u8 index = 0;
> +	u32 xval = x;
> +
> +	for (x >>= 1; x > 0; x >>= 1)
> +		count++;
> +
> +	x = count * 100;
> +
> +	if (count > 0) {
> +		if (count <= MAX_BIT_PRECISION) {
> +			index =
> +			    (u8)(xval << (MAX_BIT_PRECISION - count)) &
> +			    FRAC_BITMASK;
> +			x += log2_look_up[index];
> +		} else {
> +			index =
> +			    (u8)(xval >> (count - MAX_BIT_PRECISION)) &
> +			    FRAC_BITMASK;
> +			x += log2_look_up[index];
> +		}
> +	}
> +
> +	return x;
> +}
> +
> +u32 cxd2880_math_log10(u32 x)
> +{
> +	return ((100 * cxd2880_math_log2(x) + LOG2_10_100X / 2) / LOG2_10_100X);
> +}
> +
> +u32 cxd2880_math_log(u32 x)
> +{
> +	return ((100 * cxd2880_math_log2(x) + LOG2_E_100X / 2) / LOG2_E_100X);
> +}
> diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
> new file mode 100644
> index 000000000000..94211835a4ad
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_math.h
> @@ -0,0 +1,40 @@
> +/*
> + * cxd2880_math.h
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * mathmatics definitions
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
> +#ifndef CXD2880_MATH_H_
> +#define CXD2880_MATH_H_
> +
> +#include "cxd2880_common.h"
> +
> +u32 cxd2880_math_log2(u32 x);
> +u32 cxd2880_math_log10(u32 x);
> +u32 cxd2880_math_log(u32 x);
> +
> +#ifndef min
> +#define min(a, b)	    (((a) < (b)) ? (a) : (b))
> +#endif

We also have min() macro at the Kernel.

> +
> +#endif



Thanks,
Mauro
