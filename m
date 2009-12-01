Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41585 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZLAPmO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 10:42:14 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 1 Dec 2009 09:42:12 -0600
Subject: architecture part of video driver patch
Message-ID: <A69FA2915331DC488A831521EAE36FE40155B7686A@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE40155B7686Adlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE40155B7686Adlee06enttico_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Kevin,

Following patch merged to v4l-dvb linux-next has an architectural=20
part as attached. If you have not merged it to your next branch
for linux-davinci tree, please do so at your earliest convenience
so that they are in sync.

Patch merged to linux-next is available at

http://git.kernel.org/?p=3Dlinux/kernel/git/mchehab/linux-next.git;a=3Dcomm=
itdiff;h=3D600cc66f7f3ec93ab4f09cf6b63980f4c5e8f8db

I will be pushing some more patches to upstream that are having
changes to arch part. I will notify once they are merged to linux-next.

Thanks.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com


--_002_A69FA2915331DC488A831521EAE36FE40155B7686Adlee06enttico_
Content-Type: message/rfc822

Received: from dlep36.itg.ti.com (157.170.170.91) by dlee74.ent.ti.com
 (157.170.170.8) with Microsoft SMTP Server id 8.1.358.0; Tue, 13 Oct 2009
 10:09:26 -0500
Received: from linux.omap.com (localhost [127.0.0.1])	by dlep36.itg.ti.com
 (8.13.8/8.13.8) with ESMTP id n9DF9JBa005184;	Tue, 13 Oct 2009 10:09:20 -0500
 (CDT)
Received: from linux.omap.com (localhost [127.0.0.1])	by linux.omap.com
 (Postfix) with ESMTP	id AB1B980631; Tue, 13 Oct 2009 10:08:58 -0500 (CDT)
Received: from dbdp31.itg.ti.com (dbdp31.itg.ti.com [172.24.170.98])	by
 linux.omap.com (Postfix) with ESMTP id AC82680626	for
 <davinci-linux-open-source@linux.davincidsp.com>;	Tue, 13 Oct 2009 10:08:55
 -0500 (CDT)
Received: from localhost.localdomain (localhost [127.0.0.1])	by
 dbdp31.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9DF8sp3027860;	Tue, 13 Oct
 2009 20:38:54 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Sender: "davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>
Date: Tue, 13 Oct 2009 10:08:54 -0500
Subject: [PATCH 3/6] Davinci VPFE Capture: Take i2c adapter id through
	platform data
Thread-Topic: [PATCH 3/6] Davinci VPFE Capture: Take i2c adapter id through
	platform data
Thread-Index: AcpMFye7HUWq/XnCRaGRNpQyHeXlbg==
Message-ID: <1255446534-16770-1-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
List-Help: 
 <mailto:davinci-linux-open-source-request@linux.davincidsp.com?subject=help>
List-Subscribe: 
 <http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request@linux.davincidsp.com?subject=subscribe>
List-Unsubscribe: 
 <http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request@linux.davincidsp.com?subject=unsubscribe>
In-Reply-To: <hvaibhav@ti.com>
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: dlee74.ent.ti.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
list-post: <mailto:davinci-linux-open-source@linux.davincidsp.com>
errors-to: davinci-linux-open-source-bounces@linux.davincidsp.com
list-id: davinci-linux-open-source.linux.davincidsp.com
delivered-to: davinci-linux-open-source@linux.davincidsp.com
x-original-to: davinci-linux-open-source@linux.davincidsp.com
list-archive: <http://linux.omap.com/pipermail/davinci-linux-open-source>
x-mailman-version: 2.1.4
x-beenthere: davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

From: Vaibhav Hiremath <hvaibhav@ti.com>

The I2C adapter ID is actually depends on Board and may vary, Davinci
uses id=3D1, but in case of AM3517 id=3D3.

So modified respective davinci board files.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c  |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinc=
i/board-dm355-evm.c
index f683559..4a9252a 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -372,6 +372,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] =3D {
=20
 static struct vpfe_config vpfe_cfg =3D {
 	.num_subdevs =3D ARRAY_SIZE(vpfe_sub_devs),
+	.i2c_adapter_id =3D 1,
 	.sub_devs =3D vpfe_sub_devs,
 	.card_name =3D "DM355 EVM",
 	.ccdc =3D "DM355 CCDC",
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davin=
ci/board-dm644x-evm.c
index cfd9afa..fed64e2 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -257,6 +257,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] =3D {
=20
 static struct vpfe_config vpfe_cfg =3D {
 	.num_subdevs =3D ARRAY_SIZE(vpfe_sub_devs),
+	.i2c_adapter_id =3D 1,
 	.sub_devs =3D vpfe_sub_devs,
 	.card_name =3D "DM6446 EVM",
 	.ccdc =3D "DM6446 CCDC",
--=20
1.6.2.4

_______________________________________________
Davinci-linux-open-source mailing list
Davinci-linux-open-source@linux.davincidsp.com
http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source

--_002_A69FA2915331DC488A831521EAE36FE40155B7686Adlee06enttico_--
