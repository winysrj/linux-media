Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48692 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3GWCYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 22:24:41 -0400
Received: by mail-ie0-f173.google.com with SMTP id k13so17398579iea.32
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 19:24:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Jul 2013 20:24:41 -0600
Message-ID: <CAA9z4LbXV0pF+kUYueAdK-JySU--p5_RYzzbHwPefgktGPLdUw@mail.gmail.com>
Subject: [PATCH] gp8psk: tuning changes
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- cleanup tuning code
- fix tuning for some systems/modulations/fecs
- add Digicipher II and DSS tuning abilities
- update the property_cache once tuning succeeds with the actual tuned values
- implement gp8psk_fe_read_ber()
- update .delsys with the new systems

Its a pretty big patch, I can reduce it to smaller parts if you want,
I welcome comments & questions

Thanks

Signed-off-by: Chris Lee <updatelee@gmail.com>

--- media_tree/include/uapi/linux/dvb/frontend.h 2013-07-18
11:19:29.601746158 -0600
+++ media_tree.test/include/uapi/linux/dvb/frontend.h 2013-07-22
20:10:50.658719256 -0600
@@ -165,6 +165,7 @@
  FEC_3_5,
  FEC_9_10,
  FEC_2_5,
+ FEC_5_11,
 } fe_code_rate_t;


@@ -410,6 +411,10 @@
  SYS_DVBT2,
  SYS_TURBO,
  SYS_DVBC_ANNEX_C,
+ SYS_DCII_C_QPSK,
+ SYS_DCII_I_QPSK,
+ SYS_DCII_Q_QPSK,
+ SYS_DCII_C_OQPSK,
 } fe_delivery_system_t;

 /* backward compatibility */
--- media_tree/drivers/media/usb/dvb-usb/gp8psk.h 2013-07-18
11:19:28.261746125 -0600
+++ media_tree.test/drivers/media/usb/dvb-usb/gp8psk.h 2013-07-22
19:54:19.642694697 -0600
@@ -52,6 +52,8 @@
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
 #define GET_FPGA_VERS 0x95
+#define GET_SIGNAL_STAT 0x9A
+#define GET_BER_RATE 0x9B
 #define CW3K_INIT 0x9d

 /* PSK_configuration bits */
--- media_tree/drivers/media/usb/dvb-usb/gp8psk-fe.c 2013-07-18
11:19:28.261746125 -0600
+++ media_tree.test/drivers/media/usb/dvb-usb/gp8psk-fe.c 2013-07-22
20:10:20.582718511 -0600
@@ -45,7 +45,8 @@
  if (time_after(jiffies,st->next_status_check)) {
  gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0,0,&st->lock,1);
  gp8psk_usb_in_op(st->d, GET_SIGNAL_STRENGTH, 0,0,buf,6);
- st->snr = (buf[1]) << 8 | buf[0];
+
+ st->snr = ((buf[1]) << 8 | buf[0]) << 4;
  st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
  }
  return 0;
