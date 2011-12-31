Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1LaKXH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 05:23:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVAN6Jq022159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 05:23:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] cxd2820/af9013/af9015 conversion to DVBv5 parameters
Date: Sat, 31 Dec 2011 08:22:57 -0200
Message-Id: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the recent changes on those 3 drivers, applied upstream, I've
discarded the previous patches I had, and made 3 other ones:

  [media] cxd2820: convert get|set_fontend to use DVBv5 parameters
  [media] af9013: convert get|set_fontend to use DVBv5 parameters
  [media] af9015: convert set_fontend to use DVBv5 parameters

They're trivial ones: just remove the DVBv3 parameters from the calls.
A few other patches at my series also suffered minor merge conflicts,
with an obvious solution. The entire series is at my sixth rebase of
the DVBv5 patches, at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/DVBv5-v6

And has 142 patches. I'll merge it today, as it is not fun to rebase
a tree like that. If bugs are discovered on them, they'll be fixed on
separate patches anyway, so there's no point on holding it forever.

I may eventually modify a them a little bit, when applying upstream,
in order to make checkpatch happy with the patches.

The complete list of patches are:

de76d62 [media] dvb: don't require a parameter for get_frontend
ff87913 dvb_frontend: Fix inversion breakage due to DVBv5 conversion
7cd0feb [media] s921: Properly report the delivery system
4ef8307 [media] dvb-core: be sure that drivers won't use DVBv3 internally
f52daea cx23885-dvb: Remove a dirty hack that would require DVBv3
582ba3c [media] dvb: don't use DVBv3 bandwidth macros
6bdbcd6 [media] dvb-core: don't use fe_bandwidth_t on driver
affca15 [media] dvb: remove the track() fops
b6f6078 [media] dvb: don't pass a DVBv3 parameter for search() fops
77e4321 [media] dvb-core: Don't pass DVBv3 parameters on tune() fops
1b27a9a [media] dvb: simplify get_tune_settings() struct
e1b5a31 [media] dvb-core: remove get|set_frontend_legacy
8bc3df6 [media] af9015: convert set_fontend to use DVBv5 parameters
e05aac5 [media] af9013: convert get|set_fontend to use DVBv5 parameters
fa0c555 [media] cxd2820: convert get|set_fontend to use DVBv5 parameters
ff517a9 [media] tlg2300: convert set_fontend to use DVBv5 parameters
332e2b8 [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
3fc4e97 [media] siano: convert set_fontend to use DVBv5 parameters
7e5442a [media] firedtv: convert set_fontend to use DVBv5 parameters
83816aa [media] vp7045-fe: convert set_fontend to use DVBv5 parameters
1cc4f46 [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
be9ccc0 [media] mxl111sf-demod: convert set_fontend to use DVBv5 parameters
6a8635e [media] gp8psk-fe: convert set_fontend to use DVBv5 parameters
27025cd [media] friio-fe: convert set_fontend to use DVBv5 parameters
4c0c471 [media] dtt200u-fe: convert set_fontend to use DVBv5 parameters
86b0ba8 [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
5839d66 [media] af9005-fe: convert set_fontend to use DVBv5 parameters
244d107 [media] dst: convert set_fontend to use DVBv5 parameters
6ecdfc1 [media] staging/as102: convert set_fontend to use DVBv5 parameters
439a417 [media] vez1820: convert set_fontend to use DVBv5 parameters
d64ef26 [media] tda8083: convert set_fontend to use DVBv5 parameters
ee4688d [media] s55h1411: convert set_fontend to use DVBv5 parameters
7d2eea7 [media] s5h1409: convert set_fontend to use DVBv5 parameters
32403dc [media] or51211: convert set_fontend to use DVBv5 parameters
60dfcc4 [media] or51132: convert set_fontend to use DVBv5 parameters
53fa6c4 [media] nxt200x: convert set_fontend to use DVBv5 parameters
6e47d5c [media] tda10086: convert set_fontend to use DVBv5 parameters
0bb603b [media] tda10071: convert set_fontend to use DVBv5 parameters
558a5f1 [media] tda10023: convert set_fontend to use DVBv5 parameters
3b306af [media] tda10021: convert set_fontend to use DVBv5 parameters
0e2a317 [media] stv090x: use .delsys property, instead of get_property()
3892652 [media] stv900: convert set_fontend to use DVBv5 parameters
6d36ee5 [media] stv0299: convert set_fontend to use DVBv5 parameters
fb78614 [media] stv0297: convert set_fontend to use DVBv5 parameters
0b67256 [media] stv0288: convert set_fontend to use DVBv5 parameters
889468d [media] stb6100: use get_frontend, instead of get_frontend_legacy()
15f0514 [media] stb0899: convert get_frontend to the new struct
6fda271 [media] si21xx: convert set_fontend to use DVBv5 parameters
2a97b37 [media] s5h1420: convert set_fontend to use DVBv5 parameters
0fc0ec5 [media] mt312: convert set_fontend to use DVBv5 parameters
cd1f32c [media] s921: convert set_fontend to use DVBv5 parameters
7e4c5b9 [media] tda1004x: convert set_fontend to use DVBv5 parameters
e135675 [media] tda10048: convert set_fontend to use DVBv5 parameters
475d8b8 [media] stv0367: convert set_fontend to use DVBv5 parameters
25ad834 [media] sp887x: convert set_fontend to use DVBv5 parameters
174832a [media] sp8870: convert set_fontend to use DVBv5 parameters
071ab4e [media] s5h1432: convert set_fontend to use DVBv5 parameters
4b63603 [media] nxt6000: convert set_fontend to use DVBv5 parameters
3be9e20 [media] mt352: convert set_fontend to use DVBv5 parameters
a6fe1d4 [media] mb86a20s: convert set_fontend to use DVBv5 parameters
8b05377 [media] mb86a16: Add delivery system type at fe struct
31fc873 [media] vez1x93: convert set_fontend to use DVBv5 parameters
d9823a5 [media] lgs8gxx: convert set_fontend to use DVBv5 parameters
946868b [media] lgdt3305: convert set_fontend to use DVBv5 parameters
a14a400 [media] lgdt330x: convert set_fontend to use DVBv5 parameters
7958cf0 [media] lgs8gl5: convert set_fontend to use DVBv5 parameters
0bce3dc [media] l64781: convert set_fontend to use DVBv5 parameters
477d631 [media] it913x-fe: convert set_fontend to use DVBv5 parameters
5faa9b8 [media] ec100: convert set_fontend to use DVBv5 parameters
4ea2334 [media] dvb_dummy_fe: convert set_fontend to use DVBv5 parameters
8e5f2927 [media] ds3000: convert set_fontend to use DVBv5 parameters
4576325 [media] drxk: convert set_fontend to use DVBv5 parameters
a0985cc [media] drxd: convert set_fontend to use DVBv5 parameters
1076ba1 [media] em28xx-dvb: don't initialize drx-d non-used fields with zero
9948bf2 [media] zl10353: convert set_fontend to use DVBv5 parameters
f0b2fcf [media] dib9000: get rid of unused dvb_frontend_parameters
c4d45d7 [media] dib8000: Remove the old DVBv3 struct from it and add delsys
89dbccb [media] dib3000mb: convert set_fontend to use DVBv5 parameters
96b4b24 [media] dib9000: Get rid of the remaining DVBv3 legacy stuff
597f97a [media] cx24113: cleanup: remove unused init
44b982d [media] dib9000: remove unused parameters
36c1e4b [media] dibx000: convert set_fontend to use DVBv5 parameters
3d2017c [media] cx23123: convert set_fontend to use DVBv5 parameters
9522165 [media] av7110: convert set_fontend to use DVBv5 parameters
24b3e05 [media] cx23123: remove an unused argument from cx24123_pll_writereg()
e7184d8 [media] cx24116: report delivery system and cleanups
7349a36 [media] cx24110: convert set_fontend to use DVBv5 parameters
eb15690 [media] cx22702: convert set_fontend to use DVBv5 parameters
09d37f5 [media] cx22700: convert set_fontend to use DVBv5 parameters
c3579d3 [media] bcm3510: convert set_fontend to use DVBv5 parameters
c483c5f [media] au8522_dig: convert set_fontend to use DVBv5 parameters
73109ec [media] atbm8830: convert set_fontend to new way and fix delivery system
9e33d02 [media] dvb-core: add support for a DVBv5 get_frontend() callback
02ad726 [media] Rename set_frontend fops to set_frontend_legacy
1c0a7af [media] dvb-core: allow demods to specify the supported delsys
2d13570 [media] tuners: remove dvb_frontend_parameters from set_params()
e7ed4de [media] dvb: remove dvb_frontend_parameters from calc_regs()
f4cef9e [media] budget: use DVBv5 parameters on set_params()
c817cdb [media] budget-av: use DVBv5 parameters on set_params()
c226c76 [media] dib0700_devices: use DVBv5 parameters on set_params()
37a2274 [media] cxusb: use DVBv5 parameters on set_params()
0613d06 [media] dib0070: Remove unused dvb_frontend_parameters
eab48ca [media] zl10036: use DVBv5 parameters on set_params()
a839cc5 [media] dvb-pll: use DVBv5 parameters on set_params()
403490e [media] dvb-bt8xx: use DVBv5 parameters on set_params()
2f9cc37 [media] tuner-simple: use DVBv5 parameters on set_params()
ade992d [media] dvb-ttusb-budget: use DVBv5 parameters on set_params()
7fb5cd1 [media] pluto2: use DVBv5 parameters on set_params()
8b88b2a [media] mantis_vp2040: use DVBv5 parameters on set_params()
4c10b8a [media] mantis_vp2033: use DVBv5 parameters on set_params()
d72d98c [media] mantis_vp1033: use DVBv5 parameters on set_params()
66250b0 [media] mxl111sf-tuner: use DVBv5 parameters on set_params()
c1dab86 [media] tda826x: use DVBv5 parameters on set_params()
683f7bf [media] stb6000: use DVBv5 parameters on set_params()
c35805c [media] ix2505v: use DVBv5 parameters on set_params()
0e75678 [media] bsbe1, bsru6, tdh1: use DVBv5 parameters on set_params()
3df8a6b [media] itd1000: use DVBv5 parameters on set_params()
bb2adf5 [media] tua6100: use DVBv5 parameters on set_params()
99da808 [media] cx88: use DVBv5 parameters on set_params()
62a5665 [media] saa7134: use DVBv5 parameters on set_params()
d896285 [media] budget-patch: use DVBv5 parameters on set_params()
03bc0d9 [media] budget-ci: use DVBv5 parameters on set_params()
9ecaa66 [media] av7110: use DVBv5 parameters on set_params()
1783d35 [media] zl10039: use DVBv5 parameters on set_params()
d10821e [media] cx24113: use DVBv5 parameters on set_params()
4acc962 [media] xc4000: use DVBv5 parameters on set_params()
e241a4e [media] tuner-xc2028: use DVBv5 parameters on set_params()
4a33721 [media] tda827x: use DVBv5 parameters on set_params()
7e1b694 [media] tda18271-fe: use DVBv5 parameters on set_params()
5ef80c4 [media] tda18271: add support for QAM 7 MHz map
3fa43ec [media] tda18218: use DVBv5 parameters on set_params()
ae65623 [media] mxl5007t: use DVBv5 parameters on set_params()
c46ae3a [media] mxl5005s: fix: don't discard bandwidth changes
0197511 [media] mxl5005s: use DVBv5 parameters on set_params()
88aedf6 [media] mt2266: use DVBv5 parameters for set_params()
9e3bb85 [media] max2165: use DVBv5 parameters on set_params()
06a2f05 [media] mc44s803: use DVBv5 parameters on set_params()
f2d172d [media] mt2031: remove fake implementaion of get_bandwidth()
ef20454 [media] mt2060: remove fake implementaion of get_bandwidth()
33d15be [media] qt1010: remove fake implementaion of get_bandwidth()
2d6cb29 [media] dvb_core: estimate bw for all non-terrestial systems
ce6c932 [media] dvb: replace SYS_DVBC_ANNEX_AC by the right delsys

 drivers/media/dvb/dvb-usb/af9015.c          |    5 +-
 drivers/media/dvb/dvb-usb/af9015.h          |    3 +-
 drivers/media/dvb/frontends/af9013.c        |   11 ++---
 drivers/media/dvb/frontends/cxd2820r_c.c    |    6 +--
 drivers/media/dvb/frontends/cxd2820r_core.c |   62 +++++++++-----------------
 drivers/media/dvb/frontends/cxd2820r_priv.h |   18 +++-----
 drivers/media/dvb/frontends/cxd2820r_t.c    |    6 +--
 drivers/media/dvb/frontends/cxd2820r_t2.c   |    6 +--
 8 files changed, 42 insertions(+), 75 deletions(-)

-- 
1.7.8.352.g876a6

