Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12A4C67838
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 07:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 640DB20874
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 07:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ou.edu header.i=@ou.edu header.b="TfXzdUg/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 640DB20874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ou.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbeLIHkf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 02:40:35 -0500
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:34792 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726079AbeLIHke (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 02:40:34 -0500
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2018 02:40:33 EST
Received: from pps.filterd (m0107988.ppops.net [127.0.0.1])
        by mx0b-00272701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wB9747KP001519;
        Sun, 9 Dec 2018 01:11:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ou.edu; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=domainkey;
 bh=vJSMECGf4+txWG3rp+v5on1jCuoSf/EslNTN4coxCBg=;
 b=TfXzdUg/vGhVM5XcWUZ8TNQzth2UMS0Tdv9jqsVLIRm5UO6MxtxQSt9Zn9lidnoTUcXA
 68V5XdHs6OPzHyD3EKZ5L2mqFICi/k1zBTJd7hy35khs8WFw4FL55hbC3iGt8vCl4VN6
 niXEisCxX4VLq8KG9oerP9ZpmZWv2kYFzij3GZoVjEA3QDU/Qkb1ezuWfxulcRhvdSNz
 x4sflp4j0QkJUr9MvXgsQx6k6uJwulEiSpTc4IVIOwR1OoqU9rOoVUJ5O26G3v1VzNCa
 Gpgm7s5NO3wfO2Q7z91ByzJvRGg2at9YksDTkhmK71J92L6UzkU64/i3a13koYQkJfc3 gw== 
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2057.outbound.protection.outlook.com [104.47.34.57])
        by mx0b-00272701.pphosted.com with ESMTP id 2p8v9t8cns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Dec 2018 01:11:21 -0600
Received: from DM6PR03MB4252.namprd03.prod.outlook.com (20.176.122.77) by
 DM6PR03MB3500.namprd03.prod.outlook.com (20.176.84.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.19; Sun, 9 Dec 2018 07:11:19 +0000
Received: from DM6PR03MB4252.namprd03.prod.outlook.com
 ([fe80::45b:c08:e079:fb8e]) by DM6PR03MB4252.namprd03.prod.outlook.com
 ([fe80::45b:c08:e079:fb8e%3]) with mapi id 15.20.1404.025; Sun, 9 Dec 2018
 07:11:19 +0000
From:   "French, Nicholas A." <naf@ou.edu>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Adam Stylinski <kungfujesus06@gmail.com>
Subject: [PATCH] media: lgdt330x: fix lock status reporting
Thread-Topic: [PATCH] media: lgdt330x: fix lock status reporting
Thread-Index: AQHUj45hb+/0P7GBn0+b23vhcCTwag==
Date:   Sun, 9 Dec 2018 07:11:18 +0000
Message-ID: <20181209071054.GA14422@tivo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [216.119.148.18]
user-agent: Mutt/1.10.1 (2018-07-13)
x-clientproxiedby: SN4PR0501CA0083.namprd05.prod.outlook.com
 (2603:10b6:803:22::21) To DM6PR03MB4252.namprd03.prod.outlook.com
 (2603:10b6:5:9::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR03MB3500;20:uRByRhz+AdmcBO/LlVj5Mu3cCzKuYk1npJi0iYZDX0KXpSvQKJjNKR195eszFX+U6TkyIXkYr5O8vocg//IHM5sMr7cicwhwPDRoroca79Po7x6Zxkb5bFOVuwIAUEtJgW7fT+ebJielW2udcYdUFR9X3i9TJ5pqH1ePR9x26D8=
x-ms-office365-filtering-correlation-id: 7406ec6b-e08e-47a4-1327-08d65da583e1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM6PR03MB3500;
x-ms-traffictypediagnostic: DM6PR03MB3500:
x-microsoft-antispam-prvs: <DM6PR03MB3500222D7FD1FAFF156B1913D3A40@DM6PR03MB3500.namprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(3231455)(999002)(944501520)(52105112)(10201501046)(148016)(149066)(150057)(6041310)(20161123564045)(20161123558120)(201703131423095)(201702281529075)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM6PR03MB3500;BCL:0;PCL:0;RULEID:;SRVR:DM6PR03MB3500;
x-forefront-prvs: 0881A7A935
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(346002)(396003)(136003)(376002)(366004)(199004)(189003)(110136005)(58126008)(2906002)(4326008)(2501003)(105586002)(5660300001)(66066001)(53936002)(486006)(476003)(14454004)(39060400002)(86362001)(6486002)(81166006)(81156014)(102836004)(68736007)(8936002)(6506007)(386003)(75432002)(6436002)(478600001)(97736004)(52116002)(7736002)(71200400001)(99286004)(186003)(71190400001)(106356001)(3846002)(6116002)(786003)(316002)(6512007)(1076002)(9686003)(26005)(256004)(305945005)(33716001)(14444005)(33896004)(88552002)(33656002)(8676002)(25786009)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR03MB3500;H:DM6PR03MB4252.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ou.edu does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UwmO3pcSX9IlxMMSv/N/A4j0Cjy5U/JpdPlj/1gbL0/i58SJs9u/77Uo1b1I4qz0vodDEiP0RungR5/hdefRRiA8wgcZe0CYdJh1V/PEL1OpJQmw9oXJqe3mUxdOtSpfqUUmZpxt/faHbiaOSJZp1vxUsjoOLMzmS5oEnMOJNpBDB6cbF/TWTNvbaljGgf/XZk062Y+wV3f/WbJmjWW6k4ODchRcaxX4RWxwDEjUA0ycYh45+TsjQz0dslVeuktqYMFa8lrtNaLqjx7JMMm3bkLz1Q5kfEFxQZPcx9el7StfKcWfMFq80vCFYM8wpO5tPSGhaiq75eii9JGMX59MLKVMOOX7aQu/diuyLEV++SA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A926CEC132E95F49B1A1A51DAF62DA90@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ou.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7406ec6b-e08e-47a4-1327-08d65da583e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2018 07:11:19.1806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9c7de09d-9034-44c1-b462-c464fece204a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3500
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812090068
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A typo in code cleanup commit db9c1007bc07 ("media: lgdt330x: do
some cleanups at status logic") broke the FE_HAS_LOCK reporting
for 3303 chips by inadvertently modifying the register mask.

The broken lock status is critial as it prevents video capture
cards from reporting signal strength, scanning for channels,
and capturing video.

Fix regression by reverting mask change.

Signed-off-by: Nick French <naf@ou.edu>
---
 drivers/media/dvb-frontends/lgdt330x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-fro=
ntends/lgdt330x.c
index 96807e134886..8abb1a510a81 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -783,7 +783,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe=
,
=20
 		if ((buf[0] & 0x02) =3D=3D 0x00)
 			*status |=3D FE_HAS_SYNC;
-		if ((buf[0] & 0xfd) =3D=3D 0x01)
+		if ((buf[0] & 0x01) =3D=3D 0x01)
 			*status |=3D FE_HAS_VITERBI | FE_HAS_LOCK;
 		break;
 	default:
--=20
2.19.2

