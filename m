Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40775 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671Ab1BOR0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 12:26:18 -0500
References: <cover.1297776328.git.mchehab@redhat.com> <20110215113334.49ead2c2@pedra>
In-Reply-To: <20110215113334.49ead2c2@pedra>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] [media] tuner-core: remove usage of DIGITAL_TV
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 15 Feb 2011 12:25:57 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <a0597677-0cba-48b0-97e6-df1fa46464b7@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>tuner-core has no business to do with digital TV. So, don't use
>T_DIGITAL_TV on it, as it has no code to distinguish between
>them, and nobody fills T_DIGITAL_TV right.
>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>diff --git a/drivers/media/video/au0828/au0828-cards.c
>b/drivers/media/video/au0828/au0828-cards.c
>index 01be89f..39fc923 100644
>--- a/drivers/media/video/au0828/au0828-cards.c
>+++ b/drivers/media/video/au0828/au0828-cards.c
>@@ -185,8 +185,7 @@ void au0828_card_setup(struct au0828_dev *dev)
> 	static u8 eeprom[256];
> 	struct tuner_setup tun_setup;
> 	struct v4l2_subdev *sd;
>-	unsigned int mode_mask = T_ANALOG_TV |
>-				 T_DIGITAL_TV;
>+	unsigned int mode_mask = T_ANALOG_TV;
> 
> 	dprintk(1, "%s()\n", __func__);
> 
>diff --git a/drivers/media/video/bt8xx/bttv-cards.c
>b/drivers/media/video/bt8xx/bttv-cards.c
>index 7f58756..242f0d5 100644
>--- a/drivers/media/video/bt8xx/bttv-cards.c
>+++ b/drivers/media/video/bt8xx/bttv-cards.c
>@@ -3616,7 +3616,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
> 				&btv->c.i2c_adap, "tuner",
> 				0, v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
> 
>-		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
>+		tun_setup.mode_mask = T_ANALOG_TV;
> 		tun_setup.type = btv->tuner_type;
> 		tun_setup.addr = addr;
> 
>diff --git a/drivers/media/video/cx88/cx88-cards.c
>b/drivers/media/video/cx88/cx88-cards.c
>index 4e6ee55..8128b93 100644
>--- a/drivers/media/video/cx88/cx88-cards.c
>+++ b/drivers/media/video/cx88/cx88-cards.c
>@@ -3165,9 +3165,7 @@ static void cx88_card_setup(struct cx88_core
>*core)
> {
> 	static u8 eeprom[256];
> 	struct tuner_setup tun_setup;
>-	unsigned int mode_mask = T_RADIO     |
>-				 T_ANALOG_TV |
>-				 T_DIGITAL_TV;
>+	unsigned int mode_mask = T_RADIO | T_ANALOG_TV;
> 
> 	memset(&tun_setup, 0, sizeof(tun_setup));
> 
>diff --git a/drivers/media/video/saa7134/saa7134-cards.c
>b/drivers/media/video/saa7134/saa7134-cards.c
>index 74467c1..61c6007 100644
>--- a/drivers/media/video/saa7134/saa7134-cards.c
>+++ b/drivers/media/video/saa7134/saa7134-cards.c
>@@ -7333,9 +7333,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
> static void saa7134_tuner_setup(struct saa7134_dev *dev)
> {
> 	struct tuner_setup tun_setup;
>-	unsigned int mode_mask = T_RADIO     |
>-				 T_ANALOG_TV |
>-				 T_DIGITAL_TV;
>+	unsigned int mode_mask = T_RADIO | T_ANALOG_TV;
> 
> 	memset(&tun_setup, 0, sizeof(tun_setup));
> 	tun_setup.tuner_callback = saa7134_tuner_callback;
>diff --git a/drivers/media/video/tuner-core.c
>b/drivers/media/video/tuner-core.c
>index dcf03fa..5e1437c 100644
>--- a/drivers/media/video/tuner-core.c
>+++ b/drivers/media/video/tuner-core.c
>@@ -497,7 +497,7 @@ static void tuner_lookup(struct i2c_adapter *adap,
> 		   device. If other devices appear then we need to
> 		   make this test more general. */
> 		else if (*tv == NULL && pos->type != TUNER_TDA9887 &&
>-			 (pos->mode_mask & (T_ANALOG_TV | T_DIGITAL_TV)))
>+			 (pos->mode_mask & T_ANALOG_TV))
> 			*tv = pos;
> 	}
> }
>@@ -565,8 +565,7 @@ static int tuner_probe(struct i2c_client *client,
> 			} else {
> 				/* Default is being tda9887 */
> 				t->type = TUNER_TDA9887;
>-				t->mode_mask = T_RADIO | T_ANALOG_TV |
>-					       T_DIGITAL_TV;
>+				t->mode_mask = T_RADIO | T_ANALOG_TV;
> 				goto register_client;
> 			}
> 			break;
>@@ -596,7 +595,7 @@ static int tuner_probe(struct i2c_client *client,
> 	   first found TV tuner. */
> 	tuner_lookup(t->i2c->adapter, &radio, &tv);
> 	if (tv == NULL) {
>-		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
>+		t->mode_mask = T_ANALOG_TV;
> 		if (radio == NULL)
> 			t->mode_mask |= T_RADIO;
> 		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
>@@ -607,18 +606,15 @@ register_client:
> 	/* Sets a default mode */
> 	if (t->mode_mask & T_ANALOG_TV)
> 		t->mode = V4L2_TUNER_ANALOG_TV;
>-	else if (t->mode_mask & T_RADIO)
>-		t->mode = V4L2_TUNER_RADIO;
> 	else
>-		t->mode = V4L2_TUNER_DIGITAL_TV;
>+		t->mode = V4L2_TUNER_RADIO;
> 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
> 	list_add_tail(&t->list, &tuner_list);
> 
>-	tuner_info("Tuner %d found with type(s)%s%s%s.\n",
>+	tuner_info("Tuner %d found with type(s)%s%s.\n",
> 		   t->type,
>-		   t->mode_mask & T_RADIO ? " radio" : "",
>-		   t->mode_mask & T_ANALOG_TV ? " TV" : "",
>-		   t->mode_mask & T_ANALOG_TV ? " DTV" : "");
>+		   t->mode_mask & T_RADIO ? " Radio" : "",
>+		   t->mode_mask & T_ANALOG_TV ? " TV" : "");
> 	return 0;
> }
> 
>-- 
>1.7.1
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hmm.  I thought tuner-cards.c or tuner-simple.c had entries for hybrid tuner assemblies.  You are changing the default mode from digital to radio; does that affect the use of the hybrid tuner assemblies.  

Regards,
Andy
(Not near a decent computer screen at the moment.)

