Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaCCKIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:07 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 60/79] [media] drx-j: avoid calling power_down_foo twice
Date: Mon,  3 Mar 2014 07:06:54 -0300
Message-Id: <1393841233-24840-61-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When switching from one video standard to another one,
power_down_vsb is called twice. Well, as the device is already
in power_down mode, the second call always fail. This causes that
any subsequent frontend set to fail as well:

[145074.501243] drx39xyj:power_down_vsb: called
[145089.195396] drx39xyj:power_down_vsb: error -5
[145089.195404] drx39xyj:ctrl_set_standard: error -5
[145089.195417] drx39xyj:drx39xxj_set_frontend: Failed to set standard! result=fffffffb
[145089.195470] drx39xyj:ctrl_sig_quality: error -5
[145089.195473] drx39xyj:drx39xxj_read_ber: drx39xxj: could not get ber!
[145089.195475] drx39xyj:ctrl_sig_quality: error -5
[145089.195477] drx39xyj:drx39xxj_read_signal_strength: drx39xxj: could not get signal strength!
[145089.195479] drx39xyj:ctrl_sig_quality: error -5
[145089.195480] drx39xyj:drx39xxj_read_snr: drx39xxj: could not read snr!
[145089.195482] drx39xyj:ctrl_sig_quality: error -5
[145089.195484] drx39xyj:drx39xxj_read_ucblocks: drx39xxj: could not get uc blocks!
[145089.195498] drx39xyj:ctrl_sig_quality: error -5
[145089.195500] drx39xyj:drx39xxj_read_ber: drx39xxj: could not get ber!
[145089.195502] drx39xyj:ctrl_sig_quality: error -5
[145089.195503] drx39xyj:drx39xxj_read_signal_strength: drx39xxj: could not get signal strength!
[145089.195505] drx39xyj:ctrl_sig_quality: error -5
[145089.195506] drx39xyj:drx39xxj_read_snr: drx39xxj: could not read snr!
[145089.195508] drx39xyj:ctrl_sig_quality: error -5
[145089.195510] drx39xyj:drx39xxj_read_ucblocks: drx39xxj: could not get uc blocks!
[145090.196291] drx39xyj:drx39xxj_read_status: drx39xxj: could not get lock status!
[145090.196508] drx39xyj:ctrl_sig_quality: error -5
[145090.196511] drx39xyj:drx39xxj_read_ber: drx39xxj: could not get ber!
[145090.196514] drx39xyj:ctrl_sig_quality: error -5
[145090.196515] drx39xyj:drx39xxj_read_signal_strength: drx39xxj: could not get signal strength!
[145090.196518] drx39xyj:ctrl_sig_quality: error -5
[145090.196519] drx39xyj:drx39xxj_read_snr: drx39xxj: could not read snr!
[145090.196522] drx39xyj:ctrl_sig_quality: error -5
[145090.196523] drx39xyj:drx39xxj_read_ucblocks: drx39xxj: could not get uc blocks!
[145090.196553] drx39xyj:ctrl_sig_quality: error -5
[145090.196554] drx39xyj:drx39xxj_read_ber: drx39xxj: could not get ber!
[145090.196557] drx39xyj:ctrl_sig_quality: error -5
[145090.196558] drx39xyj:drx39xxj_read_signal_strength: drx39xxj: could not get signal strength!
[145090.196560] drx39xyj:ctrl_sig_quality: error -5
[145090.196562] drx39xyj:drx39xxj_read_snr: drx39xxj: could not read snr!
[145090.196564] drx39xyj:ctrl_sig_quality: error -5
[145090.196565] drx39xyj:drx39xxj_read_ucblocks: drx39xxj: could not get uc blocks!
[145091.119265] drx39xyj:ctrl_sig_quality: error -5
[145091.119271] drx39xyj:drx39xxj_read_ber: drx39xxj: could not get ber!
[145091.119274] drx39xyj:ctrl_sig_quality: error -5
[145091.119276] drx39xyj:drx39xxj_read_signal_strength: drx39xxj: could not get signal strength!
[145091.119278] drx39xyj:ctrl_sig_quality: error -5
[145091.119280] drx39xyj:drx39xxj_read_snr: drx39xxj: could not read snr!
[145091.119282] drx39xyj:ctrl_sig_quality: error -5
[145091.119283] drx39xyj:drx39xxj_read_ucblocks: drx39xxj: could not get uc blocks!

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index ccd847e10797..7f17cd14839b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -18264,6 +18264,7 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 				goto rw_error;
 			}
 		}
+		ext_attr->standard = DRX_STANDARD_UNKNOWN;
 	}
 
 	common_attr->current_power_mode = *mode;
-- 
1.8.5.3