@@ -53,7 +54,42 @@

 static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 {
+ struct dtv_frontend_properties *c = &fe->dtv_property_cache;
  struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+ u8 buf[32];
+ int frequency;
+ int carrier_error;
+ int carrier_offset;
+ int rate_error;
+ int rate_offset;
+ int symbol_rate;
+
+ int fe_gp8psk_system_return[] = {
+ SYS_DVBS,
+ SYS_TURBO,
+ SYS_TURBO,
+ SYS_TURBO,
+ SYS_DCII_C_QPSK,
+ SYS_DCII_I_QPSK,
+ SYS_DCII_Q_QPSK,
+ SYS_DCII_C_OQPSK,
+ SYS_DSS,
+ SYS_UNDEFINED
+ };
+
+ int fe_gp8psk_modulation_return[] = {
+ QPSK,
+ QPSK,
+ PSK_8,
+ QAM_16,
+ QPSK,
+ QPSK,
+ QPSK,
+ QPSK,
+ QPSK,
+ };
+
  gp8psk_fe_update_status(st);

  if (st->lock)
@@ -61,18 +97,97 @@
  else
  *status = 0;

- if (*status & FE_HAS_LOCK)
+ if (*status & FE_HAS_LOCK) {
+ gp8psk_usb_in_op(st->d, GET_SIGNAL_STAT, 0, 0, buf, 32);
+ frequency = ((buf[11] << 24) + (buf[10] << 16) + (buf[9] << 8) +
buf[8]) / 1000;
+ carrier_error = ((buf[15] << 24) + (buf[14] << 16) + (buf[13] << 8)
+ buf[12]) / 1000;
+ carrier_offset =  (buf[19] << 24) + (buf[18] << 16) + (buf[17] << 8)
+ buf[16];
+ rate_error =  (buf[23] << 24) + (buf[22] << 16) + (buf[21] << 8) + buf[20];
+ rate_offset =  (buf[27] << 24) + (buf[26] << 16) + (buf[25] << 8) + buf[24];
+ symbol_rate =  (buf[31] << 24) + (buf[30] << 16) + (buf[29] << 8) + buf[28];
+
+ c->frequency = frequency - carrier_error;
+ c->symbol_rate = symbol_rate + rate_error;
+
+ switch (c->delivery_system) {
+ case SYS_DSS:
+ case SYS_DVBS:
+ c->delivery_system = fe_gp8psk_system_return[buf[1]];
+ c->modulation = fe_gp8psk_modulation_return[buf[1]];
+ switch (buf[2]) {
+ case 0:  c->fec_inner = FEC_1_2;  break;
+ case 1:  c->fec_inner = FEC_2_3;  break;
+ case 2:  c->fec_inner = FEC_3_4;  break;
+ case 3:  c->fec_inner = FEC_5_6;  break;
+ case 4:  c->fec_inner = FEC_6_7;  break;
+ case 5:  c->fec_inner = FEC_7_8;  break;
+ default: c->fec_inner = FEC_AUTO; break;
+ }
+ break;
+ case SYS_TURBO:
+ c->delivery_system = fe_gp8psk_system_return[buf[1]];
+ c->modulation = fe_gp8psk_modulation_return[buf[1]];
+ if (c->modulation == QPSK) {
+ switch (buf[2]) {
+ case 0:  c->fec_inner = FEC_7_8;  break;
+ case 1:  c->fec_inner = FEC_1_2;  break;
+ case 2:  c->fec_inner = FEC_3_4;  break;
+ case 3:  c->fec_inner = FEC_2_3;  break;
+ case 4:  c->fec_inner = FEC_5_6;  break;
+ default: c->fec_inner = FEC_AUTO; break;
+ }
+ } else {
+ switch (buf[2]) {
+ case 0:  c->fec_inner = FEC_2_3;  break;
+ case 1:  c->fec_inner = FEC_3_4;  break;
+ case 2:  c->fec_inner = FEC_3_4;  break;
+ case 3:  c->fec_inner = FEC_5_6;  break;
+ case 4:  c->fec_inner = FEC_8_9;  break;
+ default: c->fec_inner = FEC_AUTO; break;
+ }
+ }
+ break;
+ case SYS_DCII_C_QPSK:
+ case SYS_DCII_I_QPSK:
+ case SYS_DCII_Q_QPSK:
+ case SYS_DCII_C_OQPSK:
+ c->modulation = fe_gp8psk_modulation_return[buf[1]];
+ switch (buf[2]) {
+ case 0:  c->fec_inner = FEC_5_11; break;
+ case 1:  c->fec_inner = FEC_1_2;  break;
+ case 2:  c->fec_inner = FEC_3_5;  break;
+ case 3:  c->fec_inner = FEC_2_3;  break;
+ case 4:  c->fec_inner = FEC_3_4;  break;
+ case 5:  c->fec_inner = FEC_4_5;  break;
+ case 6:  c->fec_inner = FEC_5_6;  break;
+ case 7:  c->fec_inner = FEC_7_8;  break;
+ default: c->fec_inner = FEC_AUTO; break;
+ }
+ break;
+ default:
+ c->fec_inner = FEC_AUTO;
+ break;
+ }
+
  st->status_check_interval = 1000;
- else
+ } else {
  st->status_check_interval = 100;
+ }
  return 0;
 }

