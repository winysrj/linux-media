Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34135 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753710Ab2GaSDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 14:03:40 -0400
Message-ID: <50181DF7.8080807@gmx.de>
Date: Tue, 31 Jul 2012 20:03:35 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: set default protocol for  TerraTec Cinergy XXS  to "nec"
References: <50047814.20701@gmx.de> <5016B29F.4080605@redhat.com>
In-Reply-To: <5016B29F.4080605@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020100010108060806070304"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020100010108060806070304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 07/30/2012 06:13 PM, Mauro Carvalho Chehab wrote:
> Em 16-07-2012 17:22, Toralf Förster escreveu:
>> For a TerraTec Cinergy XXS USB stick (Bus 001 Device 008: ID 0ccd:00ab TerraTec Electronic GmbH )
>> I've to switch the protocol every time after plugin to get (at least few) keys working :
>>
>> $> sudo ir-keytable --protocol=nec --sysdev=`ir-keytable 2>&1 | head -n 1 | cut -f5 -d'/'`
>>
>> /me wonders whether "nec" should be set as the default for this key in kernel or not
> 
> It makes sense to patch it to use the nec protocol. If not all keys are working, it also makes
> sense to fix the kernel table to handle all codes, or to point to a new table where all
> Terratec keys are defined.
> 
> Could you please write such patch?
> 
> Thank you!
> Mauro

I tried it, but the attached (naive) approach doesn't work.
The kernel dmesg shows "kernel: Registered IR keymap rc-dib0700-nec"
but keys aren't recognized.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--------------020100010108060806070304
Content-Type: text/x-patch;
 name="nec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nec.patch"

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 510001d..46215cc 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -4276,8 +4276,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 			{   "Terratec Cinergy T USB XXS (HD)/ T3",
 				{ &dib0700_usb_id_table[33],
-					&dib0700_usb_id_table[52],
-					&dib0700_usb_id_table[60], NULL},
+					&dib0700_usb_id_table[52], NULL},
 				{ NULL },
 			},
 			{   "TechniSat AirStar TeleStick 2",
@@ -4301,6 +4300,45 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
+		.num_adapters = 1,
+		.adapter = {
+			{
+			.num_frontends = 1,
+			.fe = {{
+				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+				.pid_filter_count = 32,
+				.pid_filter       = stk70x0p_pid_filter,
+				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
+				.frontend_attach  = stk7770p_frontend_attach,
+				.tuner_attach     = dib7770p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+			}},
+				.size_of_priv =
+					sizeof(struct dib0700_adapter_state),
+			},
+		},
+
+		.num_device_descs = 1,
+		.devices = {
+			{   "Terratec Cinergy T USB XXS (HD)/ T3 _2",
+				{ &dib0700_usb_id_table[60], NULL},
+				{ NULL },
+			},
+		},
+
+		.rc.core = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.allowed_protos   = RC_TYPE_RC5 |
+					    RC_TYPE_RC6 |
+					    RC_TYPE_NEC,
+			.change_protocol  = dib0700_change_protocol,
+		},
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
 			{

--------------020100010108060806070304--
