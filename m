Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd14724.kasserver.com ([85.13.136.38]:49078 "EHLO
	dd14724.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaGRIDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 04:03:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] ddbridge: Add IDs for several newer Digital Devices cards
From: "D. Herrendoerfer" <d.herrendoerfer@herrendoerfer.name>
In-Reply-To: <53B169A0.5010907@creimer.net>
Date: Fri, 18 Jul 2014 09:56:27 +0200
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0728DA26-FA9B-4C7B-92D3-4E9C7C6C2DDB@herrendoerfer.name>
References: <53B169A0.5010907@creimer.net>
To: Christopher Reimer <linux@creimer.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ACK, tested ok with CineS2 6.5 and Octopus V3. 

D.Herrendoerfer


On 30 Jun 2014, at 15:44, Christopher Reimer <linux@creimer.net> wrote:

> Hello,
> 
> it's the first time I try to contribute here. So please be gracious.
> 
> This patch adds the necessary IDs for the following dvb cards:
> 
> Digital Devices Octopus Mini
> Digital Devices Cine S2 V6.5
> Digital Devices DVBCT V6.1
> Digital Devices Octopus V3
> Mystique SaTiX-S2 V3
> 
> All these changes are taken from the official driver package by Digital Devices.
> http://download.digital-devices.de/download/linux/
> 
> Signed-off-by: Christopher Reimer <mail@creimer.net>
> 
> ---
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
> index fb52bda..da8f848 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> @@ -1663,11 +1663,40 @@ static struct ddb_info ddb_octopus_le = {
>     .port_num = 2,
> };
> 
> +static struct ddb_info ddb_octopus_mini = {
> +    .type     = DDB_OCTOPUS,
> +    .name     = "Digital Devices Octopus Mini",
> +    .port_num = 4,
> +};
> +
> static struct ddb_info ddb_v6 = {
>     .type     = DDB_OCTOPUS,
>     .name     = "Digital Devices Cine S2 V6 DVB adapter",
>     .port_num = 3,
> };
> +static struct ddb_info ddb_v6_5 = {
> +    .type     = DDB_OCTOPUS,
> +    .name     = "Digital Devices Cine S2 V6.5 DVB adapter",
> +    .port_num = 4,
> +};
> +
> +static struct ddb_info ddb_dvbct = {
> +    .type     = DDB_OCTOPUS,
> +    .name     = "Digital Devices DVBCT V6.1 DVB adapter",
> +    .port_num = 3,
> +};
> +
> +static struct ddb_info ddb_satixS2v3 = {
> +    .type     = DDB_OCTOPUS,
> +    .name     = "Mystique SaTiX-S2 V3 DVB adapter",
> +    .port_num = 3,
> +};
> +
> +static struct ddb_info ddb_octopusv3 = {
> +    .type     = DDB_OCTOPUS,
> +    .name     = "Digital Devices Octopus V3 DVB adapter",
> +    .port_num = 4,
> +};
> 
> #define DDVID 0xdd01 /* Digital Devices Vendor ID */
> 
> @@ -1680,8 +1709,12 @@ static const struct pci_device_id ddb_id_tbl[] = {
>     DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
>     DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
>     DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
> -    DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus),
> +    DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
>     DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
> +    DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
> +    DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
> +    DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
> +    DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
>     /* in case sub-ids got deleted in flash */
>     DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
>     {0}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

