Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:53955 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756156AbdJMIo4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 04:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20171013055928.21132-1-Yasunari.Takiguchi@sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com> <20171013055928.21132-1-Yasunari.Takiguchi@sony.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 13 Oct 2017 10:44:54 +0200
Message-ID: <CAJbz7-0T=LUSTr59kPDk4kVkHLh5XEeNEkA2T=hG=P_fXrrU=g@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] [media] cxd2880-spi: Add support for CXD2880 SPI interface
To: Yasunari.Takiguchi@sony.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        tbird20d@gmail.com, frowand.list@gmail.com,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        Kota Yonezawa <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yasunari

2017-10-13 7:59 GMT+02:00  <Yasunari.Takiguchi@sony.com>:
> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
>
> This is the SPI adapter part of the driver for the
> Sony CXD2880 DVB-T2/T tuner + demodulator.
>

[...]

> +static const struct of_device_id cxd2880_spi_of_match[] = {
> +       { .compatible = "sony,cxd2880" },
> +       { /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, cxd2880_spi_of_match);
> +
> +static int
> +cxd2880_spi_probe(struct spi_device *spi)
> +{
> +       int ret;
> +       struct cxd2880_dvb_spi *dvb_spi = NULL;
> +       struct cxd2880_config config;
> +
> +       if (!spi) {
> +               pr_err("invalid arg.\n");
> +               return -EINVAL;
> +       }
> +
> +       dvb_spi = kzalloc(sizeof(struct cxd2880_dvb_spi), GFP_KERNEL);
> +       if (!dvb_spi)
> +               return -ENOMEM;
> +
> +       dvb_spi->spi = spi;
> +       mutex_init(&dvb_spi->spi_mutex);
> +       dev_set_drvdata(&spi->dev, dvb_spi);
> +       config.spi = spi;
> +       config.spi_mutex = &dvb_spi->spi_mutex;
> +
> +       ret = dvb_register_adapter(&dvb_spi->adapter,
> +                                  "CXD2880",
> +                                  THIS_MODULE,
> +                                  &spi->dev,
> +                                  adapter_nr);
> +       if (ret < 0) {
> +               pr_err("dvb_register_adapter() failed\n");
> +               goto fail_adapter;
> +       }
> +
> +       if (!dvb_attach(cxd2880_attach, &dvb_spi->dvb_fe, &config)) {
> +               pr_err("cxd2880_attach failed\n");
> +               goto fail_attach;
> +       }
> +
> +       ret = dvb_register_frontend(&dvb_spi->adapter,
> +                                   &dvb_spi->dvb_fe);
> +       if (ret < 0) {
> +               pr_err("dvb_register_frontend() failed\n");
> +               goto fail_frontend;
> +       }
> +
> +       dvb_spi->demux.dmx.capabilities = DMX_TS_FILTERING;
> +       dvb_spi->demux.priv = dvb_spi;
> +       dvb_spi->demux.filternum = CXD2880_MAX_FILTER_SIZE;
> +       dvb_spi->demux.feednum = CXD2880_MAX_FILTER_SIZE;
> +       dvb_spi->demux.start_feed = cxd2880_start_feed;
> +       dvb_spi->demux.stop_feed = cxd2880_stop_feed;
> +
> +       ret = dvb_dmx_init(&dvb_spi->demux);
> +       if (ret < 0) {
> +               pr_err("dvb_dmx_init() failed\n");
> +               goto fail_dmx;
> +       }
> +
> +       dvb_spi->dmxdev.filternum = CXD2880_MAX_FILTER_SIZE;
> +       dvb_spi->dmxdev.demux = &dvb_spi->demux.dmx;
> +       dvb_spi->dmxdev.capabilities = 0;
> +       ret = dvb_dmxdev_init(&dvb_spi->dmxdev,
> +                             &dvb_spi->adapter);
> +       if (ret < 0) {
> +               pr_err("dvb_dmxdev_init() failed\n");
> +               goto fail_dmxdev;
> +       }
> +
> +       dvb_spi->dmx_fe.source = DMX_FRONTEND_0;
> +       ret = dvb_spi->demux.dmx.add_frontend(&dvb_spi->demux.dmx,
> +                                             &dvb_spi->dmx_fe);
> +       if (ret < 0) {
> +               pr_err("add_frontend() failed\n");
> +               goto fail_dmx_fe;
> +       }
> +
> +       ret = dvb_spi->demux.dmx.connect_frontend(&dvb_spi->demux.dmx,
> +                                                 &dvb_spi->dmx_fe);
> +       if (ret < 0) {
> +               pr_err("dvb_register_frontend() failed\n");
> +               goto fail_fe_conn;
> +       }
> +
> +       pr_info("Sony CXD2880 has successfully attached.\n");
> +
> +       return 0;
> +
> +fail_fe_conn:
> +       dvb_spi->demux.dmx.remove_frontend(&dvb_spi->demux.dmx,
> +                                          &dvb_spi->dmx_fe);
> +fail_dmx_fe:
> +       dvb_dmxdev_release(&dvb_spi->dmxdev);
> +fail_dmxdev:
> +       dvb_dmx_release(&dvb_spi->demux);
> +fail_dmx:
> +       dvb_unregister_frontend(&dvb_spi->dvb_fe);
> +fail_frontend:
> +       dvb_frontend_detach(&dvb_spi->dvb_fe);
> +fail_attach:
> +       dvb_unregister_adapter(&dvb_spi->adapter);
> +fail_adapter:
> +       kfree(dvb_spi);
> +       return ret;
> +}
> +
> +static int
> +cxd2880_spi_remove(struct spi_device *spi)
> +{
> +       struct cxd2880_dvb_spi *dvb_spi;
> +
> +       if (!spi) {
> +               pr_err("invalid arg\n");
> +               return -EINVAL;
> +       }
> +
> +       dvb_spi = dev_get_drvdata(&spi->dev);
> +
> +       if (!dvb_spi) {
> +               pr_err("failed\n");
> +               return -EINVAL;
> +       }
> +       dvb_spi->demux.dmx.remove_frontend(&dvb_spi->demux.dmx,
> +                                          &dvb_spi->dmx_fe);
> +       dvb_dmxdev_release(&dvb_spi->dmxdev);
> +       dvb_dmx_release(&dvb_spi->demux);
> +       dvb_unregister_frontend(&dvb_spi->dvb_fe);
> +       dvb_frontend_detach(&dvb_spi->dvb_fe);
> +       dvb_unregister_adapter(&dvb_spi->adapter);
> +
> +       kfree(dvb_spi);
> +       pr_info("cxd2880_spi remove ok.\n");
> +
> +       return 0;
> +}
> +
> +static const struct spi_device_id cxd2880_spi_id[] = {
> +       { "cxd2880", 0 },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(spi, cxd2880_spi_id);
> +
> +static struct spi_driver cxd2880_spi_driver = {
> +       .driver = {
> +               .name   = "cxd2880",
> +               .of_match_table = cxd2880_spi_of_match,
> +       },
> +       .id_table = cxd2880_spi_id,
> +       .probe    = cxd2880_spi_probe,
> +       .remove   = cxd2880_spi_remove,
> +};
> +module_spi_driver(cxd2880_spi_driver);
> +
> +MODULE_DESCRIPTION(
> +"Sony CXD2880 DVB-T2/T tuner + demodulator drvier SPI adapter");
> +MODULE_AUTHOR("Sony Semiconductor Solutions Corporation");
> +MODULE_LICENSE("GPL v2");
> --
> 2.13.0
>

It looks like very interesting device!

If I understand it right, it uses SPI bus also for passing transport stream
to the host system (also having some pid piltering inside!), isn't it?

It would be interesting to know what is the max throughput of the CXD's SPI?

/Honza
