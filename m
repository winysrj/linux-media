Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E61C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F52217D9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550510708;
	bh=T3O5RoI4XU3Hm9tO4/kBRWUrTnxwrCZ4m1KinX5hL9c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=bzxddPDf8jt4sz2ObeEwNeB5ge8mPama9JatXAAJSHsM791/l7vqQbTH53wkr+SMT
	 dN1d7E3z546eQOCpOG0qN0y8DQByhFgMNclgrJ6Wq7aN04mryAV8ZeqL+oIdp1MbAK
	 UT5A4Gt3WTX5NPzXkyosWGsVWou/FF81izk603VY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfBRRZH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:25:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730917AbfBRRZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 12:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9qPy5Z+I/S1HwPrkMc0DMZJx4nmYZgmIjO1RDADtBIE=; b=Wx61aiRk16Coc23men6RM5DaP
        +3ETF8m1S/RTvdUKeDvbOsI9x/ymObPjBTmCovZMjOlw7mzHlakrQh3UsQF1btcy47J/tzu7zuL96
        5kIpBFD1DzZl0yUUfQ0O+UY4f4r6/mwqw6RieYytQr/tLcDKIVRQAU/mhWP4Rs2682IMTDo7rKzIG
        9pBSXsY48jh759CxG18Xty+hFULawYTXtr64zf0jVzQDi6VxyUMzeQywqSyZuqM5nEwOwyg41MJiX
        QlIsO/x5LDhafP2gPC++3ABWMkX3BVuwc54WukGdaL7deEhksliT8d/qrmBAMDRAiVCN2CvMZRmUu
        9AT/SPLlQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvmfB-0007WL-V8; Mon, 18 Feb 2019 17:25:06 +0000
Date:   Mon, 18 Feb 2019 14:25:02 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Patrick Lerda <patrick9876@free.fr>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH v1] media: smipcie: add universal ir capability
Message-ID: <20190218142502.6b88ff44@coco.lan>
In-Reply-To: <37c04d1856a495f93d7c0772a66b0b3e285d98d7.1548287716.git.patrick9876@free.fr>
References: <37c04d1856a495f93d7c0772a66b0b3e285d98d7.1548287716.git.patrick9876@free.fr>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 24 Jan 2019 01:04:20 +0100
Patrick Lerda <patrick9876@free.fr> escreveu:

