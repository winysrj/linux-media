Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20834C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B93D221919
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfBHKug (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:50:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:18573 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfBHKuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 05:50:35 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 02:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="gz'50?scan'50,208,50";a="136886873"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 08 Feb 2019 02:50:10 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gs3jV-000FmQ-IH; Fri, 08 Feb 2019 18:50:09 +0800
Date:   Fri, 8 Feb 2019 18:49:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH 2/4] media: v4l2-tpg-core: Add support for 32-bit packed
 YUV formats
Message-ID: <201902081808.jJTzoaUK%fengguang.wu@intel.com>
References: <20190208031846.14453-3-vivek.kasireddy@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190208031846.14453-3-vivek.kasireddy@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Vivek,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v5.0-rc4 next-20190207]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Vivek-Kasireddy/Add-support-for-32-bit-packed-YUV-formats/20190208-173506
base:   git://linuxtv.org/media_tree.git master
config: nds32-allmodconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 6.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=6.4.0 make.cross ARCH=nds32 

All errors (new ones prefixed by >>):

   drivers/media/common/v4l2-tpg/v4l2-tpg-core.c: In function 'gen_twopix':
   drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1283:2: error: duplicate case value
     case V4L2_PIX_FMT_YUV32:
     ^~~~
>> drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1281:2: error: previously used here
     case V4L2_PIX_FMT_YUV32:
     ^~~~

vim +1281 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c