-/* not supported by this Frontend */
 static int gp8psk_fe_read_ber(struct dvb_frontend* fe, u32 *ber)
 {
- (void) fe;
- *ber = 0;
+ struct gp8psk_fe_state *st = fe->demodulator_priv;
+
+ u8 buf[4];
+
+ if (gp8psk_usb_in_op(st->d, GET_BER_RATE, 0, 0, buf, 4)) {
+ return -EINVAL;
+ }
+
+ *ber = (buf[3] << 24) + (buf[2] << 16) + (buf[1] << 8) + buf[0];
+
  return 0;
 }

@@ -121,93 +236,145 @@
  u32 freq = c->frequency * 1000;
  int gp_product_id = le16_to_cpu(state->d->udev->descriptor.idProduct);

- deb_fe("%s()\n", __func__);
+ info("%s() freq: %d, sr: %d", __func__, freq, c->symbol_rate);

+ cmd[0] =  c->symbol_rate        & 0xff;
+ cmd[1] = (c->symbol_rate >>  8) & 0xff;
+ cmd[2] = (c->symbol_rate >> 16) & 0xff;
+ cmd[3] = (c->symbol_rate >> 24) & 0xff;
  cmd[4] = freq         & 0xff;
  cmd[5] = (freq >> 8)  & 0xff;
  cmd[6] = (freq >> 16) & 0xff;
  cmd[7] = (freq >> 24) & 0xff;