> smipcie: switch to RC_DRIVER_IR_RAW.
> 
> Signed-off-by: Patrick Lerda <patrick9876@free.fr>
> ---
>  drivers/media/pci/smipcie/smipcie-ir.c | 133 +++++++++----------------
>  drivers/media/pci/smipcie/smipcie.h    |   1 -
>  2 files changed, 46 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
> index c5595af6b976..ab47954b8bf1 100644
> --- a/drivers/media/pci/smipcie/smipcie-ir.c
> +++ b/drivers/media/pci/smipcie/smipcie-ir.c
> @@ -16,6 +16,9 @@
>  
>  #include "smipcie.h"
>  
> +#define SMI_SAMPLE_PERIOD 83
> +#define SMI_SAMPLE_IDLEMIN (10000 / SMI_SAMPLE_PERIOD)
> +
>  static void smi_ir_enableInterrupt(struct smi_rc *ir)
>  {
>  	struct smi_dev *dev = ir->dev;
> @@ -42,114 +45,64 @@ static void smi_ir_stop(struct smi_rc *ir)
>  	struct smi_dev *dev = ir->dev;
>  
>  	smi_ir_disableInterrupt(ir);
> -	smi_clear(IR_Init_Reg, 0x80);
> +	smi_clear(IR_Init_Reg, rbIRen);
>  }
>  
> -#define BITS_PER_COMMAND 14
> -#define GROUPS_PER_BIT 2
> -#define IR_RC5_MIN_BIT 36
> -#define IR_RC5_MAX_BIT 52
> -static u32 smi_decode_rc5(u8 *pData, u8 size)
> +static void smi_raw_process(struct rc_dev *rc_dev, const u8 *buffer,
> +			const u8 length)
>  {
> -	u8 index, current_bit, bit_count;
> -	u8 group_array[BITS_PER_COMMAND * GROUPS_PER_BIT + 4];
> -	u8 group_index = 0;
> -	u32 command = 0xFFFFFFFF;
> -
> -	group_array[group_index++] = 1;
> -
> -	for (index = 0; index < size; index++) {
> -
> -		current_bit = (pData[index] & 0x80) ? 1 : 0;
> -		bit_count = pData[index] & 0x7f;
> -
> -		if ((current_bit == 1) && (bit_count >= 2*IR_RC5_MAX_BIT + 1)) {
> -			goto process_code;
> -		} else if ((bit_count >= IR_RC5_MIN_BIT) &&
> -			   (bit_count <= IR_RC5_MAX_BIT)) {
> -				group_array[group_index++] = current_bit;
> -		} else if ((bit_count > IR_RC5_MAX_BIT) &&
> -			   (bit_count <= 2*IR_RC5_MAX_BIT)) {
> -				group_array[group_index++] = current_bit;
> -				group_array[group_index++] = current_bit;
> -		} else {
> -			goto invalid_timing;
> -		}
> -		if (group_index >= BITS_PER_COMMAND*GROUPS_PER_BIT)
> -			goto process_code;
> -
> -		if ((group_index == BITS_PER_COMMAND*GROUPS_PER_BIT - 1)
> -		    && (group_array[group_index-1] == 0)) {
> -			group_array[group_index++] = 1;
> -			goto process_code;
> -		}
> -	}
> -
> -process_code:
> -	if (group_index == (BITS_PER_COMMAND*GROUPS_PER_BIT-1))
> -		group_array[group_index++] = 1;
> -
> -	if (group_index == BITS_PER_COMMAND*GROUPS_PER_BIT) {
> -		command = 0;
> -		for (index = 0; index < (BITS_PER_COMMAND*GROUPS_PER_BIT);
> -		     index = index + 2) {
> -			if ((group_array[index] == 1) &&
> -			    (group_array[index+1] == 0)) {
> -				command |= (1 << (BITS_PER_COMMAND -
> -						   (index/2) - 1));
> -			} else if ((group_array[index] == 0) &&
> -				   (group_array[index+1] == 1)) {
> -				/* */
> -			} else {
> -				command = 0xFFFFFFFF;
> -				goto invalid_timing;
> -			}
> +	struct ir_raw_event rawir = {};
> +	int cnt;
> +
> +	for (cnt = 0; cnt < length; cnt++) {
> +		if (buffer[cnt] & 0x7f) {
> +			rawir.pulse = (buffer[cnt] & 0x80) == 0;
> +			rawir.duration = ((buffer[cnt] & 0x7f) +
> +					 (rawir.pulse ? 0 : -1)) *
> +					 rc_dev->rx_resolution;
> +			ir_raw_event_store_with_filter(rc_dev, &rawir);
>  		}
>  	}
> -
> -invalid_timing:
> -	return command;
>  }
>  
> -static void smi_ir_decode(struct work_struct *work)
> +static void smi_ir_decode(struct smi_rc *ir)
>  {
> -	struct smi_rc *ir = container_of(work, struct smi_rc, work);
>  	struct smi_dev *dev = ir->dev;
>  	struct rc_dev *rc_dev = ir->rc_dev;
> -	u32 dwIRControl, dwIRData, dwIRCode, scancode;
> -	u8 index, ucIRCount, readLoop, rc5_command, rc5_system, toggle;
> +	u32 dwIRControl, dwIRData;
> +	u8 index, ucIRCount, readLoop;
>  
>  	dwIRControl = smi_read(IR_Init_Reg);
> +
>  	if (dwIRControl & rbIRVld) {
>  		ucIRCount = (u8) smi_read(IR_Data_Cnt);
>  
> -		if (ucIRCount < 4)
> -			goto end_ir_decode;
> -
>  		readLoop = ucIRCount/4;
>  		if (ucIRCount % 4)
>  			readLoop += 1;
>  		for (index = 0; index < readLoop; index++) {
> -			dwIRData = smi_read(IR_DATA_BUFFER_BASE + (index*4));
> +			dwIRData = smi_read(IR_DATA_BUFFER_BASE + (index * 4));
>  
>  			ir->irData[index*4 + 0] = (u8)(dwIRData);
>  			ir->irData[index*4 + 1] = (u8)(dwIRData >> 8);
>  			ir->irData[index*4 + 2] = (u8)(dwIRData >> 16);
>  			ir->irData[index*4 + 3] = (u8)(dwIRData >> 24);
>  		}
> -		dwIRCode = smi_decode_rc5(ir->irData, ucIRCount);
> -
> -		if (dwIRCode != 0xFFFFFFFF) {
> -			rc5_command = dwIRCode & 0x3F;
> -			rc5_system = (dwIRCode & 0x7C0) >> 6;
> -			toggle = (dwIRCode & 0x800) ? 1 : 0;
> -			scancode = rc5_system << 8 | rc5_command;
> -			rc_keydown(rc_dev, RC_PROTO_RC5, scancode, toggle);
> -		}
> +		smi_raw_process(rc_dev, ir->irData, ucIRCount);
> +		smi_set(IR_Init_Reg, rbIRVld);
>  	}
> -end_ir_decode:
> -	smi_set(IR_Init_Reg, 0x04);
> -	smi_ir_enableInterrupt(ir);
> +
> +	if (dwIRControl & rbIRhighidle) {
> +		struct ir_raw_event rawir = {};
> +
> +		rawir.pulse = 0;
> +		rawir.duration = US_TO_NS(SMI_SAMPLE_PERIOD *
> +					  SMI_SAMPLE_IDLEMIN);
> +		ir_raw_event_store_with_filter(rc_dev, &rawir);
> +		smi_set(IR_Init_Reg, rbIRhighidle);
> +	}
> +
> +	ir_raw_event_handle(rc_dev);
>  }
>  
>  /* ir functions call by main driver.*/
> @@ -160,7 +113,8 @@ int smi_ir_irq(struct smi_rc *ir, u32 int_status)
>  	if (int_status & IR_X_INT) {
>  		smi_ir_disableInterrupt(ir);
>  		smi_ir_clearInterrupt(ir);
> -		schedule_work(&ir->work);
> +		smi_ir_decode(ir);
> +		smi_ir_enableInterrupt(ir);
>  		handled = 1;
>  	}
>  	return handled;
> @@ -170,9 +124,11 @@ void smi_ir_start(struct smi_rc *ir)
>  {
>  	struct smi_dev *dev = ir->dev;
>  
> -	smi_write(IR_Idle_Cnt_Low, 0x00140070);
> +	smi_write(IR_Idle_Cnt_Low,
> +		  (((SMI_SAMPLE_PERIOD - 1) & 0xFFFF) << 16) |
> +		  (SMI_SAMPLE_IDLEMIN & 0xFFFF));
>  	msleep(20);
> -	smi_set(IR_Init_Reg, 0x90);
> +	smi_set(IR_Init_Reg, rbIRen | rbIRhighidle);
>  
>  	smi_ir_enableInterrupt(ir);
>  }
> @@ -183,7 +139,7 @@ int smi_ir_init(struct smi_dev *dev)
>  	struct rc_dev *rc_dev;
>  	struct smi_rc *ir = &dev->ir;
>  
> -	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
> +	rc_dev = rc_allocate_device(RC_DRIVER_IR_RAW);
>  	if (!rc_dev)
>  		return -ENOMEM;
>  
> @@ -193,6 +149,8 @@ int smi_ir_init(struct smi_dev *dev)
>  	snprintf(ir->input_phys, sizeof(ir->input_phys), "pci-%s/ir0",
>  		 pci_name(dev->pci_dev));
>  
> +	rc_dev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> +	rc_dev->allowed_wakeup_protocols = RC_PROTO_BIT_ALL_IR_ENCODER;
>  	rc_dev->driver_name = "SMI_PCIe";
>  	rc_dev->input_phys = ir->input_phys;
>  	rc_dev->device_name = ir->device_name;
> @@ -203,11 +161,12 @@ int smi_ir_init(struct smi_dev *dev)
>  	rc_dev->dev.parent = &dev->pci_dev->dev;
>  
>  	rc_dev->map_name = dev->info->rc_map;
> +	rc_dev->timeout = MS_TO_NS(100);
> +	rc_dev->rx_resolution = US_TO_NS(SMI_SAMPLE_PERIOD);
>  
>  	ir->rc_dev = rc_dev;
>  	ir->dev = dev;
>  
> -	INIT_WORK(&ir->work, smi_ir_decode);
>  	smi_ir_disableInterrupt(ir);
>  
>  	ret = rc_register_device(rc_dev);
> diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
> index a6c5b1bd7edb..e52229a87b84 100644
> --- a/drivers/media/pci/smipcie/smipcie.h
> +++ b/drivers/media/pci/smipcie/smipcie.h
> @@ -241,7 +241,6 @@ struct smi_rc {
>  	struct rc_dev *rc_dev;
>  	char input_phys[64];
>  	char device_name[64];
> -	struct work_struct work;
>  	u8 irData[256];
>  
>  	int users;

Any reason why it should use camelcase?

CHECK: Avoid CamelCase: <IR_Init_Reg>
#36: FILE: drivers/media/pci/smipcie/smipcie-ir.c:48:
+	smi_clear(IR_Init_Reg, rbIRen);

CHECK: Avoid CamelCase: <rbIRen>
#36: FILE: drivers/media/pci/smipcie/smipcie-ir.c:48:
+	smi_clear(IR_Init_Reg, rbIRen);

CHECK: Avoid CamelCase: <dwIRData>
#125: FILE: drivers/media/pci/smipcie/smipcie-ir.c:72:
+	u32 dwIRControl, dwIRData;

CHECK: Avoid CamelCase: <ucIRCount>
#126: FILE: drivers/media/pci/smipcie/smipcie-ir.c:73:
+	u8 index, ucIRCount, readLoop;

CHECK: Avoid CamelCase: <readLoop>
#126: FILE: drivers/media/pci/smipcie/smipcie-ir.c:73:
+	u8 index, ucIRCount, readLoop;

CHECK: Avoid CamelCase: <irData>
#157: FILE: drivers/media/pci/smipcie/smipcie-ir.c:91:
+		smi_raw_process(rc_dev, ir->irData, ucIRCount);

CHECK: Avoid CamelCase: <rbIRVld>
#158: FILE: drivers/media/pci/smipcie/smipcie-ir.c:92:
+		smi_set(IR_Init_Reg, rbIRVld);

CHECK: Avoid CamelCase: <rbIRhighidle>
#164: FILE: drivers/media/pci/smipcie/smipcie-ir.c:95:
+	if (dwIRControl & rbIRhighidle) {

CHECK: Avoid CamelCase: <IR_Idle_Cnt_Low>
#193: FILE: drivers/media/pci/smipcie/smipcie-ir.c:127:
+	smi_write(IR_Idle_Cnt_Low,




Thanks,
Mauro