63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1051  
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1052  /* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1053  static void gen_twopix(struct tpg_data *tpg,
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1054  		u8 buf[TPG_MAX_PLANES][8], int color, bool odd)
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1055  {
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1056  	unsigned offset = odd * tpg->twopixelsize[0] / 2;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1057  	u8 alpha = tpg->alpha_component;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1058  	u8 r_y_h, g_u_s, b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1059  
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1060  	if (tpg->alpha_red_only && color != TPG_COLOR_CSC_RED &&
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1061  				   color != TPG_COLOR_100_RED &&
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1062  				   color != TPG_COLOR_75_RED)
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1063  		alpha = 0;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1064  	if (color == TPG_COLOR_RANDOM)
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1065  		precalculate_color(tpg, color);
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1066  	r_y_h = tpg->colors[color][0]; /* R or precalculated Y, H */
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1067  	g_u_s = tpg->colors[color][1]; /* G or precalculated U, V */
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1068  	b_v = tpg->colors[color][2]; /* B or precalculated V */
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1069  
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1070  	switch (tpg->fourcc) {
51f3096835 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1071  	case V4L2_PIX_FMT_GREY:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1072  		buf[0][offset] = r_y_h;
51f3096835 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1073  		break;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1074  	case V4L2_PIX_FMT_Y10:
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1075  		buf[0][offset] = (r_y_h << 2) & 0xff;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1076  		buf[0][offset+1] = r_y_h >> 6;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1077  		break;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1078  	case V4L2_PIX_FMT_Y12:
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1079  		buf[0][offset] = (r_y_h << 4) & 0xff;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1080  		buf[0][offset+1] = r_y_h >> 4;
b89fdb5e50 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2017-09-15  1081  		break;
18b3b3b8ed drivers/media/platform/vivid/vivid-tpg.c      Ricardo Ribalda Delgado 2015-05-04  1082  	case V4L2_PIX_FMT_Y16:
648301b456 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Hans Verkuil            2018-08-11  1083  	case V4L2_PIX_FMT_Z16:
afeef4ee23 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-06-05  1084  		/*
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1085  		 * Ideally both bytes should be set to r_y_h, but then you won't
afeef4ee23 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-06-05  1086  		 * be able to detect endian problems. So keep it 0 except for
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1087  		 * the corner case where r_y_h is 0xff so white really will be
afeef4ee23 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-06-05  1088  		 * white (0xffff).
afeef4ee23 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-06-05  1089  		 */
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1090  		buf[0][offset] = r_y_h == 0xff ? r_y_h : 0;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1091  		buf[0][offset+1] = r_y_h;
18b3b3b8ed drivers/media/platform/vivid/vivid-tpg.c      Ricardo Ribalda Delgado 2015-05-04  1092  		break;
b0ce23f065 drivers/media/platform/vivid/vivid-tpg.c      Ricardo Ribalda Delgado 2015-05-04  1093  	case V4L2_PIX_FMT_Y16_BE:
afeef4ee23 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-06-05  1094  		/* See comment for V4L2_PIX_FMT_Y16 above */
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1095  		buf[0][offset] = r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1096  		buf[0][offset+1] = r_y_h == 0xff ? r_y_h : 0;
b0ce23f065 drivers/media/platform/vivid/vivid-tpg.c      Ricardo Ribalda Delgado 2015-05-04  1097  		break;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1098  	case V4L2_PIX_FMT_YUV422M:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1099  	case V4L2_PIX_FMT_YUV422P:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1100  	case V4L2_PIX_FMT_YUV420:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1101  	case V4L2_PIX_FMT_YUV420M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1102  		buf[0][offset] = r_y_h;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1103  		if (odd) {
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1104  			buf[1][0] = (buf[1][0] + g_u_s) / 2;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1105  			buf[2][0] = (buf[2][0] + b_v) / 2;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1106  			buf[1][1] = buf[1][0];
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1107  			buf[2][1] = buf[2][0];
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1108  			break;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1109  		}
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1110  		buf[1][0] = g_u_s;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1111  		buf[2][0] = b_v;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1112  		break;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1113  	case V4L2_PIX_FMT_YVU422M:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1114  	case V4L2_PIX_FMT_YVU420:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1115  	case V4L2_PIX_FMT_YVU420M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1116  		buf[0][offset] = r_y_h;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1117  		if (odd) {
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1118  			buf[1][0] = (buf[1][0] + b_v) / 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1119  			buf[2][0] = (buf[2][0] + g_u_s) / 2;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1120  			buf[1][1] = buf[1][0];
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1121  			buf[2][1] = buf[2][0];
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1122  			break;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1123  		}
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1124  		buf[1][0] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1125  		buf[2][0] = g_u_s;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1126  		break;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1127  
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1128  	case V4L2_PIX_FMT_NV12:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1129  	case V4L2_PIX_FMT_NV12M:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1130  	case V4L2_PIX_FMT_NV16:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1131  	case V4L2_PIX_FMT_NV16M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1132  		buf[0][offset] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1133  		if (odd) {
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1134  			buf[1][0] = (buf[1][0] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1135  			buf[1][1] = (buf[1][1] + b_v) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1136  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1137  		}
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1138  		buf[1][0] = g_u_s;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1139  		buf[1][1] = b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1140  		break;
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1141  	case V4L2_PIX_FMT_NV21:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1142  	case V4L2_PIX_FMT_NV21M:
68c90d6496 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1143  	case V4L2_PIX_FMT_NV61:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1144  	case V4L2_PIX_FMT_NV61M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1145  		buf[0][offset] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1146  		if (odd) {
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1147  			buf[1][0] = (buf[1][0] + b_v) / 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1148  			buf[1][1] = (buf[1][1] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1149  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1150  		}
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1151  		buf[1][0] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1152  		buf[1][1] = g_u_s;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1153  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1154  
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1155  	case V4L2_PIX_FMT_YUV444M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1156  		buf[0][offset] = r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1157  		buf[1][offset] = g_u_s;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1158  		buf[2][offset] = b_v;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1159  		break;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1160  
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1161  	case V4L2_PIX_FMT_YVU444M:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1162  		buf[0][offset] = r_y_h;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1163  		buf[1][offset] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1164  		buf[2][offset] = g_u_s;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1165  		break;
00036b307c drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2016-02-20  1166  
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1167  	case V4L2_PIX_FMT_NV24:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1168  		buf[0][offset] = r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1169  		buf[1][2 * offset] = g_u_s;
1a086879fd drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Mauro Carvalho Chehab   2018-03-22  1170  		buf[1][(2 * offset + 1) % 8] = b_v;
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1171  		break;
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1172  
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1173  	case V4L2_PIX_FMT_NV42:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1174  		buf[0][offset] = r_y_h;
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1175  		buf[1][2 * offset] = b_v;
1a086879fd drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Mauro Carvalho Chehab   2018-03-22  1176  		buf[1][(2 * offset + 1) % 8] = g_u_s;
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1177  		break;
dde72bd773 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1178  
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1179  	case V4L2_PIX_FMT_YUYV:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1180  		buf[0][offset] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1181  		if (odd) {
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1182  			buf[0][1] = (buf[0][1] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1183  			buf[0][3] = (buf[0][3] + b_v) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1184  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1185  		}
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1186  		buf[0][1] = g_u_s;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1187  		buf[0][3] = b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1188  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1189  	case V4L2_PIX_FMT_UYVY:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1190  		buf[0][offset + 1] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1191  		if (odd) {
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1192  			buf[0][0] = (buf[0][0] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1193  			buf[0][2] = (buf[0][2] + b_v) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1194  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1195  		}
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1196  		buf[0][0] = g_u_s;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1197  		buf[0][2] = b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1198  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1199  	case V4L2_PIX_FMT_YVYU:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1200  		buf[0][offset] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1201  		if (odd) {
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1202  			buf[0][1] = (buf[0][1] + b_v) / 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1203  			buf[0][3] = (buf[0][3] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1204  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1205  		}
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1206  		buf[0][1] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1207  		buf[0][3] = g_u_s;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1208  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1209  	case V4L2_PIX_FMT_VYUY:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1210  		buf[0][offset + 1] = r_y_h;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1211  		if (odd) {
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1212  			buf[0][0] = (buf[0][0] + b_v) / 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1213  			buf[0][2] = (buf[0][2] + g_u_s) / 2;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1214  			break;
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1215  		}
1f088dc162 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-07  1216  		buf[0][0] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1217  		buf[0][2] = g_u_s;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1218  		break;
71491063b8 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1219  	case V4L2_PIX_FMT_RGB332:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1220  		buf[0][offset] = (r_y_h << 5) | (g_u_s << 2) | b_v;
71491063b8 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1221  		break;
628821c84e drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1222  	case V4L2_PIX_FMT_YUV565:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1223  	case V4L2_PIX_FMT_RGB565:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1224  		buf[0][offset] = (g_u_s << 5) | b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1225  		buf[0][offset + 1] = (r_y_h << 3) | (g_u_s >> 3);
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1226  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1227  	case V4L2_PIX_FMT_RGB565X:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1228  		buf[0][offset] = (r_y_h << 3) | (g_u_s >> 3);
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1229  		buf[0][offset + 1] = (g_u_s << 5) | b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1230  		break;
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1231  	case V4L2_PIX_FMT_RGB444:
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1232  	case V4L2_PIX_FMT_XRGB444:
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1233  		alpha = 0;
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1234  		/* fall through */
628821c84e drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1235  	case V4L2_PIX_FMT_YUV444:
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1236  	case V4L2_PIX_FMT_ARGB444:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1237  		buf[0][offset] = (g_u_s << 4) | b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1238  		buf[0][offset + 1] = (alpha & 0xf0) | r_y_h;
8aca230b6d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-11  1239  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1240  	case V4L2_PIX_FMT_RGB555:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1241  	case V4L2_PIX_FMT_XRGB555:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1242  		alpha = 0;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1243  		/* fall through */
628821c84e drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1244  	case V4L2_PIX_FMT_YUV555:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1245  	case V4L2_PIX_FMT_ARGB555:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1246  		buf[0][offset] = (g_u_s << 5) | b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1247  		buf[0][offset + 1] = (alpha & 0x80) | (r_y_h << 2)
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1248  						    | (g_u_s >> 3);
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1249  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1250  	case V4L2_PIX_FMT_RGB555X:
8f1ff5435d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1251  	case V4L2_PIX_FMT_XRGB555X:
8f1ff5435d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1252  		alpha = 0;
8f1ff5435d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1253  		/* fall through */
8f1ff5435d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-12  1254  	case V4L2_PIX_FMT_ARGB555X:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1255  		buf[0][offset] = (alpha & 0x80) | (r_y_h << 2) | (g_u_s >> 3);
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1256  		buf[0][offset + 1] = (g_u_s << 5) | b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1257  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1258  	case V4L2_PIX_FMT_RGB24:
54fb153483 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1259  	case V4L2_PIX_FMT_HSV24:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1260  		buf[0][offset] = r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1261  		buf[0][offset + 1] = g_u_s;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1262  		buf[0][offset + 2] = b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1263  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1264  	case V4L2_PIX_FMT_BGR24:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1265  		buf[0][offset] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1266  		buf[0][offset + 1] = g_u_s;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1267  		buf[0][offset + 2] = r_y_h;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1268  		break;
68cd4e9f21 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1269  	case V4L2_PIX_FMT_BGR666:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1270  		buf[0][offset] = (b_v << 2) | (g_u_s >> 4);
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1271  		buf[0][offset + 1] = (g_u_s << 4) | (r_y_h >> 2);
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1272  		buf[0][offset + 2] = r_y_h << 6;
68cd4e9f21 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1273  		buf[0][offset + 3] = 0;
68cd4e9f21 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13  1274  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1275  	case V4L2_PIX_FMT_RGB32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1276  	case V4L2_PIX_FMT_XRGB32:
54fb153483 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1277  	case V4L2_PIX_FMT_HSV32:
5796e67411 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Vivek Kasireddy         2019-02-07  1278  	case V4L2_PIX_FMT_XYUV32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1279  		alpha = 0;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1280  		/* fall through */
628821c84e drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-13 @1281  	case V4L2_PIX_FMT_YUV32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1282  	case V4L2_PIX_FMT_ARGB32:
5796e67411 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Vivek Kasireddy         2019-02-07 @1283  	case V4L2_PIX_FMT_YUV32:
5796e67411 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Vivek Kasireddy         2019-02-07  1284  	case V4L2_PIX_FMT_AYUV32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1285  		buf[0][offset] = alpha;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1286  		buf[0][offset + 1] = r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1287  		buf[0][offset + 2] = g_u_s;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1288  		buf[0][offset + 3] = b_v;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1289  		break;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1290  	case V4L2_PIX_FMT_BGR32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1291  	case V4L2_PIX_FMT_XBGR32:
5796e67411 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Vivek Kasireddy         2019-02-07  1292  	case V4L2_PIX_FMT_VUYX32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1293  		alpha = 0;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1294  		/* fall through */
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1295  	case V4L2_PIX_FMT_ABGR32:
5796e67411 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Vivek Kasireddy         2019-02-07  1296  	case V4L2_PIX_FMT_VUYA32:
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1297  		buf[0][offset] = b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1298  		buf[0][offset + 1] = g_u_s;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1299  		buf[0][offset + 2] = r_y_h;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1300  		buf[0][offset + 3] = alpha;
63881df94d drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2014-08-25  1301  		break;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1302  	case V4L2_PIX_FMT_SBGGR8:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1303  		buf[0][offset] = odd ? g_u_s : b_v;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1304  		buf[1][offset] = odd ? r_y_h : g_u_s;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1305  		break;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1306  	case V4L2_PIX_FMT_SGBRG8:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1307  		buf[0][offset] = odd ? b_v : g_u_s;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1308  		buf[1][offset] = odd ? g_u_s : r_y_h;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1309  		break;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1310  	case V4L2_PIX_FMT_SGRBG8:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1311  		buf[0][offset] = odd ? r_y_h : g_u_s;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1312  		buf[1][offset] = odd ? g_u_s : b_v;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1313  		break;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1314  	case V4L2_PIX_FMT_SRGGB8:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1315  		buf[0][offset] = odd ? g_u_s : r_y_h;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1316  		buf[1][offset] = odd ? b_v : g_u_s;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1317  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1318  	case V4L2_PIX_FMT_SBGGR10:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1319  		buf[0][offset] = odd ? g_u_s << 2 : b_v << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1320  		buf[0][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1321  		buf[1][offset] = odd ? r_y_h << 2 : g_u_s << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1322  		buf[1][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1323  		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1324  		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1325  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1326  	case V4L2_PIX_FMT_SGBRG10:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1327  		buf[0][offset] = odd ? b_v << 2 : g_u_s << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1328  		buf[0][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1329  		buf[1][offset] = odd ? g_u_s << 2 : r_y_h << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1330  		buf[1][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1331  		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1332  		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1333  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1334  	case V4L2_PIX_FMT_SGRBG10:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1335  		buf[0][offset] = odd ? r_y_h << 2 : g_u_s << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1336  		buf[0][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1337  		buf[1][offset] = odd ? g_u_s << 2 : b_v << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1338  		buf[1][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1339  		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1340  		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1341  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1342  	case V4L2_PIX_FMT_SRGGB10:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1343  		buf[0][offset] = odd ? g_u_s << 2 : r_y_h << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1344  		buf[0][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1345  		buf[1][offset] = odd ? b_v << 2 : g_u_s << 2;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1346  		buf[1][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1347  		buf[0][offset] |= (buf[0][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1348  		buf[1][offset] |= (buf[1][offset] >> 2) & 3;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1349  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1350  	case V4L2_PIX_FMT_SBGGR12:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1351  		buf[0][offset] = odd ? g_u_s << 4 : b_v << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1352  		buf[0][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1353  		buf[1][offset] = odd ? r_y_h << 4 : g_u_s << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1354  		buf[1][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1355  		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1356  		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1357  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1358  	case V4L2_PIX_FMT_SGBRG12:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1359  		buf[0][offset] = odd ? b_v << 4 : g_u_s << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1360  		buf[0][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1361  		buf[1][offset] = odd ? g_u_s << 4 : r_y_h << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1362  		buf[1][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1363  		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1364  		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1365  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1366  	case V4L2_PIX_FMT_SGRBG12:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1367  		buf[0][offset] = odd ? r_y_h << 4 : g_u_s << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1368  		buf[0][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1369  		buf[1][offset] = odd ? g_u_s << 4 : b_v << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1370  		buf[1][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1371  		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1372  		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1373  		break;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1374  	case V4L2_PIX_FMT_SRGGB12:
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1375  		buf[0][offset] = odd ? g_u_s << 4 : r_y_h << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1376  		buf[0][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1377  		buf[1][offset] = odd ? b_v << 4 : g_u_s << 4;
25e9007349 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Ricardo Ribalda Delgado 2016-07-15  1378  		buf[1][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1379  		buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1380  		buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
b96c544f44 drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-09-21  1381  		break;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1382  	case V4L2_PIX_FMT_SBGGR16:
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1383  		buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : b_v;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1384  		buf[1][offset] = buf[1][offset + 1] = odd ? r_y_h : g_u_s;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1385  		break;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1386  	case V4L2_PIX_FMT_SGBRG16:
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1387  		buf[0][offset] = buf[0][offset + 1] = odd ? b_v : g_u_s;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1388  		buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : r_y_h;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1389  		break;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1390  	case V4L2_PIX_FMT_SGRBG16:
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1391  		buf[0][offset] = buf[0][offset + 1] = odd ? r_y_h : g_u_s;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1392  		buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : b_v;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1393  		break;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1394  	case V4L2_PIX_FMT_SRGGB16:
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1395  		buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : r_y_h;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1396  		buf[1][offset] = buf[1][offset + 1] = odd ? b_v : g_u_s;
9b48daa7bb drivers/media/common/v4l2-tpg/v4l2-tpg-core.c Bård Eirik Winther      2018-10-08  1397  		break;
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1398  	}
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1399  }
02aa769d9f drivers/media/platform/vivid/vivid-tpg.c      Hans Verkuil            2015-03-14  1400  

:::::: The code at line 1281 was first introduced by commit
:::::: 628821c84e9047bffab8357668a6b1ef6c0038a5 [media] vivid: add support for packed YUV formats

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--FL5UXtIhxfXey3p5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--FL5UXtIhxfXey3p5--
