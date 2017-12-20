Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0128.outbound.protection.outlook.com ([104.47.42.128]:47552
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753762AbdLTAyx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 19:54:53 -0500
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: RE: [PATCH v4 02/12] [media] cxd2880-spi: Add support for CXD2880
 SPI interface
Date: Wed, 20 Dec 2017 00:54:48 +0000
Message-ID: <02699364973B424C83A42A84B04FDA85440B8B@JPYOKXMS113.jp.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
        <20171013055928.21132-1-Yasunari.Takiguchi@sony.com>
 <20171213155422.03621b5e@vento.lan>
In-Reply-To: <20171213155422.03621b5e@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mauro.

> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
> 
> It would be better to use dev_foo() debug macros instead of
> pr_foo() ones.

I got comment for this previous version patch as below
--------------------------------------------------------------------------------------
The best would be to se dev_err() & friends for printing messages, 
as they print the device's name as filled at struct device.
If you don't use, please add a define that will print the name at the logs, like:

  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

either at the begining of the driver or at some header file.

Btw, I'm noticing that you're also using dev_err() on other places of the code. 
Please standardize. OK, on a few places, you may still need to use pr_err(), 
if you need to print a message before initializing struct device, but I suspect that you can init
--------------------------------------------------------------------------------------

You pointed out here before. Because dev_foo () and pr_foo () were mixed.
We standardize with pr_foo() because the logs is outputted before getting the device structure.
Is it better to use dev_foo() where we can use it?


> > +static int cxd2880_stop_feed(struct dvb_demux_feed *feed) {
> > +	int i = 0;
> > +	int ret;
> > +	struct dvb_demux *demux = NULL;
> > +	struct cxd2880_dvb_spi *dvb_spi = NULL;
> > +
> > +	if (!feed) {
> > +		pr_err("invalid arg\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	demux = feed->demux;
> > +	if (!demux) {
> > +		pr_err("feed->demux is NULL\n");
> > +		return -EINVAL;
> > +	}
> > +	dvb_spi = demux->priv;
> > +
> > +	if (!dvb_spi->feed_count) {
> > +		pr_err("no feed is started\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (feed->pid == 0x2000) {
> > +		/*
> > +		 * Special PID case.
> > +		 * Number of 0x2000 feed request was stored
> > +		 * in dvb_spi->all_pid_feed_count.
> > +		 */
> > +		if (dvb_spi->all_pid_feed_count <= 0) {
> > +			pr_err("PID %d not found.\n", feed->pid);
> > +			return -EINVAL;
> > +		}
> > +		dvb_spi->all_pid_feed_count--;
> > +	} else {
> > +		struct cxd2880_pid_filter_config cfgtmp;
> > +
> > +		cfgtmp = dvb_spi->filter_config;
> > +
> > +		for (i = 0; i < CXD2880_MAX_FILTER_SIZE; i++) {
> > +			if (feed->pid == cfgtmp.pid_config[i].pid &&
> > +			    cfgtmp.pid_config[i].is_enable != 0) {
> > +				cfgtmp.pid_config[i].is_enable = 0;
> > +				cfgtmp.pid_config[i].pid = 0;
> > +				pr_debug("removed PID %d from #%d\n",
> > +					 feed->pid, i);
> > +				break;
> > +			}
> > +		}
> > +		dvb_spi->filter_config = cfgtmp;
> > +
> > +		if (i == CXD2880_MAX_FILTER_SIZE) {
> > +			pr_err("PID %d not found\n", feed->pid);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	ret = cxd2880_update_pid_filter(dvb_spi,
> > +					&dvb_spi->filter_config,
> > +					dvb_spi->all_pid_feed_count >
> 0);
> > +	dvb_spi->feed_count--;
> > +
> > +	if (dvb_spi->feed_count == 0) {
> > +		int ret_stop = 0;
> > +
> > +		ret_stop =
> kthread_stop(dvb_spi->cxd2880_ts_read_thread);
> > +		if (ret_stop) {
> > +			pr_err("'kthread_stop failed. (%d)\n",
> ret_stop);
> > +			ret = ret_stop;
> > +		}
> > +		kfree(dvb_spi->ts_buf);
> > +		dvb_spi->ts_buf = NULL;
> > +	}
> > +
> > +	pr_debug("stop feed ok.(count %d)\n", dvb_spi->feed_count);
> > +
> > +	return ret;
> > +}
> 
> I have the feeling that I've seen the code above before at the dvb core.
> Any reason why don't use the already-existing code at dvb_demux.c &
> friends?

The CXD2880 HW PID filter is used to decrease the amount of TS data transferred via limited bit rate SPI interface.

Thanks,
Takiguchi
