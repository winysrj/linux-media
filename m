Return-path: <mchehab@pedra>
Received: from host63-43-static.30-87-b.business.telecomitalia.it ([87.30.43.63]:38452
	"EHLO intranet.spintec.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab0ILREJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 13:04:09 -0400
Subject: Re: [PATCH] DiSEqC bug fixed for stv0288 based interfaces
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-5-1061154725
From: Josef Pavlik <josef@pavlik.it>
In-Reply-To: <4C87E0F3.3080304@redhat.com>
Date: Sun, 12 Sep 2010 19:03:52 +0200
Cc: linux-media@vger.kernel.org
Message-Id: <7149F387-D819-442B-8E7B-BD135644A0E0@pavlik.it>
References: <201009011435.42753.josef@pavlik.it> <4C87E0F3.3080304@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


--Apple-Mail-5-1061154725
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

sorry, but something eats the leading spaces (but no the tabs) in the =
inlined patch making it unusable, so please use the attached one.


---------------------
on  Sep 12, 2010, at 13:30, I wrote:
seems that the patch was corrupted by the kmail used for the post =
(missing space before the last close bracket resulting corrupted patch)
the corrected patch follows (and I'm sending it with another mail =
program)

Signed-off-by: Josef Pavlik <josef@pavlik.it>

-------------------------------------
diff --git a/drivers/media/dvb/frontends/stv0288.c =
b/drivers/media/dvb/frontends/stv0288.c
index 2930a5d..6cd442e 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -6,6 +6,8 @@
	Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
		Removed stb6000 specific tuner code and revised some
		procedures.
+        2010-09-01 Josef Pavlik <josef@pavlik.it>
+                Fixed diseqc_msg, diseqc_burst and set_tone problems

	This program is free software; you can redistribute it and/or =
modify
	it under the terms of the GNU General Public License as =
published by
@@ -156,14 +158,13 @@ static int stv0288_send_diseqc_msg(struct =
dvb_frontend *fe,

	stv0288_writeregI(state, 0x09, 0);
	msleep(30);
-	stv0288_writeregI(state, 0x05, 0x16);
+	stv0288_writeregI(state, 0x05, 0x12); /* modulated mode, single =
shot */

	for (i =3D 0; i < m->msg_len; i++) {
		if (stv0288_writeregI(state, 0x06, m->msg[i]))
			return -EREMOTEIO;
-		msleep(12);
	}
-
+    msleep(m->msg_len*12);=20
	return 0;
}

@@ -174,13 +175,14 @@ static int stv0288_send_diseqc_burst(struct =
dvb_frontend *fe,

	dprintk("%s\n", __func__);

-	if (stv0288_writeregI(state, 0x05, 0x16))/* burst mode */
-		return -EREMOTEIO;
-
-	if (stv0288_writeregI(state, 0x06, burst =3D=3D SEC_MINI_A ? =
0x00 : 0xff))
+    if (stv0288_writeregI(state, 0x05, 0x03)) /* simple tone burst =
mode, single shot */
+        return -EREMOTEIO;
+=09
+    if (stv0288_writeregI(state, 0x06, burst =3D=3D SEC_MINI_A ? 0x00 : =
0xff))
		return -EREMOTEIO;

-	if (stv0288_writeregI(state, 0x06, 0x12))
+    msleep(15);
+	if (stv0288_writeregI(state, 0x05, 0x12))
		return -EREMOTEIO;

	return 0;
@@ -192,18 +194,19 @@ static int stv0288_set_tone(struct dvb_frontend =
*fe, fe_sec_tone_mode_t tone)

	switch (tone) {
	case SEC_TONE_ON:
-		if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode =
*/
+		if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode, =
continuous carrier */
			return -EREMOTEIO;
-		return stv0288_writeregI(state, 0x06, 0xff);
+        break;

	case SEC_TONE_OFF:
-		if (stv0288_writeregI(state, 0x05, 0x13))/* burst mode =
*/
+		if (stv0288_writeregI(state, 0x05, 0x12))/* burst mode =
off*/
			return -EREMOTEIO;
-		return stv0288_writeregI(state, 0x06, 0x00);
+        break;

	default:
		return -EINVAL;
	}
+    return 0;
}

static u8 stv0288_inittab[] =3D {
-----------------------------------------------------



On Sep 8, 2010, at 21:16 , Mauro Carvalho Chehab wrote:

> Em 01-09-2010 09:35, Josef Pavlik escreveu:
>> Fixed problem with DiSEqC communication. The message was wrongly =
modulated,=20
>> so the DiSEqC switch was not work.
>>=20
>> This patch fixes DiSEqC messages, simple tone burst and tone on/off.=20=

>> I verified it with osciloscope against the DiSEqC documentation.
>>=20
>> Interface: PCI DVB-S TV tuner TeVii S420
>> Kernel: 2.6.32-24-generic (UBUNTU 10.4)
>>=20
>> Signed-off-by: Josef Pavlik <josef@pavlik.it>
>=20
> Patch doesn't apply against the latest version, at my -git tree.=20
> Not sure if the bugs you're pointing were already fixed.
>=20
> Cheers,
> Mauro.
>>=20
>>=20
>>=20
>>=20
>> diff --git a/drivers/media/dvb/frontends/stv0288.c =
b/drivers/media/dvb/frontends/stv0288.c
>> index 2930a5d..6a32535 100644
>> --- a/drivers/media/dvb/frontends/stv0288.c
>> +++ b/drivers/media/dvb/frontends/stv0288.c
>> @@ -6,6 +6,8 @@
>>       Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
>>               Removed stb6000 specific tuner code and revised some
>>               procedures.
>> +       2010-09-01 Josef Pavlik <josef@pavlik.it>
>> +               Fixed diseqc_msg, diseqc_burst and set_tone problems
>>=20
>>       This program is free software; you can redistribute it and/or =
modify
>>       it under the terms of the GNU General Public License as =
published by
>> @@ -156,14 +158,13 @@ static int stv0288_send_diseqc_msg(struct =
dvb_frontend *fe,
>>=20
>>       stv0288_writeregI(state, 0x09, 0);
>>       msleep(30);
>> -       stv0288_writeregI(state, 0x05, 0x16);
>> +       stv0288_writeregI(state, 0x05, 0x12); /* modulated mode, =
single shot */
>>=20
>>       for (i =3D 0; i < m->msg_len; i++) {
>>               if (stv0288_writeregI(state, 0x06, m->msg[i]))
>>                       return -EREMOTEIO;
>> -               msleep(12);
>>       }
>> -
>> +       msleep(m->msg_len*12);
>>       return 0;
>> }
>>=20
>> @@ -174,13 +175,14 @@ static int stv0288_send_diseqc_burst(struct =
dvb_frontend *fe,
>>=20
>>       dprintk("%s\n", __func__);
>>=20
>> -       if (stv0288_writeregI(state, 0x05, 0x16))/* burst mode */
>> +       if (stv0288_writeregI(state, 0x05, 0x03)) /* "simple tone =
burst" mode, single shot */
>>               return -EREMOTEIO;
>>=20
>>       if (stv0288_writeregI(state, 0x06, burst =3D=3D SEC_MINI_A ? =
0x00 : 0xff))
>>               return -EREMOTEIO;
>>=20
>> -       if (stv0288_writeregI(state, 0x06, 0x12))
>> +       msleep(15);
>> +       if (stv0288_writeregI(state, 0x05, 0x12))
>>               return -EREMOTEIO;
>>=20
>>       return 0;
>> @@ -192,18 +194,19 @@ static int stv0288_set_tone(struct dvb_frontend =
*fe, fe_sec_tone_mode_t tone)
>>=20
>>       switch (tone) {
>>       case SEC_TONE_ON:
>> -               if (stv0288_writeregI(state, 0x05, 0x10))/* burst =
mode */
>> +               if (stv0288_writeregI(state, 0x05, 0x10))/* burst =
mode, continuous carrier */
>>                       return -EREMOTEIO;
>> -               return stv0288_writeregI(state, 0x06, 0xff);
>> +               break;
>>=20
>>       case SEC_TONE_OFF:
>> -               if (stv0288_writeregI(state, 0x05, 0x13))/* burst =
mode */
>> +               if (stv0288_writeregI(state, 0x05, 0x12))/* burst =
mode off*/
>>                       return -EREMOTEIO;
>> -               return stv0288_writeregI(state, 0x06, 0x00);
>> +               break;
>>=20
>>       default:
>>               return -EINVAL;
>>       }
>> +       return 0;
>> }
>>=20
>> static u8 stv0288_inittab[] =3D {
>> --
>> To unsubscribe from this list: send the line "unsubscribe =
linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html=

--Apple-Mail-5-1061154725
Content-Disposition: attachment;
	filename=stv0288.diff
Content-Type: application/octet-stream;
	name="stv0288.diff"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 2930a5d..6cd442e 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -6,6 +6,8 @@
 	Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
 		Removed stb6000 specific tuner code and revised some
 		procedures.
+        2010-09-01 Josef Pavlik <josef@pavlik.it>
+                Fixed diseqc_msg, diseqc_burst and set_tone problems
 
 	This program is free software; you can redistribute it and/or modify
 	it under the terms of the GNU General Public License as published by
@@ -156,14 +158,13 @@ static int stv0288_send_diseqc_msg(struct dvb_frontend *fe,
 
 	stv0288_writeregI(state, 0x09, 0);
 	msleep(30);
-	stv0288_writeregI(state, 0x05, 0x16);
+	stv0288_writeregI(state, 0x05, 0x12); /* modulated mode, single shot */
 
 	for (i = 0; i < m->msg_len; i++) {
 		if (stv0288_writeregI(state, 0x06, m->msg[i]))
 			return -EREMOTEIO;
-		msleep(12);
 	}
-
+    msleep(m->msg_len*12); 
 	return 0;
 }
 
@@ -174,13 +175,14 @@ static int stv0288_send_diseqc_burst(struct dvb_frontend *fe,
 
 	dprintk("%s\n", __func__);
 
-	if (stv0288_writeregI(state, 0x05, 0x16))/* burst mode */
-		return -EREMOTEIO;
-
-	if (stv0288_writeregI(state, 0x06, burst == SEC_MINI_A ? 0x00 : 0xff))
+    if (stv0288_writeregI(state, 0x05, 0x03)) /* simple tone burst mode, single shot */
+        return -EREMOTEIO;
+	
+    if (stv0288_writeregI(state, 0x06, burst == SEC_MINI_A ? 0x00 : 0xff))
 		return -EREMOTEIO;
 
-	if (stv0288_writeregI(state, 0x06, 0x12))
+    msleep(15);
+	if (stv0288_writeregI(state, 0x05, 0x12))
 		return -EREMOTEIO;
 
 	return 0;
@@ -192,18 +194,19 @@ static int stv0288_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 
 	switch (tone) {
 	case SEC_TONE_ON:
-		if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode */
+		if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode, continuous carrier */
 			return -EREMOTEIO;
-		return stv0288_writeregI(state, 0x06, 0xff);
+        break;
 
 	case SEC_TONE_OFF:
-		if (stv0288_writeregI(state, 0x05, 0x13))/* burst mode */
+		if (stv0288_writeregI(state, 0x05, 0x12))/* burst mode off*/
 			return -EREMOTEIO;
-		return stv0288_writeregI(state, 0x06, 0x00);
+        break;
 
 	default:
 		return -EINVAL;
 	}
+    return 0;
 }
 
 static u8 stv0288_inittab[] = {

--Apple-Mail-5-1061154725--