- /* backwards compatibility: DVB-S + 8-PSK were used for Turbo-FEC */
- if (c->delivery_system == SYS_DVBS && c->modulation == PSK_8)
+ /* backwards compatibility: DVB-S2 used to be used for Turbo-FEC */
+ if (c->delivery_system == SYS_DVBS2)
  c->delivery_system = SYS_TURBO;

  switch (c->delivery_system) {
  case SYS_DVBS:
- if (c->modulation != QPSK) {
- deb_fe("%s: unsupported modulation selected (%d)\n",
+ info("%s: DVB-S delivery system selected w/fec %d", __func__, c->fec_inner);
+ c->fec_inner = FEC_AUTO;
+ cmd[8] = ADV_MOD_DVB_QPSK;
+ cmd[9] = 5;
+ break;
+ case SYS_TURBO:
+ info("%s: Turbo-FEC delivery system selected", __func__);
+ switch (c->modulation) {
+ case QPSK:
+ info("%s: modulation QPSK selected w/fec %d", __func__, c->fec_inner);
+ cmd[8] = ADV_MOD_TURBO_QPSK;
+ switch (c->fec_inner) {
+ case FEC_1_2: cmd[9] = 1; break;
+ case FEC_2_3: cmd[9] = 3; break;
+ case FEC_3_4: cmd[9] = 2; break;
+ case FEC_5_6: cmd[9] = 4; break;
+ default: cmd[9] = 0; break;
+ }
+ break;
+ case PSK_8:
+ info("%s: modulation 8PSK selected w/fec %d", __func__, c->fec_inner);
+ cmd[8] = ADV_MOD_TURBO_8PSK;
+ switch (c->fec_inner) {
+ case FEC_2_3: cmd[9] = 0; break;
+ case FEC_3_4: cmd[9] = 1; break;
+ case FEC_3_5: cmd[9] = 2; break;
+ case FEC_5_6: cmd[9] = 3; break;
+ case FEC_8_9: cmd[9] = 4; break;
+ default: cmd[9] = 0; break;
+ }
+ break;
+ case QAM_16: /* QAM_16 is for compatibility with DN */
+ info("%s: modulation QAM_16 selected w/fec %d", __func__, c->fec_inner);
+ cmd[8] = ADV_MOD_TURBO_16QAM;
+ cmd[9] = 0;
+ break;
+ default: /* Unknown modulation */
+ info("%s: unsupported modulation selected (%d)",
  __func__, c->modulation);
  return -EOPNOTSUPP;
  }
- c->fec_inner = FEC_AUTO;
  break;
- case SYS_DVBS2: /* kept for backwards compatibility */
- deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
+ case SYS_DSS:
+ info("%s: DSS delivery system selected w/fec %d", __func__, c->fec_inner);
+ cmd[8] = ADV_MOD_DSS_QPSK;
+ switch (c->fec_inner) {
+ case FEC_1_2: cmd[9] = 0; break;
+ case FEC_2_3: cmd[9] = 1; break;
+ case FEC_3_4: cmd[9] = 2; break;
+ case FEC_5_6: cmd[9] = 3; break;
+ case FEC_7_8: cmd[9] = 4; break;
+ case FEC_AUTO: cmd[9] = 5; break;
+ case FEC_6_7: cmd[9] = 6; break;
+ default: cmd[9] = 5; break;
+ }
  break;
- case SYS_TURBO:
- deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
+ case SYS_DCII_C_QPSK:
+ info("%s: DCII_C_QPSK delivery system selected w/fec %d", __func__,
c->fec_inner);
+ cmd[8] = ADV_MOD_DCII_C_QPSK;
+ switch (c->fec_inner) {
+ /* 5/11 FEC is cmd[9] = 0 but not added to the API */
+ case FEC_1_2:  cmd[9] = 1; break;
+ case FEC_3_5:  cmd[9] = 2; break;
+ case FEC_2_3:  cmd[9] = 3; break;
+ case FEC_3_4:  cmd[9] = 4; break;
+ case FEC_4_5:  cmd[9] = 5; break;
+ case FEC_5_6:  cmd[9] = 6; break;
+ case FEC_7_8:  cmd[9] = 7; break;
+ case FEC_AUTO: cmd[9] = 8; break;
+ default:       cmd[9] = 8; break;
+ }
  break;
-
- default:
- deb_fe("%s: unsupported delivery system selected (%d)\n",
- __func__, c->delivery_system);
- return -EOPNOTSUPP;
- }
-
- cmd[0] =  c->symbol_rate        & 0xff;
- cmd[1] = (c->symbol_rate >>  8) & 0xff;
- cmd[2] = (c->symbol_rate >> 16) & 0xff;
- cmd[3] = (c->symbol_rate >> 24) & 0xff;
- switch (c->modulation) {
- case QPSK:
- if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
- if (gp8psk_tuned_to_DCII(fe))
- gp8psk_bcm4500_reload(state->d);
+ case SYS_DCII_I_QPSK:
+ info("%s: DCII_I_QPSK delivery system selected w/fec %d", __func__, cmd[9]);
+ cmd[8] = ADV_MOD_DCII_I_QPSK;
  switch (c->fec_inner) {
- case FEC_1_2:
- cmd[9] = 0; break;
- case FEC_2_3:
- cmd[9] = 1; break;
- case FEC_3_4:
- cmd[9] = 2; break;
- case FEC_5_6:
- cmd[9] = 3; break;
- case FEC_7_8:
- cmd[9] = 4; break;
- case FEC_AUTO:
- cmd[9] = 5; break;
- default:
- cmd[9] = 5; break;
+ /* 5/11 FEC is cmd[9] = 0 but not added to the API */
+ case FEC_1_2:  cmd[9] = 1; break;
+ case FEC_3_5:  cmd[9] = 2; break;
+ case FEC_2_3:  cmd[9] = 3; break;
+ case FEC_3_4:  cmd[9] = 4; break;
+ case FEC_4_5:  cmd[9] = 5; break;
+ case FEC_5_6:  cmd[9] = 6; break;
+ case FEC_7_8:  cmd[9] = 7; break;
+ case FEC_AUTO: cmd[9] = 8; break;
+ default:       cmd[9] = 8; break;
  }
- if (c->delivery_system == SYS_TURBO)
- cmd[8] = ADV_MOD_TURBO_QPSK;
- else
- cmd[8] = ADV_MOD_DVB_QPSK;
  break;
- case PSK_8: /* PSK_8 is for compatibility with DN */
- cmd[8] = ADV_MOD_TURBO_8PSK;
+ case SYS_DCII_Q_QPSK:
+ info("%s: DCII_Q_QPSK delivery system selected w/fec %d", __func__, cmd[9]);
+ cmd[8] = ADV_MOD_DCII_Q_QPSK;
  switch (c->fec_inner) {
- case FEC_2_3:
- cmd[9] = 0; break;
- case FEC_3_4:
- cmd[9] = 1; break;
- case FEC_3_5:
- cmd[9] = 2; break;
- case FEC_5_6:
- cmd[9] = 3; break;
- case FEC_8_9:
- cmd[9] = 4; break;
- default:
- cmd[9] = 0; break;
+ /* 5/11 FEC is cmd[9] = 0 but not added to the API */
+ case FEC_1_2:  cmd[9] = 1; break;
+ case FEC_3_5:  cmd[9] = 2; break;
+ case FEC_2_3:  cmd[9] = 3; break;
+ case FEC_3_4:  cmd[9] = 4; break;
+ case FEC_4_5:  cmd[9] = 5; break;
+ case FEC_5_6:  cmd[9] = 6; break;
+ case FEC_7_8:  cmd[9] = 7; break;
+ case FEC_AUTO: cmd[9] = 8; break;
+ default:       cmd[9] = 8; break;
  }
  break;
- case QAM_16: /* QAM_16 is for compatibility with DN */
- cmd[8] = ADV_MOD_TURBO_16QAM;
- cmd[9] = 0;
+ case SYS_DCII_C_OQPSK:
+ info("%s: DCII_C_OQPSK delivery system selected w/fec %d", __func__, cmd[9]);
+ cmd[8] = ADV_MOD_DCII_C_OQPSK;
+ switch (c->fec_inner) {
+ /* 5/11 FEC is cmd[9] = 0 but not added to the API */
+ case FEC_1_2:  cmd[9] = 1; break;
+ case FEC_3_5:  cmd[9] = 2; break;
+ case FEC_2_3:  cmd[9] = 3; break;
+ case FEC_3_4:  cmd[9] = 4; break;
+ case FEC_4_5:  cmd[9] = 5; break;
+ case FEC_5_6:  cmd[9] = 6; break;
+ case FEC_7_8:  cmd[9] = 7; break;
+ case FEC_AUTO: cmd[9] = 8; break;
+ default:       cmd[9] = 8; break;
+ }
  break;
- default: /* Unknown modulation */
- deb_fe("%s: unsupported modulation selected (%d)\n",
- __func__, c->modulation);
+ default:
+ info("%s: unsupported delivery system selected (%d)", __func__,
c->delivery_system);
  return -EOPNOTSUPP;
  }

@@ -326,7 +493,7 @@


 static struct dvb_frontend_ops gp8psk_fe_ops = {
- .delsys = { SYS_DVBS },
+ .delsys = { SYS_DCII_C_QPSK, SYS_DCII_I_QPSK, SYS_DCII_Q_QPSK,
SYS_DCII_C_OQPSK, SYS_DSS, SYS_DVBS2, SYS_TURBO, SYS_DVBS },
  .info = {
  .name = "Genpix DVB-S",
  .frequency_min = 800000,
