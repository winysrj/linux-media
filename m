Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60532 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKYO2g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 09:28:36 -0500
Date: Tue, 25 Nov 2014 12:28:30 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Nibble Max" <nibble.max@gmail.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: Re: [PATCH v2 2/2] smipcie: add DVBSky T9580 V3 support
Message-ID: <20141125122830.7ac3d8cc@recife.lan>
In-Reply-To: <20141125122538.1a87e268@recife.lan>
References: <201411081935169219971@gmail.com>
	<201411101009107186933@gmail.com>
	<20141125122538.1a87e268@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Nov 2014 12:25:38 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Mon, 10 Nov 2014 10:09:13 +0800
> "Nibble Max" <nibble.max@gmail.com> escreveu:
> 
> > Hello Antti,
> > 
> > On 2014-11-10 06:13:07, Antti Palosaari wrote:
> > >On 11/08/2014 01:35 PM, Nibble Max wrote:
> > >> v2:
> > >> - Update Kconfig file.
> > >>
> > >> DVBSky T9580 V3 card is the dual tuner card, which supports S/S2 and T2/T/C.
> > >> 1>DVB-S/S2 frontend: M88DS3103/M88TS2022
> > >> 2>DVB-T2/T/C frontend: SI2168B40/SI2157A30
> > >> 2>PCIe bridge: SMI PCIe
> > >>
> > >> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> > >
> > >Reviewed-by: Antti Palosaari <crope@iki.fi>
> > >
> > >I reviewed the patch v1 also :]
> > >
> > >Antti
> > 
> > Thanks for your review!
> 
> This patch doesn't compile:
> 
> drivers/media/pci/smipcie/smipcie.c: In function 'smi_dvbsky_sit2_fe_attach':
> drivers/media/pci/smipcie/smipcie.c:637:2: error: implicit declaration of function 'smi_add_i2c_client' [-Werror=implicit-function-declaration]
>   client_demod = smi_add_i2c_client(i2c, &client_info);
>   ^
> drivers/media/pci/smipcie/smipcie.c:637:15: warning: assignment makes pointer from integer without a cast [enabled by default]
>   client_demod = smi_add_i2c_client(i2c, &client_info);
>                ^
> drivers/media/pci/smipcie/smipcie.c:653:15: warning: assignment makes pointer from integer without a cast [enabled by default]
>   client_tuner = smi_add_i2c_client(tuner_i2c_adapter, &client_info);
>                ^
> drivers/media/pci/smipcie/smipcie.c:655:3: error: implicit declaration of function 'smi_del_i2c_client' [-Werror=implicit-function-declaration]
>    smi_del_i2c_client(port->i2c_client_demod);
>    ^
> 

Hmm... actually patch 1/2 was marked as superseded, not sure why... 

Let me review/apply patch 1/2 first and see if it will fixes the issue.

Regards,
Mauro

