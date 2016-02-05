Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay7.public.one.com ([91.198.169.215]:56531 "EHLO
	mailrelay7.public.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbcBEJ5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 04:57:02 -0500
Subject: Re: PCTV 292e weirdness
To: Russel Winder <russel@itzinteractive.com>,
	Antti Palosaari <crope@iki.fi>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1454523447.1970.15.camel@itzinteractive.com>
 <56B378F0.6020301@iki.fi> <1454612780.4401.66.camel@itzinteractive.com>
From: Rune Petersen <rune@megahurts.dk>
Message-ID: <56B46E25.7070405@megahurts.dk>
Date: Fri, 5 Feb 2016 10:40:53 +0100
MIME-Version: 1.0
In-Reply-To: <1454612780.4401.66.camel@itzinteractive.com>
Content-Type: multipart/mixed;
 boundary="------------080003000205070105090105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080003000205070105090105
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

(sent email again since I managed to reply only to Russel)

I have the same issue - haven't had time to look into it much.

the problem is that si2157 & si2168 doesn't resume properly from suspend.

I have attached 2 patches that disable suspend.

What i have found out:
I can resume the si2157 from suspend by replacing "goto warm" with "goto 
skip_fw_download" in si2157_init()

I can 'resume' the si2168 from suspend if I set "dev->fw_loaded = 0" in 
si2168_sleep()


Rune


On 04/02/16 20:06, Russel Winder wrote:
> On Thu, 2016-02-04 at 18:14 +0200, Antti Palosaari wrote:
> […]
>>
>> Are you using DVB-T, T2 or C? I quickly tested T and T2 with dvbv5-
>> zap
>> and it worked (kernel media 4.5.0-rc1+).
>
> Definitely T and T2. I had been assuming dvbv5-zap switched mode based
> on the entry in the virtual channel file. In this case "BBC NEWS" is in
> a T multiplex.
>
>> PCTV 282e seems to be dibcom based DVB-T only device, so you are
>> using
>> DVB-T?
>
> Yes, 282e is T only, ditto Terratec XXS. I haven't been able to get
> anything working with WinTVSoloHD or WinTVdualHD as yet.
>


--------------080003000205070105090105
Content-Type: text/x-diff;
 name="wip_si2157_disable_suspend.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wip_si2157_disable_suspend.patch"

--- ../../rtfm/linux/drivers/media/tuners/si2157.c	2016-01-06 23:41:43.099644892 +0100
+++ drivers/media/tuners/si2157.c	2016-01-13 00:20:56.764225124 +0100
@@ -235,6 +235,7 @@
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&dev->stat_work);
 
+#if 0
 	/* standby */
 	memcpy(cmd.args, "\x16\x00", 2);
 	cmd.wlen = 2;
@@ -242,6 +243,7 @@
 	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
+#endif
 
 	return 0;
 err:

--------------080003000205070105090105
Content-Type: text/x-diff;
 name="wip_si2168_disable_suspend.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wip_si2168_disable_suspend.patch"

--- ../../rtfm/linux/drivers/media/dvb-frontends/si2168.c	2016-01-06 23:41:42.523644600 +0100
+++ drivers/media/dvb-frontends/si2168.c	2016-01-12 23:59:39.655098797 +0100
@@ -413,6 +413,7 @@
 
 	if (dev->fw_loaded) {
 		/* resume */
+#if 0
 		memcpy(cmd.args, "\xc0\x06\x08\x0f\x00\x20\x21\x01", 8);
 		cmd.wlen = 8;
 		cmd.rlen = 1;
@@ -426,7 +427,7 @@
 		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
-
+#endif
 		goto warm;
 	}
 
@@ -589,13 +590,14 @@
 
 	dev->active = false;
 
+#if 0
 	memcpy(cmd.args, "\x13", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 0;
 	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
-
+#endif
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);

--------------080003000205070105090105--
