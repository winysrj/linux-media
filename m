Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dibcom.eu ([84.37.95.87]:58560 "EHLO mail.dibcom.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1LFKps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 05:45:48 -0500
From: Olivier Grenie <Olivier.Grenie@dibcom.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 6 Dec 2011 11:13:19 +0100
Subject: RE: [media] dib7090: add the reference board TFE7090E
Message-ID: <57C38DA176A0A34A9B9F3CCCE33D3C4A01686D86AB9F@FRPAR1CL009.coe.adi.dibcom.com>
References: <20111129072150.GA12145@elgon.mountain>
In-Reply-To: <20111129072150.GA12145@elgon.mountain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Dan,
Indeed, after the "if (state->rf_ramp == NULL)" test, the function dib0090_set_rframp_pwm will set the state->rf_ramp. So after this line, state->rf_ramp can not be NULL.

But I can make a patch in order to make sure that this code will not be detected as an error.

Regards,
Olivier

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Tuesday, November 29, 2011 8:22 AM
To: Olivier Grenie
Cc: linux-media@vger.kernel.org
Subject: re: [media] dib7090: add the reference board TFE7090E

Hello Olivier Grenie,

This is a semi-automatic email about new static checker warnings.

The patch 6724a2f4f7a6: "[media] dib7090: add the reference board
TFE7090E" from Aug 5, 2011, leads to the following Smatch complaint:

drivers/media/dvb/frontends/dib0090.c +1146 dib0090_pwm_gain_reset()
         error: we previously assumed 'state->rf_ramp' could be null (see line 1110)

drivers/media/dvb/frontends/dib0090.c
  1109                                          if (state->config->is_dib7090e) {
  1110                                                  if (state->rf_ramp == NULL)
                                                            ^^^^^^^^^^^^^^
This test is new.

  1111                                                          dib0090_set_rframp_pwm(state, rf_ramp_pwm_cband_7090e_sensitivity);
  1112                                                  else
  1113                                                          dib0090_set_rframp_pwm(state, state->rf_ramp);
  1114                                          } else
  1115                                                  dib0090_set_rframp_pwm(state, rf_ramp_pwm_cband_7090);
  1116                                  }
  1117                          } else {
  1118                                  dib0090_set_rframp_pwm(state, rf_ramp_pwm_cband);
  1119                                  dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
  1120                          }
  1121                  } else
  1122  #endif
  1123  #ifdef CONFIG_BAND_VHF
  1124                  if (state->current_band == BAND_VHF) {
  1125                          if (state->identity.in_soc) {
  1126                                  dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal_socs);
  1127                          } else {
  1128                                  dib0090_set_rframp_pwm(state, rf_ramp_pwm_vhf);
  1129                                  dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
  1130                          }
  1131                  } else
  1132  #endif
  1133                  {
  1134                          if (state->identity.in_soc) {
  1135                                  if (state->identity.version == SOC_8090_P1G_11R1 || state->identity.version == SOC_8090_P1G_21R1)
  1136                                          dib0090_set_rframp_pwm(state, rf_ramp_pwm_uhf_8090);
  1137                                  else if (state->identity.version == SOC_7090_P1G_11R1 || state->identity.version == SOC_7090_P1G_21R1)
  1138                                          dib0090_set_rframp_pwm(state, rf_ramp_pwm_uhf_7090);
  1139                                  dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal_socs);
  1140                          } else {
  1141                                  dib0090_set_rframp_pwm(state, rf_ramp_pwm_uhf);
  1142                                  dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
  1143                          }
  1144                  }
  1145
  1146                  if (state->rf_ramp[0] != 0)
                            ^^^^^^^^^^^^^^^^^
This is the old dereference.

  1147                          dib0090_write_reg(state, 0x32, (3 << 11));
  1148                  else

regards,
dan carpenter


CONFIDENTIAL NOTICE: The contents of this message, including any attachments, are confidential and are intended solely for the use of the person or entity to whom the message was addressed. If you are not the intended recipient of this message, please be advised that any dissemination, distribution, or use of the contents of this message is strictly prohibited. If you received this message in error, please notify the sender. Please also permanently delete all copies of the original message and any attached documentation. Thank you.
