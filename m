Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5BFC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD6A21924
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfBHKWQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:22:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:15222 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfBHKWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 05:22:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 02:22:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="gz'50?scan'50,208,50";a="145203253"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2019 02:22:09 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gs3IP-0002mG-2W; Fri, 08 Feb 2019 18:22:09 +0800
Date:   Fri, 8 Feb 2019 18:21:34 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH 2/4] media: v4l2-tpg-core: Add support for 32-bit packed
 YUV formats
Message-ID: <201902081802.xYCa6NSB%fengguang.wu@intel.com>
References: <20190208031846.14453-3-vivek.kasireddy@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20190208031846.14453-3-vivek.kasireddy@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vivek,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v5.0-rc4 next-20190207]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Vivek-Kasireddy/Add-support-for-32-bit-packed-YUV-formats/20190208-173506
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-x017-201905 (attached as .config)
compiler: gcc-8 (Debian 8.2.0-15) 8.2.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/media/common/v4l2-tpg/v4l2-tpg-core.c: In function 'gen_twopix':
>> drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1283:2: error: duplicate case value
     case V4L2_PIX_FMT_YUV32:
     ^~~~
   drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1281:2: note: previously used here
     case V4L2_PIX_FMT_YUV32:
     ^~~~

vim +1283 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c

  1051	
  1052	/* 'odd' is true for pixels 1, 3, 5, etc. and false for pixels 0, 2, 4, etc. */
  1053	static void gen_twopix(struct tpg_data *tpg,
  1054			u8 buf[TPG_MAX_PLANES][8], int color, bool odd)
  1055	{
  1056		unsigned offset = odd * tpg->twopixelsize[0] / 2;
  1057		u8 alpha = tpg->alpha_component;
  1058		u8 r_y_h, g_u_s, b_v;
  1059	
  1060		if (tpg->alpha_red_only && color != TPG_COLOR_CSC_RED &&
  1061					   color != TPG_COLOR_100_RED &&
  1062					   color != TPG_COLOR_75_RED)
  1063			alpha = 0;
  1064		if (color == TPG_COLOR_RANDOM)
  1065			precalculate_color(tpg, color);
  1066		r_y_h = tpg->colors[color][0]; /* R or precalculated Y, H */
  1067		g_u_s = tpg->colors[color][1]; /* G or precalculated U, V */
  1068		b_v = tpg->colors[color][2]; /* B or precalculated V */
  1069	
  1070		switch (tpg->fourcc) {
  1071		case V4L2_PIX_FMT_GREY:
  1072			buf[0][offset] = r_y_h;
  1073			break;
  1074		case V4L2_PIX_FMT_Y10:
  1075			buf[0][offset] = (r_y_h << 2) & 0xff;
  1076			buf[0][offset+1] = r_y_h >> 6;
  1077			break;
  1078		case V4L2_PIX_FMT_Y12:
  1079			buf[0][offset] = (r_y_h << 4) & 0xff;
  1080			buf[0][offset+1] = r_y_h >> 4;
  1081			break;
  1082		case V4L2_PIX_FMT_Y16:
  1083		case V4L2_PIX_FMT_Z16:
  1084			/*
  1085			 * Ideally both bytes should be set to r_y_h, but then you won't
  1086			 * be able to detect endian problems. So keep it 0 except for
  1087			 * the corner case where r_y_h is 0xff so white really will be
  1088			 * white (0xffff).
  1089			 */
  1090			buf[0][offset] = r_y_h == 0xff ? r_y_h : 0;
  1091			buf[0][offset+1] = r_y_h;
  1092			break;
  1093		case V4L2_PIX_FMT_Y16_BE:
  1094			/* See comment for V4L2_PIX_FMT_Y16 above */
  1095			buf[0][offset] = r_y_h;
  1096			buf[0][offset+1] = r_y_h == 0xff ? r_y_h : 0;
  1097			break;
  1098		case V4L2_PIX_FMT_YUV422M:
  1099		case V4L2_PIX_FMT_YUV422P:
  1100		case V4L2_PIX_FMT_YUV420:
  1101		case V4L2_PIX_FMT_YUV420M:
  1102			buf[0][offset] = r_y_h;
  1103			if (odd) {
  1104				buf[1][0] = (buf[1][0] + g_u_s) / 2;
  1105				buf[2][0] = (buf[2][0] + b_v) / 2;
  1106				buf[1][1] = buf[1][0];
  1107				buf[2][1] = buf[2][0];
  1108				break;
  1109			}
  1110			buf[1][0] = g_u_s;
  1111			buf[2][0] = b_v;
  1112			break;
  1113		case V4L2_PIX_FMT_YVU422M:
  1114		case V4L2_PIX_FMT_YVU420:
  1115		case V4L2_PIX_FMT_YVU420M:
  1116			buf[0][offset] = r_y_h;
  1117			if (odd) {
  1118				buf[1][0] = (buf[1][0] + b_v) / 2;
  1119				buf[2][0] = (buf[2][0] + g_u_s) / 2;
  1120				buf[1][1] = buf[1][0];
  1121				buf[2][1] = buf[2][0];
  1122				break;
  1123			}
  1124			buf[1][0] = b_v;
  1125			buf[2][0] = g_u_s;
  1126			break;
  1127	
  1128		case V4L2_PIX_FMT_NV12:
  1129		case V4L2_PIX_FMT_NV12M:
  1130		case V4L2_PIX_FMT_NV16:
  1131		case V4L2_PIX_FMT_NV16M:
  1132			buf[0][offset] = r_y_h;
  1133			if (odd) {
  1134				buf[1][0] = (buf[1][0] + g_u_s) / 2;
  1135				buf[1][1] = (buf[1][1] + b_v) / 2;
  1136				break;
  1137			}
  1138			buf[1][0] = g_u_s;
  1139			buf[1][1] = b_v;
  1140			break;
  1141		case V4L2_PIX_FMT_NV21:
  1142		case V4L2_PIX_FMT_NV21M:
  1143		case V4L2_PIX_FMT_NV61:
  1144		case V4L2_PIX_FMT_NV61M:
  1145			buf[0][offset] = r_y_h;
  1146			if (odd) {
  1147				buf[1][0] = (buf[1][0] + b_v) / 2;
  1148				buf[1][1] = (buf[1][1] + g_u_s) / 2;
  1149				break;
  1150			}
  1151			buf[1][0] = b_v;
  1152			buf[1][1] = g_u_s;
  1153			break;
  1154	
  1155		case V4L2_PIX_FMT_YUV444M:
  1156			buf[0][offset] = r_y_h;
  1157			buf[1][offset] = g_u_s;
  1158			buf[2][offset] = b_v;
  1159			break;
  1160	
  1161		case V4L2_PIX_FMT_YVU444M:
  1162			buf[0][offset] = r_y_h;
  1163			buf[1][offset] = b_v;
  1164			buf[2][offset] = g_u_s;
  1165			break;
  1166	
  1167		case V4L2_PIX_FMT_NV24:
  1168			buf[0][offset] = r_y_h;
  1169			buf[1][2 * offset] = g_u_s;
  1170			buf[1][(2 * offset + 1) % 8] = b_v;
  1171			break;
  1172	
  1173		case V4L2_PIX_FMT_NV42:
  1174			buf[0][offset] = r_y_h;
  1175			buf[1][2 * offset] = b_v;
  1176			buf[1][(2 * offset + 1) % 8] = g_u_s;
  1177			break;
  1178	
  1179		case V4L2_PIX_FMT_YUYV:
  1180			buf[0][offset] = r_y_h;
  1181			if (odd) {
  1182				buf[0][1] = (buf[0][1] + g_u_s) / 2;
  1183				buf[0][3] = (buf[0][3] + b_v) / 2;
  1184				break;
  1185			}
  1186			buf[0][1] = g_u_s;
  1187			buf[0][3] = b_v;
  1188			break;
  1189		case V4L2_PIX_FMT_UYVY:
  1190			buf[0][offset + 1] = r_y_h;
  1191			if (odd) {
  1192				buf[0][0] = (buf[0][0] + g_u_s) / 2;
  1193				buf[0][2] = (buf[0][2] + b_v) / 2;
  1194				break;
  1195			}
  1196			buf[0][0] = g_u_s;
  1197			buf[0][2] = b_v;
  1198			break;
  1199		case V4L2_PIX_FMT_YVYU:
  1200			buf[0][offset] = r_y_h;
  1201			if (odd) {
  1202				buf[0][1] = (buf[0][1] + b_v) / 2;
  1203				buf[0][3] = (buf[0][3] + g_u_s) / 2;
  1204				break;
  1205			}
  1206			buf[0][1] = b_v;
  1207			buf[0][3] = g_u_s;
  1208			break;
  1209		case V4L2_PIX_FMT_VYUY:
  1210			buf[0][offset + 1] = r_y_h;
  1211			if (odd) {
  1212				buf[0][0] = (buf[0][0] + b_v) / 2;
  1213				buf[0][2] = (buf[0][2] + g_u_s) / 2;
  1214				break;
  1215			}
  1216			buf[0][0] = b_v;
  1217			buf[0][2] = g_u_s;
  1218			break;
  1219		case V4L2_PIX_FMT_RGB332:
  1220			buf[0][offset] = (r_y_h << 5) | (g_u_s << 2) | b_v;
  1221			break;
  1222		case V4L2_PIX_FMT_YUV565:
  1223		case V4L2_PIX_FMT_RGB565:
  1224			buf[0][offset] = (g_u_s << 5) | b_v;
  1225			buf[0][offset + 1] = (r_y_h << 3) | (g_u_s >> 3);
  1226			break;
  1227		case V4L2_PIX_FMT_RGB565X:
  1228			buf[0][offset] = (r_y_h << 3) | (g_u_s >> 3);
  1229			buf[0][offset + 1] = (g_u_s << 5) | b_v;
  1230			break;
  1231		case V4L2_PIX_FMT_RGB444:
  1232		case V4L2_PIX_FMT_XRGB444:
  1233			alpha = 0;
  1234			/* fall through */
  1235		case V4L2_PIX_FMT_YUV444:
  1236		case V4L2_PIX_FMT_ARGB444:
  1237			buf[0][offset] = (g_u_s << 4) | b_v;
  1238			buf[0][offset + 1] = (alpha & 0xf0) | r_y_h;
  1239			break;
  1240		case V4L2_PIX_FMT_RGB555:
  1241		case V4L2_PIX_FMT_XRGB555:
  1242			alpha = 0;
  1243			/* fall through */
  1244		case V4L2_PIX_FMT_YUV555:
  1245		case V4L2_PIX_FMT_ARGB555:
  1246			buf[0][offset] = (g_u_s << 5) | b_v;
  1247			buf[0][offset + 1] = (alpha & 0x80) | (r_y_h << 2)
  1248							    | (g_u_s >> 3);
  1249			break;
  1250		case V4L2_PIX_FMT_RGB555X:
  1251		case V4L2_PIX_FMT_XRGB555X:
  1252			alpha = 0;
  1253			/* fall through */
  1254		case V4L2_PIX_FMT_ARGB555X:
  1255			buf[0][offset] = (alpha & 0x80) | (r_y_h << 2) | (g_u_s >> 3);
  1256			buf[0][offset + 1] = (g_u_s << 5) | b_v;
  1257			break;
  1258		case V4L2_PIX_FMT_RGB24:
  1259		case V4L2_PIX_FMT_HSV24:
  1260			buf[0][offset] = r_y_h;
  1261			buf[0][offset + 1] = g_u_s;
  1262			buf[0][offset + 2] = b_v;
  1263			break;
  1264		case V4L2_PIX_FMT_BGR24:
  1265			buf[0][offset] = b_v;
  1266			buf[0][offset + 1] = g_u_s;
  1267			buf[0][offset + 2] = r_y_h;
  1268			break;
  1269		case V4L2_PIX_FMT_BGR666:
  1270			buf[0][offset] = (b_v << 2) | (g_u_s >> 4);
  1271			buf[0][offset + 1] = (g_u_s << 4) | (r_y_h >> 2);
  1272			buf[0][offset + 2] = r_y_h << 6;
  1273			buf[0][offset + 3] = 0;
  1274			break;
  1275		case V4L2_PIX_FMT_RGB32:
  1276		case V4L2_PIX_FMT_XRGB32:
  1277		case V4L2_PIX_FMT_HSV32:
  1278		case V4L2_PIX_FMT_XYUV32:
  1279			alpha = 0;
  1280			/* fall through */
  1281		case V4L2_PIX_FMT_YUV32:
  1282		case V4L2_PIX_FMT_ARGB32:
> 1283		case V4L2_PIX_FMT_YUV32:
  1284		case V4L2_PIX_FMT_AYUV32:
  1285			buf[0][offset] = alpha;
  1286			buf[0][offset + 1] = r_y_h;
  1287			buf[0][offset + 2] = g_u_s;
  1288			buf[0][offset + 3] = b_v;
  1289			break;
  1290		case V4L2_PIX_FMT_BGR32:
  1291		case V4L2_PIX_FMT_XBGR32:
  1292		case V4L2_PIX_FMT_VUYX32:
  1293			alpha = 0;
  1294			/* fall through */
  1295		case V4L2_PIX_FMT_ABGR32:
  1296		case V4L2_PIX_FMT_VUYA32:
  1297			buf[0][offset] = b_v;
  1298			buf[0][offset + 1] = g_u_s;
  1299			buf[0][offset + 2] = r_y_h;
  1300			buf[0][offset + 3] = alpha;
  1301			break;
  1302		case V4L2_PIX_FMT_SBGGR8:
  1303			buf[0][offset] = odd ? g_u_s : b_v;
  1304			buf[1][offset] = odd ? r_y_h : g_u_s;
  1305			break;
  1306		case V4L2_PIX_FMT_SGBRG8:
  1307			buf[0][offset] = odd ? b_v : g_u_s;
  1308			buf[1][offset] = odd ? g_u_s : r_y_h;
  1309			break;
  1310		case V4L2_PIX_FMT_SGRBG8:
  1311			buf[0][offset] = odd ? r_y_h : g_u_s;
  1312			buf[1][offset] = odd ? g_u_s : b_v;
  1313			break;
  1314		case V4L2_PIX_FMT_SRGGB8:
  1315			buf[0][offset] = odd ? g_u_s : r_y_h;
  1316			buf[1][offset] = odd ? b_v : g_u_s;
  1317			break;
  1318		case V4L2_PIX_FMT_SBGGR10:
  1319			buf[0][offset] = odd ? g_u_s << 2 : b_v << 2;
  1320			buf[0][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
  1321			buf[1][offset] = odd ? r_y_h << 2 : g_u_s << 2;
  1322			buf[1][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
  1323			buf[0][offset] |= (buf[0][offset] >> 2) & 3;
  1324			buf[1][offset] |= (buf[1][offset] >> 2) & 3;
  1325			break;
  1326		case V4L2_PIX_FMT_SGBRG10:
  1327			buf[0][offset] = odd ? b_v << 2 : g_u_s << 2;
  1328			buf[0][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
  1329			buf[1][offset] = odd ? g_u_s << 2 : r_y_h << 2;
  1330			buf[1][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
  1331			buf[0][offset] |= (buf[0][offset] >> 2) & 3;
  1332			buf[1][offset] |= (buf[1][offset] >> 2) & 3;
  1333			break;
  1334		case V4L2_PIX_FMT_SGRBG10:
  1335			buf[0][offset] = odd ? r_y_h << 2 : g_u_s << 2;
  1336			buf[0][offset + 1] = odd ? r_y_h >> 6 : g_u_s >> 6;
  1337			buf[1][offset] = odd ? g_u_s << 2 : b_v << 2;
  1338			buf[1][offset + 1] = odd ? g_u_s >> 6 : b_v >> 6;
  1339			buf[0][offset] |= (buf[0][offset] >> 2) & 3;
  1340			buf[1][offset] |= (buf[1][offset] >> 2) & 3;
  1341			break;
  1342		case V4L2_PIX_FMT_SRGGB10:
  1343			buf[0][offset] = odd ? g_u_s << 2 : r_y_h << 2;
  1344			buf[0][offset + 1] = odd ? g_u_s >> 6 : r_y_h >> 6;
  1345			buf[1][offset] = odd ? b_v << 2 : g_u_s << 2;
  1346			buf[1][offset + 1] = odd ? b_v >> 6 : g_u_s >> 6;
  1347			buf[0][offset] |= (buf[0][offset] >> 2) & 3;
  1348			buf[1][offset] |= (buf[1][offset] >> 2) & 3;
  1349			break;
  1350		case V4L2_PIX_FMT_SBGGR12:
  1351			buf[0][offset] = odd ? g_u_s << 4 : b_v << 4;
  1352			buf[0][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
  1353			buf[1][offset] = odd ? r_y_h << 4 : g_u_s << 4;
  1354			buf[1][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
  1355			buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
  1356			buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
  1357			break;
  1358		case V4L2_PIX_FMT_SGBRG12:
  1359			buf[0][offset] = odd ? b_v << 4 : g_u_s << 4;
  1360			buf[0][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
  1361			buf[1][offset] = odd ? g_u_s << 4 : r_y_h << 4;
  1362			buf[1][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
  1363			buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
  1364			buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
  1365			break;
  1366		case V4L2_PIX_FMT_SGRBG12:
  1367			buf[0][offset] = odd ? r_y_h << 4 : g_u_s << 4;
  1368			buf[0][offset + 1] = odd ? r_y_h >> 4 : g_u_s >> 4;
  1369			buf[1][offset] = odd ? g_u_s << 4 : b_v << 4;
  1370			buf[1][offset + 1] = odd ? g_u_s >> 4 : b_v >> 4;
  1371			buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
  1372			buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
  1373			break;
  1374		case V4L2_PIX_FMT_SRGGB12:
  1375			buf[0][offset] = odd ? g_u_s << 4 : r_y_h << 4;
  1376			buf[0][offset + 1] = odd ? g_u_s >> 4 : r_y_h >> 4;
  1377			buf[1][offset] = odd ? b_v << 4 : g_u_s << 4;
  1378			buf[1][offset + 1] = odd ? b_v >> 4 : g_u_s >> 4;
  1379			buf[0][offset] |= (buf[0][offset] >> 4) & 0xf;
  1380			buf[1][offset] |= (buf[1][offset] >> 4) & 0xf;
  1381			break;
  1382		case V4L2_PIX_FMT_SBGGR16:
  1383			buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : b_v;
  1384			buf[1][offset] = buf[1][offset + 1] = odd ? r_y_h : g_u_s;
  1385			break;
  1386		case V4L2_PIX_FMT_SGBRG16:
  1387			buf[0][offset] = buf[0][offset + 1] = odd ? b_v : g_u_s;
  1388			buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : r_y_h;
  1389			break;
  1390		case V4L2_PIX_FMT_SGRBG16:
  1391			buf[0][offset] = buf[0][offset + 1] = odd ? r_y_h : g_u_s;
  1392			buf[1][offset] = buf[1][offset + 1] = odd ? g_u_s : b_v;
  1393			break;
  1394		case V4L2_PIX_FMT_SRGGB16:
  1395			buf[0][offset] = buf[0][offset + 1] = odd ? g_u_s : r_y_h;
  1396			buf[1][offset] = buf[1][offset + 1] = odd ? b_v : g_u_s;
  1397			break;
  1398		}
  1399	}
  1400	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--5vNYLRcllDrimb99
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
idXXAQA=

--5vNYLRcllDrimb99--
