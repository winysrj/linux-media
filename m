Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BD0C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 22:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1267C20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 22:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfCGWvr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 17:51:47 -0500
Received: from relayout02-q02.e.movistar.es ([86.109.101.152]:21029 "EHLO
        relayout02-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726243AbfCGWvq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 17:51:46 -0500
Received: from relayout02-redir.e.movistar.es (relayout02-redir.e.movistar.es [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 44Fm8b2k55zhYgr;
        Thu,  7 Mar 2019 23:51:43 +0100 (CET)
Received: from [192.168.0.167] (unknown [47.62.122.75])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout02.e.movistar.es (Postfix) with ESMTPA id 44Fm8Y1zFzzdZq9;
        Thu,  7 Mar 2019 23:51:40 +0100 (CET)
Date:   Thu, 07 Mar 2019 23:51:41 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <201903080602.9no0UbXr%fengguang.wu@intel.com>
References: <A23F77AB-9546-4D74-8B1D-7360221CA6CF@telefonica.net> <201903080602.9no0UbXr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH V3 2/2] Add support for the Avermedia TD310
To:     kbuild test robot <lkp@intel.com>
CC:     kbuild-all@01.org, Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        Andreas Kemnade <andreas@kemnade.info>,
        jose.alberto.reguero@gmail.com
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <DE41A26C-7943-466B-BCE6-CD487807C253@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 47.62.122.75 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout02
X-TnetOut-MsgID: 44Fm8Y1zFzzdZq9.AC509
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1552603903.25692@iqvglh/jv51uK+Bu9io9XQ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

El 7 de marzo de 2019 23:38:47 CET, kbuild test robot <lkp@intel.com> escribió:
>Hi Jose,
>
>Thank you for the patch! Yet something to improve:
>
>[auto build test ERROR on linuxtv-media/master]
>[also build test ERROR on v5.0 next-20190306]
>[if your patch is applied to the wrong git tree, please drop us a note
>to help improve the system]
>
>url:   
>https://github.com/0day-ci/linux/commits/Jose-Alberto-Reguero/init-i2c-already-in-it930x_frontend_attach/20190308-055354
>base:   git://linuxtv.org/media_tree.git master
>config: nds32-allyesconfig (attached as .config)
>compiler: nds32le-linux-gcc (GCC) 6.4.0
>reproduce:
>wget
>https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
>-O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # save the attached .config to linux build tree
>        GCC_VERSION=6.4.0 make.cross ARCH=nds32 
>
>All errors (new ones prefixed by >>):
>
>drivers/media/usb/dvb-usb-v2/af9035.c: In function
>'af9035_read_config':
>>> drivers/media/usb/dvb-usb-v2/af9035.c:877:54: error:
>'USB_PID_AVERMEDIA_TD310' undeclared (first use in this function)
>(le16_to_cpu(d->udev->descriptor.idProduct) ==
>USB_PID_AVERMEDIA_TD310)) {
>                                                ^~~~~~~~~~~~~~~~~~~~~~~

I missed a part of the patch. I resend the series.

Jose Alberto

>drivers/media/usb/dvb-usb-v2/af9035.c:877:54: note: each undeclared
>identifier is reported only once for each function it appears in
>   In file included from drivers/media/usb/dvb-usb-v2/af9035.h:26:0,
>                    from drivers/media/usb/dvb-usb-v2/af9035.c:22:
>   drivers/media/usb/dvb-usb-v2/af9035.c: At top level:
>>> drivers/media/usb/dvb-usb-v2/af9035.c:2137:38: error:
>'USB_PID_AVERMEDIA_TD310' undeclared here (not in a function)
>     { DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD310,
>                                         ^
>drivers/media/usb/dvb-usb-v2/dvb_usb.h:105:16: note: in definition of
>macro 'DVB_USB_DEVICE'
>     .idProduct = (prod), \
>                   ^~~~
>
>vim +/USB_PID_AVERMEDIA_TD310 +877
>drivers/media/usb/dvb-usb-v2/af9035.c
>
>   833	
>   834	static int af9035_read_config(struct dvb_usb_device *d)
>   835	{
>   836		struct usb_interface *intf = d->intf;
>   837		struct state *state = d_to_priv(d);
>   838		int ret, i;
>   839		u8 tmp;
>   840		u16 tmp16;
>   841	
>   842		/* Demod I2C address */
>   843		state->af9033_i2c_addr[0] = 0x1c;
>   844		state->af9033_i2c_addr[1] = 0x1d;
>845		state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
>846		state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
>   847		state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
>   848		state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
>   849		state->it930x_addresses = 0;
>   850	
>   851		if (state->chip_type == 0x9135) {
>   852			/* feed clock for integrated RF tuner */
>   853			state->af9033_config[0].dyn0_clk = true;
>   854			state->af9033_config[1].dyn0_clk = true;
>   855	
>   856			if (state->chip_version == 0x02) {
>   857				state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
>   858				state->af9033_config[1].tuner = AF9033_TUNER_IT9135_60;
>   859			} else {
>   860				state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
>   861				state->af9033_config[1].tuner = AF9033_TUNER_IT9135_38;
>   862			}
>   863	
>   864			if (state->no_eeprom) {
>   865				/* Remote controller to NEC polling by default */
>   866				state->ir_mode = 0x05;
>   867				state->ir_type = 0x00;
>   868	
>   869				goto skip_eeprom;
>   870			}
>   871		} else if (state->chip_type == 0x9306) {
>   872			/*
>   873			 * IT930x is an USB bridge, only single demod-single tuner
>   874			 * configurations seen so far.
>   875			 */
>876			if ((le16_to_cpu(d->udev->descriptor.idVendor) ==
>USB_VID_AVERMEDIA) &&
>> 877			    (le16_to_cpu(d->udev->descriptor.idProduct) ==
>USB_PID_AVERMEDIA_TD310)) {
>   878				state->it930x_addresses = 1;
>   879			}
>   880			return 0;
>   881		}
>   882	
>   883		/* Remote controller */
>   884		state->ir_mode = state->eeprom[EEPROM_IR_MODE];
>   885		state->ir_type = state->eeprom[EEPROM_IR_TYPE];
>   886	
>   887		if (state->dual_mode) {
>   888			/* Read 2nd demodulator I2C address. 8-bit format on eeprom */
>   889			tmp = state->eeprom[EEPROM_2ND_DEMOD_ADDR];
>   890			if (tmp)
>   891				state->af9033_i2c_addr[1] = tmp >> 1;
>   892	
>   893			dev_dbg(&intf->dev, "2nd demod I2C addr=%02x\n",
>   894				state->af9033_i2c_addr[1]);
>   895		}
>   896	
>   897		for (i = 0; i < state->dual_mode + 1; i++) {
>   898			unsigned int eeprom_offset = 0;
>   899	
>   900			/* tuner */
>   901			tmp = state->eeprom[EEPROM_1_TUNER_ID + eeprom_offset];
>   902			dev_dbg(&intf->dev, "[%d]tuner=%02x\n", i, tmp);
>   903	
>   904			/* tuner sanity check */
>   905			if (state->chip_type == 0x9135) {
>   906				if (state->chip_version == 0x02) {
>   907					/* IT9135 BX (v2) */
>   908					switch (tmp) {
>   909					case AF9033_TUNER_IT9135_60:
>   910					case AF9033_TUNER_IT9135_61:
>   911					case AF9033_TUNER_IT9135_62:
>   912						state->af9033_config[i].tuner = tmp;
>   913						break;
>   914					}
>   915				} else {
>   916					/* IT9135 AX (v1) */
>   917					switch (tmp) {
>   918					case AF9033_TUNER_IT9135_38:
>   919					case AF9033_TUNER_IT9135_51:
>   920					case AF9033_TUNER_IT9135_52:
>   921						state->af9033_config[i].tuner = tmp;
>   922						break;
>   923					}
>   924				}
>   925			} else {
>   926				/* AF9035 */
>   927				state->af9033_config[i].tuner = tmp;
>   928			}
>   929	
>   930			if (state->af9033_config[i].tuner != tmp) {
>931				dev_info(&intf->dev, "[%d] overriding tuner from %02x to
>%02x\n",
>   932					 i, tmp, state->af9033_config[i].tuner);
>   933			}
>   934	
>   935			switch (state->af9033_config[i].tuner) {
>   936			case AF9033_TUNER_TUA9001:
>   937			case AF9033_TUNER_FC0011:
>   938			case AF9033_TUNER_MXL5007T:
>   939			case AF9033_TUNER_TDA18218:
>   940			case AF9033_TUNER_FC2580:
>   941			case AF9033_TUNER_FC0012:
>   942				state->af9033_config[i].spec_inv = 1;
>   943				break;
>   944			case AF9033_TUNER_IT9135_38:
>   945			case AF9033_TUNER_IT9135_51:
>   946			case AF9033_TUNER_IT9135_52:
>   947			case AF9033_TUNER_IT9135_60:
>   948			case AF9033_TUNER_IT9135_61:
>   949			case AF9033_TUNER_IT9135_62:
>   950				break;
>   951			default:
>952				dev_warn(&intf->dev, "tuner id=%02x not supported, please
>report!",
>   953					 tmp);
>   954			}
>   955	
>   956			/* disable dual mode if driver does not support it */
>   957			if (i == 1)
>   958				switch (state->af9033_config[i].tuner) {
>   959				case AF9033_TUNER_FC0012:
>   960				case AF9033_TUNER_IT9135_38:
>   961				case AF9033_TUNER_IT9135_51:
>   962				case AF9033_TUNER_IT9135_52:
>   963				case AF9033_TUNER_IT9135_60:
>   964				case AF9033_TUNER_IT9135_61:
>   965				case AF9033_TUNER_IT9135_62:
>   966				case AF9033_TUNER_MXL5007T:
>   967					break;
>   968				default:
>   969					state->dual_mode = false;
>970					dev_info(&intf->dev, "driver does not support 2nd tuner and
>will disable it");
>   971			}
>   972	
>   973			/* tuner IF frequency */
>   974			tmp = state->eeprom[EEPROM_1_IF_L + eeprom_offset];
>   975			tmp16 = tmp << 0;
>   976			tmp = state->eeprom[EEPROM_1_IF_H + eeprom_offset];
>   977			tmp16 |= tmp << 8;
>   978			dev_dbg(&intf->dev, "[%d]IF=%d\n", i, tmp16);
>   979	
>   980			eeprom_offset += 0x10; /* shift for the 2nd tuner params */
>   981		}
>   982	
>   983	skip_eeprom:
>   984		/* get demod clock */
>   985		ret = af9035_rd_reg(d, 0x00d800, &tmp);
>   986		if (ret < 0)
>   987			goto err;
>   988	
>   989		tmp = (tmp >> 0) & 0x0f;
>   990	
>   991		for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++) {
>   992			if (state->chip_type == 0x9135)
>   993				state->af9033_config[i].clock = clock_lut_it9135[tmp];
>   994			else
>   995				state->af9033_config[i].clock = clock_lut_af9035[tmp];
>   996		}
>   997	
>   998		state->no_read = false;
>999		/* Some MXL5007T devices cannot properly handle tuner I2C read
>ops. */
>  1000		if (state->af9033_config[0].tuner == AF9033_TUNER_MXL5007T &&
> 1001			le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA)
>  1002	
>  1003			switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
>  1004			case USB_PID_AVERMEDIA_A867:
>  1005			case USB_PID_AVERMEDIA_TWINSTAR:
>  1006				dev_info(&intf->dev,
>1007					 "Device may have issues with I2C read operations. Enabling
>fix.\n");
>  1008				state->no_read = true;
>  1009				break;
>  1010			}
>  1011	
>  1012		return 0;
>  1013	
>  1014	err:
>  1015		dev_dbg(&intf->dev, "failed=%d\n", ret);
>  1016	
>  1017		return ret;
>  1018	}
>  1019	
>
>---
>0-DAY kernel test infrastructure                Open Source Technology
>Center
>https://lists.01.org/pipermail/kbuild-all                   Intel
>Corporation


-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
