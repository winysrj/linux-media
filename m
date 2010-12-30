Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:32497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0L3Nak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:30:40 -0500
Message-ID: <4D1C8972.4050907@redhat.com>
Date: Thu, 30 Dec 2010 11:30:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
References: <cover.1293709356.git.mchehab@redhat.com>	 <20101230094509.2ecbf089@gaivota> <1293712568.2056.25.camel@morgan.silverblock.net>
In-Reply-To: <1293712568.2056.25.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 30-12-2010 10:36, Andy Walls escreveu:
> On Thu, 2010-12-30 at 09:45 -0200, Mauro Carvalho Chehab wrote:
>> lirc-i2c implements a get key logic for the Adaptec Remote
>> Controller, at address 0x6b. The only driver that seems to have
>> an Adaptec device is ivtv:
>>
>> $ git grep -i adaptec drivers/media
>> drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
>> drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
>> drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
>> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
>> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
>> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
>> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
>> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
>> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
>> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
>> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
>> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
>> drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
>>
>> There are two Adaptec cards defined there, but only one has tuner.
>> I never found any device without tuners, but with a remote controllers, so
>> the logic at lirc_i2c seems to be for Adaptec AVC-2410.
>>
>> As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
>> use it for AVC2410.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Mauro,
> 
> This patch is missing a few things, so it won't work.
> The required - and some desired - changes are in the comments below.
> 
> 
>> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
>> index 6817092..8d1b016 100644
>> --- a/drivers/media/video/ivtv/ivtv-i2c.c
>> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
>> @@ -94,6 +94,7 @@
>>  #define IVTV_HAUP_INT_IR_RX_I2C_ADDR 	0x18
>>  #define IVTV_Z8F0811_IR_TX_I2C_ADDR	0x70
>>  #define IVTV_Z8F0811_IR_RX_I2C_ADDR	0x71
>> +#define IVTV_ADAPTEC_IR			0x6b
> 
> For consistency with the other defines for I2C addresses, please rename
> this to "IVTV_ADAPTEC_IR_I2C_ADDR"
> 
> 
>>  /* This array should match the IVTV_HW_ defines */
>>  static const u8 hw_addrs[] = {
>> @@ -118,6 +119,7 @@ static const u8 hw_addrs[] = {
>>  	IVTV_HAUP_INT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_INT */
>>  	IVTV_Z8F0811_IR_TX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
>>  	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
>> +	IVTV_ADAPTEC_IR,
>>  };
> 
> Please add this comment to the right of the new entry: /* IVTV_HW_I2C_IR_RX_ADAPTEC */
> 
> 
> You will need to add in ivtv-cards.h:
> 
> #define IVTV_HW_I2C_IR_RX_ADAPTEC         (1 << 21)
> 
> and modify this define in ivtv-cards.h
> 
> #define IVTV_HW_IR_RX_ANY (IVTV_HW_I2C_IR_RX_AVER | \
>                            IVTV_HW_I2C_IR_RX_HAUP_EXT | \
>                            IVTV_HW_I2C_IR_RX_HAUP_INT | \
>                            IVTV_HW_Z8F0811_IR_RX_HAUP | \
> 			   IVTV_HW_I2C_IR_RX_ADAPTEC)
> 
> In ivtv-cards.c, for the "ivtv_card_avc2410" entry, you must modify the
> ".hw_all" to be:
> 
>         .hw_all = IVTV_HW_MSP34XX | IVTV_HW_CS53L32A |
>                   IVTV_HW_SAA7115 | IVTV_HW_TUNER |
> 		  IVTV_HW_I2C_IR_RX_ADAPTEC,
> 
> 
>>  /* This array should match the IVTV_HW_ defines */
>> @@ -145,6 +147,31 @@ static const char * const hw_devicenames[] = {
>>  	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
>>  };
> 
> To avoid walking off the end of "hw_devicenames[]", you will need to add
> a new entry to the end of "hw_devicenames[]":
> 
> 	"ir_video",	/* IVTV_HW_I2C_IR_RX_ADAPTEC */
> 
>> +static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>> +{
>> +	unsigned char keybuf[4];
>> +
>> +	keybuf[0] = 0x00;
>> +	i2c_master_send(ir->c, keybuf, 1);
>> +	/* poll IR chip */
>> +	if (i2c_master_recv(ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
>> +		return 0;
>> +	}
>> +
>> +	/* key pressed ? */
>> +	if (keybuf[2] == 0xff)
>> +		return 0;
>> +
>> +	/* remove repeat bit */
>> +	keybuf[2] &= 0x7f;
>> +	keybuf[3] |= 0x80;
>> +
>> +	*ir_key = (u32) keybuf;
>> +	*ir_raw = (u32) keybuf;
>> +
>> +	return 1;
>> +}
>> +
>>  static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>>  {
>>  	struct i2c_board_info info;
>> @@ -190,6 +217,12 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>>  		init_data->type = RC_TYPE_RC5;
>>  		init_data->name = itv->card_name;
>>  		break;
>> +	case IVTV_CARD_AVC2410:
> 
> You are switching on a value from a different set.  Instead use:
> 
> 	case IVTV_HW_I2C_IR_RX_ADAPTEC:
> 
> 
>> +		init_data->ir_codes = RC_MAP_EMPTY;
>> +		init_data->get_key = get_key_adaptec;
>> +		init_data->type = RC_TYPE_UNKNOWN;
>> +		init_data->name = itv->card_name;
>> +		break;
> 
> Please add a /*FIXME */ comment here, so that I will remember to figure
> out the default keymap and RC protocol type. 
> 
> Regards,
> Andy

Thanks for the review. Version 3 of the patch enclosed.

commit 8576bd14361ec75c91ddfb49cc2df389143cf06a
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Dec 30 09:31:10 2010 -0200

    [media] ivtv: Add Adaptec Remote Controller
    
    lirc-i2c implements a get key logic for the Adaptec Remote
    Controller, at address 0x6b. The only driver that seems to have
    an Adaptec device is ivtv:
    
    $ git grep -i adaptec drivers/media
    drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
    drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
    drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
    drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
    drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
    drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
    drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
    drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
    drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
    drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
    drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
    drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
    drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
    
    There are two Adaptec cards defined there, but AVC-2010 doesn't have a
    remote controller. So, the logic at lirc_i2c seems to be for Adaptec AVC-2410.
    
    As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
    use it for AVC-2410.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/ivtv/ivtv-cards.c
index b6f2a2b..145e474 100644
--- a/drivers/media/video/ivtv/ivtv-cards.c
+++ b/drivers/media/video/ivtv/ivtv-cards.c
@@ -405,7 +405,8 @@ static const struct ivtv_card ivtv_card_avc2410 = {
 	.hw_audio_ctrl = IVTV_HW_MSP34XX,
 	.hw_muxer = IVTV_HW_CS53L32A,
 	.hw_all = IVTV_HW_MSP34XX | IVTV_HW_CS53L32A |
-		  IVTV_HW_SAA7115 | IVTV_HW_TUNER,
+		  IVTV_HW_SAA7115 | IVTV_HW_TUNER |
+		  IVTV_HW_I2C_IR_RX_ADAPTEC,
 	.video_inputs = {
 		{ IVTV_CARD_INPUT_VID_TUNER,  0, IVTV_SAA71XX_COMPOSITE4 },
 		{ IVTV_CARD_INPUT_SVIDEO1,    1, IVTV_SAA71XX_SVIDEO0    },
diff --git a/drivers/media/video/ivtv/ivtv-cards.h b/drivers/media/video/ivtv/ivtv-cards.h
index 78eca99..e6f5c02 100644
--- a/drivers/media/video/ivtv/ivtv-cards.h
+++ b/drivers/media/video/ivtv/ivtv-cards.h
@@ -111,6 +111,7 @@
 #define IVTV_HW_I2C_IR_RX_HAUP_INT	(1 << 18)
 #define IVTV_HW_Z8F0811_IR_TX_HAUP	(1 << 19)
 #define IVTV_HW_Z8F0811_IR_RX_HAUP	(1 << 20)
+#define IVTV_HW_I2C_IR_RX_ADAPTEC	(1 << 21)
 
 #define IVTV_HW_Z8F0811_IR_HAUP	(IVTV_HW_Z8F0811_IR_RX_HAUP | \
 				 IVTV_HW_Z8F0811_IR_TX_HAUP)
@@ -120,7 +121,8 @@
 #define IVTV_HW_IR_RX_ANY (IVTV_HW_I2C_IR_RX_AVER | \
 			   IVTV_HW_I2C_IR_RX_HAUP_EXT | \
 			   IVTV_HW_I2C_IR_RX_HAUP_INT | \
-			   IVTV_HW_Z8F0811_IR_RX_HAUP)
+			   IVTV_HW_Z8F0811_IR_RX_HAUP | \
+			   IVTV_HW_I2C_IR_RX_ADAPTEC)
 
 #define IVTV_HW_IR_TX_ANY (IVTV_HW_Z8F0811_IR_TX_HAUP)
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 6817092..fb0ac68 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -94,6 +94,7 @@
 #define IVTV_HAUP_INT_IR_RX_I2C_ADDR 	0x18
 #define IVTV_Z8F0811_IR_TX_I2C_ADDR	0x70
 #define IVTV_Z8F0811_IR_RX_I2C_ADDR	0x71
+#define IVTV_ADAPTEC_IR_ADDR		0x6b
 
 /* This array should match the IVTV_HW_ defines */
 static const u8 hw_addrs[] = {
@@ -118,6 +119,7 @@ static const u8 hw_addrs[] = {
 	IVTV_HAUP_INT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_INT */
 	IVTV_Z8F0811_IR_TX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
 	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	IVTV_ADAPTEC_IR_ADDR,		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
 /* This array should match the IVTV_HW_ defines */
@@ -143,8 +145,34 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
 	"ir_tx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
 	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	"ir_adaptec",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
+static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	unsigned char keybuf[4];
+
+	keybuf[0] = 0x00;
+	i2c_master_send(ir->c, keybuf, 1);
+	/* poll IR chip */
+	if (i2c_master_recv(ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
+		return 0;
+	}
+
+	/* key pressed ? */
+	if (keybuf[2] == 0xff)
+		return 0;
+
+	/* remove repeat bit */
+	keybuf[2] &= 0x7f;
+	keybuf[3] |= 0x80;
+
+	*ir_key = (u32) keybuf;
+	*ir_raw = (u32) keybuf;
+
+	return 1;
+}
+
 static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 {
 	struct i2c_board_info info;
@@ -190,6 +218,13 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
+	case IVTV_HW_I2C_IR_RX_ADAPTEC:
+		init_data->get_key = get_key_adaptec;
+		init_data->name = itv->card_name;
+		/* FIXME: The protocol and RC_MAP needs to be corrected */
+		init_data->ir_codes = RC_MAP_EMPTY;
+		init_data->type = RC_TYPE_UNKNOWN;
+		break;
 	}
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
@@ -219,7 +254,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
 		0x1a,	/* Hauppauge IR external - collides with WM8739 */
 		0x18,	/* Hauppauge IR internal */
 		0x71,	/* Hauppauge IR (PVR150) */
-		0x6b,	/* Adaptec IR */
 		I2C_CLIENT_END
 	};
 
