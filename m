Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54532 "EHLO
        homiemail-a117.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932204AbeBLVnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:43:16 -0500
Subject: Re: [PATCH 1/7] cx231xx: Add second frontend option
To: Alex Deucher <alexdeucher@gmail.com>,
        Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
 <1515773982-6411-2-git-send-email-brad@nextdimension.cc>
 <CADnq5_O+weERf8zSTrVFeO7BkU7KmtWsg1L4bvvSDGanCEmmfA@mail.gmail.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <dfa21418-da3c-0d45-69ee-6e3325afbb3e@nextdimension.cc>
Date: Mon, 12 Feb 2018 15:43:14 -0600
MIME-Version: 1.0
In-Reply-To: <CADnq5_O+weERf8zSTrVFeO7BkU7KmtWsg1L4bvvSDGanCEmmfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,


On 2018-01-12 13:09, Alex Deucher wrote:
> On Fri, Jan 12, 2018 at 11:19 AM, Brad Love <brad@nextdimension.cc> wrote:
>> Include ability to add a second dvb attach style frontend to cx231xx
>> USB bridge. All current boards set to use frontend[0]. Changes are
>> backwards compatible with current behaviour.
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>>  drivers/media/usb/cx231xx/cx231xx-dvb.c | 173 ++++++++++++++++++--------------
>>  1 file changed, 97 insertions(+), 76 deletions(-)
>>
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
>> index cb4209f..4c6d2f4 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
>> @@ -55,7 +55,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>>  #define CX231XX_DVB_MAX_PACKETS 64
>>
>>  struct cx231xx_dvb {
>> -       struct dvb_frontend *frontend;
>> +       struct dvb_frontend *frontend[2];
> Maybe define something like CX231XX_MAX_FRONTEND and use it here
> rather than using a hardcoded 2.
>
> Alex

Done. See v2 1/7 and v2 2/7.

Cheers,

Brad



>
>>         /* feed count management */
>>         struct mutex lock;
>> @@ -386,17 +386,17 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
>>         cfg.i2c_adap = cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master);
>>         cfg.i2c_addr = addr;
>>
>> -       if (!dev->dvb->frontend) {
>> +       if (!dev->dvb->frontend[0]) {
>>                 dev_err(dev->dev, "%s/2: dvb frontend not attached. Can't attach xc5000\n",
>>                         dev->name);
>>                 return -EINVAL;
>>         }
>>
>> -       fe = dvb_attach(xc5000_attach, dev->dvb->frontend, &cfg);
>> +       fe = dvb_attach(xc5000_attach, dev->dvb->frontend[0], &cfg);
>>         if (!fe) {
>>                 dev_err(dev->dev, "%s/2: xc5000 attach failed\n", dev->name);
>> -               dvb_frontend_detach(dev->dvb->frontend);
>> -               dev->dvb->frontend = NULL;
>> +               dvb_frontend_detach(dev->dvb->frontend[0]);
>> +               dev->dvb->frontend[0] = NULL;
>>                 return -EINVAL;
>>         }
>>
>> @@ -408,9 +408,9 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
>>
>>  int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq)
>>  {
>> -       if ((dev->dvb != NULL) && (dev->dvb->frontend != NULL)) {
>> +       if ((dev->dvb != NULL) && (dev->dvb->frontend[0] != NULL)) {
>>
>> -               struct dvb_tuner_ops *dops = &dev->dvb->frontend->ops.tuner_ops;
>> +               struct dvb_tuner_ops *dops = &dev->dvb->frontend[0]->ops.tuner_ops;
>>
>>                 if (dops->set_analog_params != NULL) {
>>                         struct analog_parameters params;
>> @@ -421,7 +421,7 @@ int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq)
>>                         /*params.audmode = ;       */
>>
>>                         /* Set the analog parameters to set the frequency */
>> -                       dops->set_analog_params(dev->dvb->frontend, &params);
>> +                       dops->set_analog_params(dev->dvb->frontend[0], &params);
>>                 }
>>
>>         }
>> @@ -433,15 +433,15 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
>>  {
>>         int status = 0;
>>
>> -       if ((dev->dvb != NULL) && (dev->dvb->frontend != NULL)) {
>> +       if ((dev->dvb != NULL) && (dev->dvb->frontend[0] != NULL)) {
>>
>> -               struct dvb_tuner_ops *dops = &dev->dvb->frontend->ops.tuner_ops;
>> +               struct dvb_tuner_ops *dops = &dev->dvb->frontend[0]->ops.tuner_ops;
>>
>>                 if (dops->init != NULL && !dev->xc_fw_load_done) {
>>
>>                         dev_dbg(dev->dev,
>>                                 "Reloading firmware for XC5000\n");
>> -                       status = dops->init(dev->dvb->frontend);
>> +                       status = dops->init(dev->dvb->frontend[0]);
>>                         if (status == 0) {
>>                                 dev->xc_fw_load_done = 1;
>>                                 dev_dbg(dev->dev,
>> @@ -481,17 +481,29 @@ static int register_dvb(struct cx231xx_dvb *dvb,
>>         dvb_register_media_controller(&dvb->adapter, dev->media_dev);
>>
>>         /* Ensure all frontends negotiate bus access */
>> -       dvb->frontend->ops.ts_bus_ctrl = cx231xx_dvb_bus_ctrl;
>> +       dvb->frontend[0]->ops.ts_bus_ctrl = cx231xx_dvb_bus_ctrl;
>> +       if (dvb->frontend[1])
>> +               dvb->frontend[1]->ops.ts_bus_ctrl = cx231xx_dvb_bus_ctrl;
>>
>>         dvb->adapter.priv = dev;
>>
>>         /* register frontend */
>> -       result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
>> +       result = dvb_register_frontend(&dvb->adapter, dvb->frontend[0]);
>>         if (result < 0) {
>>                 dev_warn(dev->dev,
>>                        "%s: dvb_register_frontend failed (errno = %d)\n",
>>                        dev->name, result);
>> -               goto fail_frontend;
>> +               goto fail_frontend0;
>> +       }
>> +
>> +       if (dvb->frontend[1]) {
>> +               result = dvb_register_frontend(&dvb->adapter, dvb->frontend[1]);
>> +               if (result < 0) {
>> +                       dev_warn(dev->dev,
>> +                               "%s: 2nd dvb_register_frontend failed (errno = %d)\n",
>> +                               dev->name, result);
>> +                       goto fail_frontend1;
>> +               }
>>         }
>>
>>         /* register demux stuff */
>> @@ -569,9 +581,14 @@ static int register_dvb(struct cx231xx_dvb *dvb,
>>  fail_dmxdev:
>>         dvb_dmx_release(&dvb->demux);
>>  fail_dmx:
>> -       dvb_unregister_frontend(dvb->frontend);
>> -fail_frontend:
>> -       dvb_frontend_detach(dvb->frontend);
>> +       if (dvb->frontend[1])
>> +               dvb_unregister_frontend(dvb->frontend[1]);
>> +       dvb_unregister_frontend(dvb->frontend[0]);
>> +fail_frontend1:
>> +       if (dvb->frontend[1])
>> +               dvb_frontend_detach(dvb->frontend[1]);
>> +fail_frontend0:
>> +       dvb_frontend_detach(dvb->frontend[0]);
>>         dvb_unregister_adapter(&dvb->adapter);
>>  fail_adapter:
>>         return result;
>> @@ -585,8 +602,12 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
>>         dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
>>         dvb_dmxdev_release(&dvb->dmxdev);
>>         dvb_dmx_release(&dvb->demux);
>> -       dvb_unregister_frontend(dvb->frontend);
>> -       dvb_frontend_detach(dvb->frontend);
>> +       if (dvb->frontend[1])
>> +               dvb_unregister_frontend(dvb->frontend[1]);
>> +       dvb_unregister_frontend(dvb->frontend[0]);
>> +       if (dvb->frontend[1])
>> +               dvb_frontend_detach(dvb->frontend[1]);
>> +       dvb_frontend_detach(dvb->frontend[0]);
>>         dvb_unregister_adapter(&dvb->adapter);
>>         /* remove I2C tuner */
>>         client = dvb->i2c_client_tuner;
>> @@ -635,11 +656,11 @@ static int dvb_init(struct cx231xx *dev)
>>         case CX231XX_BOARD_CNXT_CARRAERA:
>>         case CX231XX_BOARD_CNXT_RDE_250:
>>
>> -               dev->dvb->frontend = dvb_attach(s5h1432_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(s5h1432_attach,
>>                                         &dvico_s5h1432_config,
>>                                         demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach s5h1432 front end\n");
>>                         result = -EINVAL;
>> @@ -647,9 +668,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
>> +               if (!dvb_attach(xc5000_attach, dev->dvb->frontend[0],
>>                                tuner_i2c,
>>                                &cnxt_rde250_tunerconfig)) {
>>                         result = -EINVAL;
>> @@ -660,11 +681,11 @@ static int dvb_init(struct cx231xx *dev)
>>         case CX231XX_BOARD_CNXT_SHELBY:
>>         case CX231XX_BOARD_CNXT_RDU_250:
>>
>> -               dev->dvb->frontend = dvb_attach(s5h1411_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(s5h1411_attach,
>>                                                &xc5000_s5h1411_config,
>>                                                demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach s5h1411 front end\n");
>>                         result = -EINVAL;
>> @@ -672,9 +693,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
>> +               if (!dvb_attach(xc5000_attach, dev->dvb->frontend[0],
>>                                tuner_i2c,
>>                                &cnxt_rdu250_tunerconfig)) {
>>                         result = -EINVAL;
>> @@ -683,11 +704,11 @@ static int dvb_init(struct cx231xx *dev)
>>                 break;
>>         case CX231XX_BOARD_CNXT_RDE_253S:
>>
>> -               dev->dvb->frontend = dvb_attach(s5h1432_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(s5h1432_attach,
>>                                         &dvico_s5h1432_config,
>>                                         demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach s5h1432 front end\n");
>>                         result = -EINVAL;
>> @@ -695,9 +716,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
>> +               if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>                                0x60, tuner_i2c,
>>                                &cnxt_rde253s_tunerconfig)) {
>>                         result = -EINVAL;
>> @@ -707,11 +728,11 @@ static int dvb_init(struct cx231xx *dev)
>>         case CX231XX_BOARD_CNXT_RDU_253S:
>>         case CX231XX_BOARD_KWORLD_UB445_USB_HYBRID:
>>
>> -               dev->dvb->frontend = dvb_attach(s5h1411_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(s5h1411_attach,
>>                                                &tda18271_s5h1411_config,
>>                                                demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach s5h1411 front end\n");
>>                         result = -EINVAL;
>> @@ -719,9 +740,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
>> +               if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>                                0x60, tuner_i2c,
>>                                &cnxt_rde253s_tunerconfig)) {
>>                         result = -EINVAL;
>> @@ -734,11 +755,11 @@ static int dvb_init(struct cx231xx *dev)
>>                          "%s: looking for tuner / demod on i2c bus: %d\n",
>>                        __func__, i2c_adapter_id(tuner_i2c));
>>
>> -               dev->dvb->frontend = dvb_attach(lgdt3305_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(lgdt3305_attach,
>>                                                 &hcw_lgdt3305_config,
>>                                                 demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach LG3305 front end\n");
>>                         result = -EINVAL;
>> @@ -746,9 +767,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               dvb_attach(tda18271_attach, dev->dvb->frontend,
>> +               dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>                            0x60, tuner_i2c,
>>                            &hcw_tda18271_config);
>>                 break;
>> @@ -761,7 +782,7 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 /* attach demod */
>>                 memset(&si2165_pdata, 0, sizeof(si2165_pdata));
>> -               si2165_pdata.fe = &dev->dvb->frontend;
>> +               si2165_pdata.fe = &dev->dvb->frontend[0];
>>                 si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
>>                 si2165_pdata.ref_freq_hz = 16000000;
>>
>> @@ -771,7 +792,7 @@ static int dvb_init(struct cx231xx *dev)
>>                 info.platform_data = &si2165_pdata;
>>                 request_module(info.type);
>>                 client = i2c_new_device(demod_i2c, &info);
>> -               if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
>> +               if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach SI2165 front end\n");
>>                         result = -EINVAL;
>> @@ -786,12 +807,12 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 dvb->i2c_client_demod = client;
>>
>> -               dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
>> +               dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               dvb_attach(tda18271_attach, dev->dvb->frontend,
>> +               dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>                         0x60,
>>                         tuner_i2c,
>>                         &hcw_tda18271_config);
>> @@ -808,7 +829,7 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 /* attach demod */
>>                 memset(&si2165_pdata, 0, sizeof(si2165_pdata));
>> -               si2165_pdata.fe = &dev->dvb->frontend;
>> +               si2165_pdata.fe = &dev->dvb->frontend[0];
>>                 si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT;
>>                 si2165_pdata.ref_freq_hz = 24000000;
>>
>> @@ -818,7 +839,7 @@ static int dvb_init(struct cx231xx *dev)
>>                 info.platform_data = &si2165_pdata;
>>                 request_module(info.type);
>>                 client = i2c_new_device(demod_i2c, &info);
>> -               if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
>> +               if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach SI2165 front end\n");
>>                         result = -EINVAL;
>> @@ -835,14 +856,14 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 memset(&info, 0, sizeof(struct i2c_board_info));
>>
>> -               dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
>> +               dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>>                 /* attach tuner */
>>                 memset(&si2157_config, 0, sizeof(si2157_config));
>> -               si2157_config.fe = dev->dvb->frontend;
>> +               si2157_config.fe = dev->dvb->frontend[0];
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>                 si2157_config.mdev = dev->media_dev;
>>  #endif
>> @@ -857,14 +878,14 @@ static int dvb_init(struct cx231xx *dev)
>>                         tuner_i2c,
>>                         &info);
>>                 if (client == NULL || client->dev.driver == NULL) {
>> -                       dvb_frontend_detach(dev->dvb->frontend);
>> +                       dvb_frontend_detach(dev->dvb->frontend[0]);
>>                         result = -ENODEV;
>>                         goto out_free;
>>                 }
>>
>>                 if (!try_module_get(client->dev.driver->owner)) {
>>                         i2c_unregister_device(client);
>> -                       dvb_frontend_detach(dev->dvb->frontend);
>> +                       dvb_frontend_detach(dev->dvb->frontend[0]);
>>                         result = -ENODEV;
>>                         goto out_free;
>>                 }
>> @@ -882,26 +903,26 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 memset(&info, 0, sizeof(struct i2c_board_info));
>>
>> -               dev->dvb->frontend = dvb_attach(lgdt3306a_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(lgdt3306a_attach,
>>                         &hauppauge_955q_lgdt3306a_config,
>>                         demod_i2c
>>                         );
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach LGDT3306A frontend.\n");
>>                         result = -EINVAL;
>>                         goto out_free;
>>                 }
>>
>> -               dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
>> +               dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>>                 /* attach tuner */
>>                 memset(&si2157_config, 0, sizeof(si2157_config));
>> -               si2157_config.fe = dev->dvb->frontend;
>> +               si2157_config.fe = dev->dvb->frontend[0];
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>                 si2157_config.mdev = dev->media_dev;
>>  #endif
>> @@ -916,14 +937,14 @@ static int dvb_init(struct cx231xx *dev)
>>                         tuner_i2c,
>>                         &info);
>>                 if (client == NULL || client->dev.driver == NULL) {
>> -                       dvb_frontend_detach(dev->dvb->frontend);
>> +                       dvb_frontend_detach(dev->dvb->frontend[0]);
>>                         result = -ENODEV;
>>                         goto out_free;
>>                 }
>>
>>                 if (!try_module_get(client->dev.driver->owner)) {
>>                         i2c_unregister_device(client);
>> -                       dvb_frontend_detach(dev->dvb->frontend);
>> +                       dvb_frontend_detach(dev->dvb->frontend[0]);
>>                         result = -ENODEV;
>>                         goto out_free;
>>                 }
>> @@ -940,11 +961,11 @@ static int dvb_init(struct cx231xx *dev)
>>                          "%s: looking for demod on i2c bus: %d\n",
>>                          __func__, i2c_adapter_id(tuner_i2c));
>>
>> -               dev->dvb->frontend = dvb_attach(mb86a20s_attach,
>> +               dev->dvb->frontend[0] = dvb_attach(mb86a20s_attach,
>>                                                 &pv_mb86a20s_config,
>>                                                 demod_i2c);
>>
>> -               if (dev->dvb->frontend == NULL) {
>> +               if (dev->dvb->frontend[0] == NULL) {
>>                         dev_err(dev->dev,
>>                                 "Failed to attach mb86a20s demod\n");
>>                         result = -EINVAL;
>> @@ -952,9 +973,9 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>> -               dvb_attach(tda18271_attach, dev->dvb->frontend,
>> +               dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>                            0x60, tuner_i2c,
>>                            &pv_tda18271_config);
>>                 break;
>> @@ -969,7 +990,7 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 /* attach demodulator chip */
>>                 si2168_config.ts_mode = SI2168_TS_SERIAL; /* from *.inf file */
>> -               si2168_config.fe = &dev->dvb->frontend;
>> +               si2168_config.fe = &dev->dvb->frontend[0];
>>                 si2168_config.i2c_adapter = &adapter;
>>                 si2168_config.ts_clock_inv = true;
>>
>> @@ -994,7 +1015,7 @@ static int dvb_init(struct cx231xx *dev)
>>                 dvb->i2c_client_demod = client;
>>
>>                 /* attach tuner chip */
>> -               si2157_config.fe = dev->dvb->frontend;
>> +               si2157_config.fe = dev->dvb->frontend[0];
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>                 si2157_config.mdev = dev->media_dev;
>>  #endif
>> @@ -1037,7 +1058,7 @@ static int dvb_init(struct cx231xx *dev)
>>                 /* attach demodulator chip */
>>                 mn88473_config.i2c_wr_max = 16;
>>                 mn88473_config.xtal = 25000000;
>> -               mn88473_config.fe = &dev->dvb->frontend;
>> +               mn88473_config.fe = &dev->dvb->frontend[0];
>>
>>                 strlcpy(info.type, "mn88473", sizeof(info.type));
>>                 info.addr = dev->board.demod_addr;
>> @@ -1060,10 +1081,10 @@ static int dvb_init(struct cx231xx *dev)
>>                 dvb->i2c_client_demod = client;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>>                 /* attach tuner chip */
>> -               dvb_attach(r820t_attach, dev->dvb->frontend,
>> +               dvb_attach(r820t_attach, dev->dvb->frontend[0],
>>                            tuner_i2c,
>>                            &astrometa_t2hybrid_r820t_config);
>>                 break;
>> @@ -1078,7 +1099,7 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 /* attach demodulator chip */
>>                 si2168_config.ts_mode = SI2168_TS_SERIAL;
>> -               si2168_config.fe = &dev->dvb->frontend;
>> +               si2168_config.fe = &dev->dvb->frontend[0];
>>                 si2168_config.i2c_adapter = &adapter;
>>                 si2168_config.ts_clock_inv = true;
>>
>> @@ -1102,13 +1123,13 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 dvb->i2c_client_demod = client;
>> -               dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
>> +               dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>>                 /* attach tuner */
>> -               si2157_config.fe = dev->dvb->frontend;
>> +               si2157_config.fe = dev->dvb->frontend[0];
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>                 si2157_config.mdev = dev->media_dev;
>>  #endif
>> @@ -1153,7 +1174,7 @@ static int dvb_init(struct cx231xx *dev)
>>
>>                 /* attach demodulator chip */
>>                 lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
>> -               lgdt3306a_config.fe = &dev->dvb->frontend;
>> +               lgdt3306a_config.fe = &dev->dvb->frontend[0];
>>                 lgdt3306a_config.i2c_adapter = &adapter;
>>
>>                 strlcpy(info.type, "lgdt3306a", sizeof(info.type));
>> @@ -1176,13 +1197,13 @@ static int dvb_init(struct cx231xx *dev)
>>                 }
>>
>>                 dvb->i2c_client_demod = client;
>> -               dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
>> +               dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
>>
>>                 /* define general-purpose callback pointer */
>> -               dvb->frontend->callback = cx231xx_tuner_callback;
>> +               dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>
>>                 /* attach tuner */
>> -               si2157_config.fe = dev->dvb->frontend;
>> +               si2157_config.fe = dev->dvb->frontend[0];
>>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>                 si2157_config.mdev = dev->media_dev;
>>  #endif
>> @@ -1223,7 +1244,7 @@ static int dvb_init(struct cx231xx *dev)
>>                         dev->name);
>>                 break;
>>         }
>> -       if (NULL == dvb->frontend) {
>> +       if (dvb->frontend[0] == NULL) {
>>                 dev_err(dev->dev,
>>                        "%s/2: frontend initialization failed\n", dev->name);
>>                 result = -EINVAL;
>> --
>> 2.7.4
>>
