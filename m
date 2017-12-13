Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47072 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752175AbdLMRyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 12:54:36 -0500
Date: Wed, 13 Dec 2017 15:54:22 -0200
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
Subject: Re: [PATCH v4 02/12] [media] cxd2880-spi: Add support for CXD2880
 SPI interface
Message-ID: <20171213155422.03621b5e@vento.lan>
In-Reply-To: <20171013055928.21132-1-Yasunari.Takiguchi@sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171013055928.21132-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 14:59:28 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> This is the SPI adapter part of the driver for the
> Sony CXD2880 DVB-T2/T tuner + demodulator.
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
>    drivers/media/spi/cxd2880-spi.c
>       -removed Camel case
>       -removed unnecessary initialization at variable declaration
>       -removed unnecessary brace {}
> 
> Changes in V3
>    drivers/media/spi/cxd2880-spi.c
>       -adjusted of indent spaces
>       -removed unnecessary cast
>       -changed debugging code
>       -changed timeout method
>       -modified coding style of if()
>       -changed hexadecimal code to lower case. 
> 
> Changes in V2
>    drivers/media/spi/cxd2880-spi.c
>       -Modified PID filter setting.
> 
>  drivers/media/spi/cxd2880-spi.c | 695 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 695 insertions(+)
>  create mode 100644 drivers/media/spi/cxd2880-spi.c
> 
> diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
> new file mode 100644
> index 000000000000..387cb32f90b8
> --- /dev/null
> +++ b/drivers/media/spi/cxd2880-spi.c
> @@ -0,0 +1,695 @@
> +/*
> + * cxd2880-spi.c
> + * Sony CXD2880 DVB-T2/T tuner + demodulator driver
> + * SPI adapter
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

A minor issue (that it is not a show-stopper): we're now using SPDX
instead of repeating the copyright notes everywhere. Please look at
those articles for more details:

	https://blogs.s-osg.org/linux-kernel-license-practices-revisited-spdx/
	https://lwn.net/Articles/739183/

> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__

It would be better to use dev_foo() debug macros instead of
pr_foo() ones.

> +
> +#include <linux/spi/spi.h>
> +#include <linux/jiffies.h>
> +
> +#include "dvb_demux.h"
> +#include "dmxdev.h"
> +#include "dvb_frontend.h"
> +#include "cxd2880.h"
> +
> +#define CXD2880_MAX_FILTER_SIZE 32
> +#define BURST_WRITE_MAX 128
> +#define MAX_TRANS_PACKET 300
> +
> +struct cxd2880_ts_buf_info {
> +	u8 read_ready;
> +	u8 almost_full;
> +	u8 almost_empty;
> +	u8 overflow;
> +	u8 underflow;

Hmm... those seem to be booleans. The best is to declare them as:

	u8 read_ready:1;
	u8 almost_full:1;
	u8 almost_empty:1;
	u8 overflow:1;
	u8 underflow:1;

or to use bool, in order to make it clearer.

> +	u16 packet_num;
> +};
> +
> +struct cxd2880_pid_config {
> +	u8 is_enable;
> +	u16 pid;
> +};
> +
> +struct cxd2880_pid_filter_config {
> +	u8 is_negative;
> +	struct cxd2880_pid_config pid_config[CXD2880_MAX_FILTER_SIZE];
> +};
> +
> +struct cxd2880_dvb_spi {
> +	struct dvb_frontend dvb_fe;
> +	struct dvb_adapter adapter;
> +	struct dvb_demux demux;
> +	struct dmxdev dmxdev;
> +	struct dmx_frontend dmx_fe;
> +	struct task_struct *cxd2880_ts_read_thread;
> +	struct spi_device *spi;
> +	struct mutex spi_mutex; /* For SPI access exclusive control */
> +	int feed_count;
> +	int all_pid_feed_count;
> +	u8 *ts_buf;
> +	struct cxd2880_pid_filter_config filter_config;
> +};
> +
> +DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> +
> +static int cxd2880_write_spi(struct spi_device *spi, u8 *data, u32 size)
> +{
> +	struct spi_message msg;
> +	struct spi_transfer tx;
> +	int ret;
> +
> +	if ((!spi) || (!data)) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	memset(&tx, 0, sizeof(tx));
> +	tx.tx_buf = data;
> +	tx.len = size;
> +
> +	spi_message_init(&msg);
> +	spi_message_add_tail(&tx, &msg);
> +	ret = spi_sync(spi, &msg);
> +
> +	return ret;
> +}
> +
> +static int cxd2880_write_reg(struct spi_device *spi,
> +			     u8 sub_address, const u8 *data, u32 size)
> +{
> +	u8 send_data[BURST_WRITE_MAX + 4];
> +	const u8 *write_data_top = NULL;
> +	int ret = 0;
> +
> +	if ((!spi) || (!data)) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +	if (size > BURST_WRITE_MAX) {
> +		pr_err("data size > WRITE_MAX\n");
> +		return -EINVAL;
> +	}
> +
> +	if (sub_address + size > 0x100) {
> +		pr_err("out of range\n");
> +		return -EINVAL;
> +	}
> +
> +	send_data[0] = 0x0e;
> +	write_data_top = data;
> +
> +	while (size > 0) {
> +		send_data[1] = sub_address;
> +		if (size > 255)
> +			send_data[2] = 255;
> +		else
> +			send_data[2] = (u8)size;
> +
> +		memcpy(&send_data[3], write_data_top, send_data[2]);
> +
> +		ret = cxd2880_write_spi(spi, send_data, send_data[2] + 3);
> +		if (ret) {
> +			pr_err("write spi failed %d\n", ret);
> +			break;
> +		}
> +		sub_address += send_data[2];
> +		write_data_top += send_data[2];
> +		size -= send_data[2];
> +	}
> +
> +	return ret;
> +}
> +
> +static int cxd2880_spi_read_ts(struct spi_device *spi,
> +			       u8 *read_data,
> +			       u32 packet_num)
> +{
> +	int ret;
> +	u8 data[3];
> +	struct spi_message message;
> +	struct spi_transfer transfer[2];
> +
> +	if ((!spi) || (!read_data) || (!packet_num)) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +	if (packet_num > 0xffff) {
> +		pr_err("packet num > 0xffff\n");
> +		return -EINVAL;
> +	}
> +
> +	data[0] = 0x10;
> +	data[1] = (packet_num >> 8) & 0xff;
> +	data[2] = packet_num & 0xff;

The & 0xff aren't needed, as the size of each data[] element is 8 bits.

> +
> +	spi_message_init(&message);
> +	memset(transfer, 0, sizeof(transfer));
> +
> +	transfer[0].len = 3;
> +	transfer[0].tx_buf = data;
> +	spi_message_add_tail(&transfer[0], &message);
> +	transfer[1].len = packet_num * 188;
> +	transfer[1].rx_buf = read_data;
> +	spi_message_add_tail(&transfer[1], &message);
> +
> +	ret = spi_sync(spi, &message);
> +	if (ret)
> +		pr_err("spi_write_then_read failed\n");
> +
> +	return ret;
> +}
> +
> +static int cxd2880_spi_read_ts_buffer_info(struct spi_device *spi,
> +					   struct cxd2880_ts_buf_info *info)
> +{
> +	u8 send_data = 0x20;
> +	u8 recv_data[2];
> +	int ret;
> +
> +	if ((!spi) || (!info)) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = spi_write_then_read(spi, &send_data, 1,
> +				  recv_data, sizeof(recv_data));
> +	if (ret)
> +		pr_err("spi_write_then_read failed\n");
> +
> +	info->read_ready = (recv_data[0] & 0x80) ? 1 : 0;
> +	info->almost_full = (recv_data[0] & 0x40) ? 1 : 0;
> +	info->almost_empty = (recv_data[0] & 0x20) ? 1 : 0;
> +	info->overflow = (recv_data[0] & 0x10) ? 1 : 0;
> +	info->underflow = (recv_data[0] & 0x08) ? 1 : 0;

See my comment above. if you use bool, instead of 1/0, you would need
to use true/false here.

> +	info->packet_num = ((recv_data[0] & 0x07) << 8) | recv_data[1];
> +
> +	return ret;
> +}
> +
> +static int cxd2880_spi_clear_ts_buffer(struct spi_device *spi)
> +{
> +	u8 data = 0x03;
> +	int ret;
> +
> +	ret = cxd2880_write_spi(spi, &data, 1);
> +
> +	if (ret)
> +		pr_err("write spi failed\n");
> +
> +	return ret;
> +}
> +
> +static int cxd2880_set_pid_filter(struct spi_device *spi,
> +				  struct cxd2880_pid_filter_config *cfg)
> +{
> +	u8 data[65];
> +	int i;
> +	u16 pid = 0;
> +	int ret;
> +
> +	if (!spi) {
> +		pr_err("ivnalid arg\n");

typo.

> +		return -EINVAL;
> +	}
> +
> +	data[0] = 0x00;
> +	ret = cxd2880_write_reg(spi, 0x00, &data[0], 1);
> +	if (ret)
> +		return ret;
> +	if (!cfg) {
> +		data[0] = 0x02;
> +		ret = cxd2880_write_reg(spi, 0x50, &data[0], 1);
> +		if (ret)
> +			return ret;
> +	} else {
> +		data[0] = cfg->is_negative ? 0x01 : 0x00;
> +
> +		for (i = 0; i < CXD2880_MAX_FILTER_SIZE; i++) {
> +			pid = cfg->pid_config[i].pid;
> +			if (cfg->pid_config[i].is_enable) {
> +				data[1 + (i * 2)] = (pid >> 8) | 0x20;
> +				data[2 + (i * 2)] = pid & 0xff;
> +			} else {
> +				data[1 + (i * 2)] = 0x00;
> +				data[2 + (i * 2)] = 0x00;
> +			}
> +		}
> +		ret = cxd2880_write_reg(spi, 0x50, data, 65);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxd2880_update_pid_filter(struct cxd2880_dvb_spi *dvb_spi,
> +				     struct cxd2880_pid_filter_config *cfg,
> +				     bool is_all_pid_filter)
> +{
> +	int ret;
> +
> +	if ((!dvb_spi) || (!cfg)) {
> +		pr_err("invalid arg.\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&dvb_spi->spi_mutex);
> +	if (is_all_pid_filter) {
> +		struct cxd2880_pid_filter_config tmpcfg;
> +
> +		memset(&tmpcfg, 0, sizeof(tmpcfg));
> +		tmpcfg.is_negative = 1;
> +		tmpcfg.pid_config[0].is_enable = 1;
> +		tmpcfg.pid_config[0].pid = 0x1fff;
> +
> +		ret = cxd2880_set_pid_filter(dvb_spi->spi, &tmpcfg);
> +	} else {
> +		ret = cxd2880_set_pid_filter(dvb_spi->spi, cfg);
> +	}
> +	mutex_unlock(&dvb_spi->spi_mutex);
> +
> +	if (ret)
> +		pr_err("set_pid_filter failed\n");
> +
> +	return ret;
> +}
> +
> +static int cxd2880_ts_read(void *arg)
> +{
> +	struct cxd2880_dvb_spi *dvb_spi = NULL;
> +	struct cxd2880_ts_buf_info info;
> +	unsigned int elapsed = 0;
> +	unsigned long start_time = 0;
> +	u32 i;
> +	int ret;
> +
> +	dvb_spi = arg;
> +	if (!dvb_spi) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = cxd2880_spi_clear_ts_buffer(dvb_spi->spi);
> +	if (ret) {
> +		pr_err("set_clear_ts_buffer failed\n");
> +		return ret;
> +	}
> +	start_time = jiffies;
> +	while (!kthread_should_stop()) {
> +		elapsed = jiffies_to_msecs(jiffies - start_time);
> +		ret = cxd2880_spi_read_ts_buffer_info(dvb_spi->spi,
> +						      &info);
> +		if (ret) {
> +			pr_err("spi_read_ts_buffer_info error\n");
> +			return ret;
> +		}
> +
> +		if (info.packet_num > MAX_TRANS_PACKET) {
> +			for (i = 0; i < info.packet_num / MAX_TRANS_PACKET;
> +				i++) {

Please fix intend or place the for on a single line.

> +				cxd2880_spi_read_ts(dvb_spi->spi,
> +						    dvb_spi->ts_buf,
> +						    MAX_TRANS_PACKET);
> +				dvb_dmx_swfilter(&dvb_spi->demux,
> +						 dvb_spi->ts_buf,
> +						 MAX_TRANS_PACKET * 188);
> +			}
> +			start_time = jiffies;
> +		} else if ((info.packet_num > 0) && (elapsed >= 500)) {
> +			cxd2880_spi_read_ts(dvb_spi->spi,
> +					    dvb_spi->ts_buf,
> +					    info.packet_num);
> +			dvb_dmx_swfilter(&dvb_spi->demux,
> +					 dvb_spi->ts_buf,
> +					 info.packet_num * 188);
> +			start_time = jiffies;
> +		} else {
> +			usleep_range(10000, 11000);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxd2880_start_feed(struct dvb_demux_feed *feed)
> +{
> +	int ret = 0;
> +	int i = 0;
> +	struct dvb_demux *demux = NULL;
> +	struct cxd2880_dvb_spi *dvb_spi = NULL;
> +
> +	if (!feed) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	demux = feed->demux;
> +	if (!demux) {
> +		pr_err("feed->demux is NULL\n");
> +		return -EINVAL;
> +	}
> +	dvb_spi = demux->priv;
> +
> +	if (dvb_spi->feed_count == CXD2880_MAX_FILTER_SIZE) {
> +		pr_err("Exceeded maximum PID count (32).");
> +		pr_err("Selected PID cannot be enabled.\n");
> +		return -EBUSY;
> +	}
> +
> +	if (feed->pid == 0x2000) {
> +		if (dvb_spi->all_pid_feed_count == 0) {
> +			ret = cxd2880_update_pid_filter(dvb_spi,
> +							&dvb_spi->filter_config,
> +							true);
> +			if (ret) {
> +				pr_err("update pid filter failed\n");
> +				return ret;
> +			}
> +		}
> +		dvb_spi->all_pid_feed_count++;
> +
> +		pr_debug("all PID feed (count = %d)\n",
> +			 dvb_spi->all_pid_feed_count);
> +	} else {
> +		struct cxd2880_pid_filter_config cfgtmp;
> +
> +		cfgtmp = dvb_spi->filter_config;
> +
> +		for (i = 0; i < CXD2880_MAX_FILTER_SIZE; i++) {
> +			if (cfgtmp.pid_config[i].is_enable == 0) {
> +				cfgtmp.pid_config[i].is_enable = 1;
> +				cfgtmp.pid_config[i].pid = feed->pid;
> +				pr_debug("store PID %d to #%d\n",
> +					 feed->pid, i);
> +				break;
> +			}
> +		}
> +		if (i == CXD2880_MAX_FILTER_SIZE) {
> +			pr_err("PID filter is full. Assumed bug.\n");
> +			return -EBUSY;
> +		}
> +		if (!dvb_spi->all_pid_feed_count)
> +			ret = cxd2880_update_pid_filter(dvb_spi,
> +							&cfgtmp,
> +							false);
> +		if (ret)
> +			return ret;
> +
> +		dvb_spi->filter_config = cfgtmp;
> +	}
> +
> +	if (dvb_spi->feed_count == 0) {
> +		dvb_spi->ts_buf =
> +			kmalloc(MAX_TRANS_PACKET * 188,
> +				GFP_KERNEL | GFP_DMA);
> +		if (!dvb_spi->ts_buf) {
> +			pr_err("ts buffer allocate failed\n");
> +			memset(&dvb_spi->filter_config, 0,
> +			       sizeof(dvb_spi->filter_config));
> +			dvb_spi->all_pid_feed_count = 0;
> +			return -ENOMEM;
> +		}
> +		dvb_spi->cxd2880_ts_read_thread = kthread_run(cxd2880_ts_read,
> +							      dvb_spi,
> +							      "cxd2880_ts_read");
> +		if (IS_ERR(dvb_spi->cxd2880_ts_read_thread)) {
> +			pr_err("kthread_run failed/\n");
> +			kfree(dvb_spi->ts_buf);
> +			dvb_spi->ts_buf = NULL;
> +			memset(&dvb_spi->filter_config, 0,
> +			       sizeof(dvb_spi->filter_config));
> +			dvb_spi->all_pid_feed_count = 0;
> +			return PTR_ERR(dvb_spi->cxd2880_ts_read_thread);
> +		}
> +	}
> +
> +	dvb_spi->feed_count++;
> +
> +	pr_debug("start feed (count %d)\n", dvb_spi->feed_count);
> +	return 0;
> +}
> +
> +static int cxd2880_stop_feed(struct dvb_demux_feed *feed)
> +{
> +	int i = 0;
> +	int ret;
> +	struct dvb_demux *demux = NULL;
> +	struct cxd2880_dvb_spi *dvb_spi = NULL;
> +
> +	if (!feed) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	demux = feed->demux;
> +	if (!demux) {
> +		pr_err("feed->demux is NULL\n");
> +		return -EINVAL;
> +	}
> +	dvb_spi = demux->priv;
> +
> +	if (!dvb_spi->feed_count) {
> +		pr_err("no feed is started\n");
> +		return -EINVAL;
> +	}
> +
> +	if (feed->pid == 0x2000) {
> +		/*
> +		 * Special PID case.
> +		 * Number of 0x2000 feed request was stored
> +		 * in dvb_spi->all_pid_feed_count.
> +		 */
> +		if (dvb_spi->all_pid_feed_count <= 0) {
> +			pr_err("PID %d not found.\n", feed->pid);
> +			return -EINVAL;
> +		}
> +		dvb_spi->all_pid_feed_count--;
> +	} else {
> +		struct cxd2880_pid_filter_config cfgtmp;
> +
> +		cfgtmp = dvb_spi->filter_config;
> +
> +		for (i = 0; i < CXD2880_MAX_FILTER_SIZE; i++) {
> +			if (feed->pid == cfgtmp.pid_config[i].pid &&
> +			    cfgtmp.pid_config[i].is_enable != 0) {
> +				cfgtmp.pid_config[i].is_enable = 0;
> +				cfgtmp.pid_config[i].pid = 0;
> +				pr_debug("removed PID %d from #%d\n",
> +					 feed->pid, i);
> +				break;
> +			}
> +		}
> +		dvb_spi->filter_config = cfgtmp;
> +
> +		if (i == CXD2880_MAX_FILTER_SIZE) {
> +			pr_err("PID %d not found\n", feed->pid);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ret = cxd2880_update_pid_filter(dvb_spi,
> +					&dvb_spi->filter_config,
> +					dvb_spi->all_pid_feed_count > 0);
> +	dvb_spi->feed_count--;
> +
> +	if (dvb_spi->feed_count == 0) {
> +		int ret_stop = 0;
> +
> +		ret_stop = kthread_stop(dvb_spi->cxd2880_ts_read_thread);
> +		if (ret_stop) {
> +			pr_err("'kthread_stop failed. (%d)\n", ret_stop);
> +			ret = ret_stop;
> +		}
> +		kfree(dvb_spi->ts_buf);
> +		dvb_spi->ts_buf = NULL;
> +	}
> +
> +	pr_debug("stop feed ok.(count %d)\n", dvb_spi->feed_count);
> +
> +	return ret;
> +}

I have the feeling that I've seen the code above before at the dvb core.
Any reason why don't use the already-existing code at dvb_demux.c & friends?

> +
> +static const struct of_device_id cxd2880_spi_of_match[] = {
> +	{ .compatible = "sony,cxd2880" },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, cxd2880_spi_of_match);
> +
> +static int
> +cxd2880_spi_probe(struct spi_device *spi)
> +{
> +	int ret;
> +	struct cxd2880_dvb_spi *dvb_spi = NULL;
> +	struct cxd2880_config config;
> +
> +	if (!spi) {
> +		pr_err("invalid arg.\n");
> +		return -EINVAL;
> +	}
> +
> +	dvb_spi = kzalloc(sizeof(struct cxd2880_dvb_spi), GFP_KERNEL);
> +	if (!dvb_spi)
> +		return -ENOMEM;
> +
> +	dvb_spi->spi = spi;
> +	mutex_init(&dvb_spi->spi_mutex);
> +	dev_set_drvdata(&spi->dev, dvb_spi);
> +	config.spi = spi;
> +	config.spi_mutex = &dvb_spi->spi_mutex;
> +
> +	ret = dvb_register_adapter(&dvb_spi->adapter,
> +				   "CXD2880",
> +				   THIS_MODULE,
> +				   &spi->dev,
> +				   adapter_nr);
> +	if (ret < 0) {
> +		pr_err("dvb_register_adapter() failed\n");
> +		goto fail_adapter;
> +	}
> +
> +	if (!dvb_attach(cxd2880_attach, &dvb_spi->dvb_fe, &config)) {
> +		pr_err("cxd2880_attach failed\n");
> +		goto fail_attach;
> +	}
> +
> +	ret = dvb_register_frontend(&dvb_spi->adapter,
> +				    &dvb_spi->dvb_fe);
> +	if (ret < 0) {
> +		pr_err("dvb_register_frontend() failed\n");
> +		goto fail_frontend;
> +	}
> +
> +	dvb_spi->demux.dmx.capabilities = DMX_TS_FILTERING;
> +	dvb_spi->demux.priv = dvb_spi;
> +	dvb_spi->demux.filternum = CXD2880_MAX_FILTER_SIZE;
> +	dvb_spi->demux.feednum = CXD2880_MAX_FILTER_SIZE;
> +	dvb_spi->demux.start_feed = cxd2880_start_feed;
> +	dvb_spi->demux.stop_feed = cxd2880_stop_feed;
> +
> +	ret = dvb_dmx_init(&dvb_spi->demux);
> +	if (ret < 0) {
> +		pr_err("dvb_dmx_init() failed\n");
> +		goto fail_dmx;
> +	}
> +
> +	dvb_spi->dmxdev.filternum = CXD2880_MAX_FILTER_SIZE;
> +	dvb_spi->dmxdev.demux = &dvb_spi->demux.dmx;
> +	dvb_spi->dmxdev.capabilities = 0;
> +	ret = dvb_dmxdev_init(&dvb_spi->dmxdev,
> +			      &dvb_spi->adapter);
> +	if (ret < 0) {
> +		pr_err("dvb_dmxdev_init() failed\n");
> +		goto fail_dmxdev;
> +	}
> +
> +	dvb_spi->dmx_fe.source = DMX_FRONTEND_0;
> +	ret = dvb_spi->demux.dmx.add_frontend(&dvb_spi->demux.dmx,
> +					      &dvb_spi->dmx_fe);
> +	if (ret < 0) {
> +		pr_err("add_frontend() failed\n");
> +		goto fail_dmx_fe;
> +	}
> +
> +	ret = dvb_spi->demux.dmx.connect_frontend(&dvb_spi->demux.dmx,
> +						  &dvb_spi->dmx_fe);
> +	if (ret < 0) {
> +		pr_err("dvb_register_frontend() failed\n");
> +		goto fail_fe_conn;
> +	}
> +
> +	pr_info("Sony CXD2880 has successfully attached.\n");
> +
> +	return 0;
> +
> +fail_fe_conn:
> +	dvb_spi->demux.dmx.remove_frontend(&dvb_spi->demux.dmx,
> +					   &dvb_spi->dmx_fe);
> +fail_dmx_fe:
> +	dvb_dmxdev_release(&dvb_spi->dmxdev);
> +fail_dmxdev:
> +	dvb_dmx_release(&dvb_spi->demux);
> +fail_dmx:
> +	dvb_unregister_frontend(&dvb_spi->dvb_fe);
> +fail_frontend:
> +	dvb_frontend_detach(&dvb_spi->dvb_fe);
> +fail_attach:
> +	dvb_unregister_adapter(&dvb_spi->adapter);
> +fail_adapter:
> +	kfree(dvb_spi);
> +	return ret;
> +}
> +
> +static int
> +cxd2880_spi_remove(struct spi_device *spi)
> +{
> +	struct cxd2880_dvb_spi *dvb_spi;
> +
> +	if (!spi) {
> +		pr_err("invalid arg\n");
> +		return -EINVAL;
> +	}
> +
> +	dvb_spi = dev_get_drvdata(&spi->dev);
> +
> +	if (!dvb_spi) {
> +		pr_err("failed\n");
> +		return -EINVAL;
> +	}
> +	dvb_spi->demux.dmx.remove_frontend(&dvb_spi->demux.dmx,
> +					   &dvb_spi->dmx_fe);
> +	dvb_dmxdev_release(&dvb_spi->dmxdev);
> +	dvb_dmx_release(&dvb_spi->demux);
> +	dvb_unregister_frontend(&dvb_spi->dvb_fe);
> +	dvb_frontend_detach(&dvb_spi->dvb_fe);
> +	dvb_unregister_adapter(&dvb_spi->adapter);
> +
> +	kfree(dvb_spi);
> +	pr_info("cxd2880_spi remove ok.\n");
> +
> +	return 0;
> +}
> +
> +static const struct spi_device_id cxd2880_spi_id[] = {
> +	{ "cxd2880", 0 },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(spi, cxd2880_spi_id);
> +
> +static struct spi_driver cxd2880_spi_driver = {
> +	.driver	= {
> +		.name	= "cxd2880",
> +		.of_match_table = cxd2880_spi_of_match,
> +	},
> +	.id_table = cxd2880_spi_id,
> +	.probe    = cxd2880_spi_probe,
> +	.remove   = cxd2880_spi_remove,
> +};
> +module_spi_driver(cxd2880_spi_driver);
> +
> +MODULE_DESCRIPTION(
> +"Sony CXD2880 DVB-T2/T tuner + demodulator drvier SPI adapter");

Just put it on a single line.

There's a typo there too: drvier

> +MODULE_AUTHOR("Sony Semiconductor Solutions Corporation");
> +MODULE_LICENSE("GPL v2");



Thanks,
Mauro