> 
> > 
> > Best Regards,
> > Max
> > 
> > >
> > >> ---
> > >>   drivers/media/pci/smipcie/Kconfig   |  3 ++
> > >>   drivers/media/pci/smipcie/smipcie.c | 67 +++++++++++++++++++++++++++++++++++++
> > >>   2 files changed, 70 insertions(+)
> > >>
> > >> diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
> > >> index 75a2992..35ace80 100644
> > >> --- a/drivers/media/pci/smipcie/Kconfig
> > >> +++ b/drivers/media/pci/smipcie/Kconfig
> > >> @@ -2,12 +2,15 @@ config DVB_SMIPCIE
> > >>   	tristate "SMI PCIe DVBSky cards"
> > >>   	depends on DVB_CORE && PCI && I2C
> > >>   	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
> > >> +	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
> > >>   	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
> > >>   	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
> > >> +	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
> > >>   	help
> > >>   	  Support for cards with SMI PCIe bridge:
> > >>   	  - DVBSky S950 V3
> > >>   	  - DVBSky S952 V3
> > >> +	  - DVBSky T9580 V3
> > >>
> > >>   	  Say Y or M if you own such a device and want to use it.
> > >>   	  If unsure say N.
> > >> diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
> > >> index c27e45b..5d1932b 100644
> > >> --- a/drivers/media/pci/smipcie/smipcie.c
> > >> +++ b/drivers/media/pci/smipcie/smipcie.c
> > >> @@ -18,6 +18,8 @@
> > >>   #include "m88ds3103.h"
> > >>   #include "m88ts2022.h"
> > >>   #include "m88rs6000t.h"
> > >> +#include "si2168.h"
> > >> +#include "si2157.h"
> > >>
> > >>   DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> > >>
> > >> @@ -618,6 +620,58 @@ err_tuner_i2c_device:
> > >>   	return ret;
> > >>   }
> > >>
> > >> +static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
> > >> +{
> > >> +	int ret = 0;
> > >> +	struct smi_dev *dev = port->dev;
> > >> +	struct i2c_adapter *i2c;
> > >> +	struct i2c_adapter *tuner_i2c_adapter;
> > >> +	struct i2c_client *client_tuner, *client_demod;
> > >> +	struct i2c_board_info client_info;
> > >> +	struct si2168_config si2168_config;
> > >> +	struct si2157_config si2157_config;
> > >> +
> > >> +	/* select i2c bus */
> > >> +	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
> > >> +
> > >> +	/* attach demod */
> > >> +	memset(&si2168_config, 0, sizeof(si2168_config));
> > >> +	si2168_config.i2c_adapter = &tuner_i2c_adapter;
> > >> +	si2168_config.fe = &port->fe;
> > >> +	si2168_config.ts_mode = SI2168_TS_PARALLEL;
> > >> +
> > >> +	memset(&client_info, 0, sizeof(struct i2c_board_info));
> > >> +	strlcpy(client_info.type, "si2168", I2C_NAME_SIZE);
> > >> +	client_info.addr = 0x64;
> > >> +	client_info.platform_data = &si2168_config;
> > >> +
> > >> +	client_demod = smi_add_i2c_client(i2c, &client_info);
> > >> +	if (!client_demod) {
> > >> +		ret = -ENODEV;
> > >> +		return ret;
> > >> +	}
> > >> +	port->i2c_client_demod = client_demod;
> > >> +
> > >> +	/* attach tuner */
> > >> +	memset(&si2157_config, 0, sizeof(si2157_config));
> > >> +	si2157_config.fe = port->fe;
> > >> +
> > >> +	memset(&client_info, 0, sizeof(struct i2c_board_info));
> > >> +	strlcpy(client_info.type, "si2157", I2C_NAME_SIZE);
> > >> +	client_info.addr = 0x60;
> > >> +	client_info.platform_data = &si2157_config;
> > >> +
> > >> +	client_tuner = smi_add_i2c_client(tuner_i2c_adapter, &client_info);
> > >> +	if (!client_tuner) {
> > >> +		smi_del_i2c_client(port->i2c_client_demod);
> > >> +		port->i2c_client_demod = NULL;
> > >> +		ret = -ENODEV;
> > >> +		return ret;
> > >> +	}
> > >> +	port->i2c_client_tuner = client_tuner;
> > >> +	return ret;
> > >> +}
> > >> +
> > >>   static int smi_fe_init(struct smi_port *port)
> > >>   {
> > >>   	int ret = 0;
> > >> @@ -635,6 +689,9 @@ static int smi_fe_init(struct smi_port *port)
> > >>   	case DVBSKY_FE_M88RS6000:
> > >>   		ret = smi_dvbsky_m88rs6000_fe_attach(port);
> > >>   		break;
> > >> +	case DVBSKY_FE_SIT2:
> > >> +		ret = smi_dvbsky_sit2_fe_attach(port);
> > >> +		break;
> > >>   	}
> > >>   	if (ret < 0)
> > >>   		return ret;
> > >> @@ -1005,6 +1062,15 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
> > >>   	.fe_1 = DVBSKY_FE_M88RS6000,
> > >>   };
> > >>
> > >> +static struct smi_cfg_info dvbsky_t9580_cfg = {
> > >> +	.type = SMI_DVBSKY_T9580,
> > >> +	.name = "DVBSky T9580 V3",
> > >> +	.ts_0 = SMI_TS_DMA_BOTH,
> > >> +	.ts_1 = SMI_TS_DMA_BOTH,
> > >> +	.fe_0 = DVBSKY_FE_SIT2,
> > >> +	.fe_1 = DVBSKY_FE_M88DS3103,
> > >> +};
> > >> +
> > >>   /* PCI IDs */
> > >>   #define SMI_ID(_subvend, _subdev, _driverdata) {	\
> > >>   	.vendor      = SMI_VID,    .device    = SMI_PID, \
> > >> @@ -1014,6 +1080,7 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
> > >>   static const struct pci_device_id smi_id_table[] = {
> > >>   	SMI_ID(0x4254, 0x0550, dvbsky_s950_cfg),
> > >>   	SMI_ID(0x4254, 0x0552, dvbsky_s952_cfg),
> > >> +	SMI_ID(0x4254, 0x5580, dvbsky_t9580_cfg),
> > >>   	{0}
> > >>   };
> > >>   MODULE_DEVICE_TABLE(pci, smi_id_table);
> > >>
> > >>
> > >
> > >-- 
> > >http://palosaari.fi/
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
