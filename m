Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:51577 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbaGVWzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 18:55:13 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9400BAPYBZ7LB0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jul 2014 18:55:11 -0400 (EDT)
Date: Tue, 22 Jul 2014 19:55:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: [Kaffeine PATCH] Be sure to select the delivery system
Message-id: <20140722195506.76d8096c.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

I know you don't have any time for Kaffeine anymore. Still, it is a very
nice application, with helps me to test some stuff.

However, its DVB support is too outdated, and doesn't work fine with devices
with multiple delivery systems, as it doesn't have support yet for 
DTV_ENUM_DELSYS and DTV_DELIVERY_SYSTEM properties.

The enclosed patch should fix it. Could you please commit it at the master
repository?

With that, devices like PCTV 292e that supports both DVB-C and DVB-T will
open a dialog box that will allow configuring channels for both DVB-C and
DVB-T. It will also change to the proper standard at tuner setting.

I might eventually produce other patches for it if I have some time, in order
to make it support ISDB-T and DVB-T2, likely via libdvbv5.

Anyway, this one is an interesting to have, as it avoids the need of calling
an external program to switch between DVB-C and DVB-T on devices that support
both.

Regards,
Mauro

PS.: I created a clone of the Kaffeine tree at:
	http://git.linuxtv.org/cgit.cgi/mchehab/kaffeine.git
with the patch below, for those that want to test it.

Regards,
Mauro

---

Subject: [PATCH] Be sure to select the delivery system

Some devices support multiple delivery systems. Enumerate and
select the right delivery system when needed.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/src/dvb/dvbdevice_linux.cpp b/src/dvb/dvbdevice_linux.cpp
index 98da579..eee067c 100644
--- a/src/dvb/dvbdevice_linux.cpp
+++ b/src/dvb/dvbdevice_linux.cpp
@@ -63,6 +63,41 @@ void DvbLinuxDevice::startDevice(const QString &deviceId_)
 		return;
 	}
 
+	struct dtv_properties props;
+	struct dtv_property dvb_prop;
+
+	dvb_prop.cmd = DTV_ENUM_DELSYS;
+	props.num = 1;
+	props.props = &dvb_prop;
+
+	transmissionTypes = 0;
+
+	if (!ioctl(fd, FE_GET_PROPERTY, &props)) {
+		HasDelSys = true;
+
+		for (unsigned i = 0; i < dvb_prop.u.buffer.len; i++) {
+			switch (dvb_prop.u.buffer.data[i]) {
+			case SYS_DVBS:
+				transmissionTypes |= DvbS;
+				break;
+			case SYS_DVBS2:
+				transmissionTypes |= DvbS2;
+				break;
+			case SYS_DVBT:
+				transmissionTypes |= DvbT;
+				break;
+			case SYS_DVBC_ANNEX_A:
+				transmissionTypes |= DvbC;
+				break;
+			case SYS_ATSC:
+				transmissionTypes |= Atsc;
+				break;
+			}
+		}
+	} else {
+		HasDelSys = false;
+	}
+
 	dvb_frontend_info frontend_info;
 	memset(&frontend_info, 0, sizeof(frontend_info));
 
@@ -77,31 +112,33 @@ void DvbLinuxDevice::startDevice(const QString &deviceId_)
 	deviceId = deviceId_;
 	frontendName = QString::fromUtf8(frontend_info.name);
 
-	switch (frontend_info.type) {
-	case FE_QAM:
-		transmissionTypes = DvbC;
-		break;
-	case FE_QPSK:
-		transmissionTypes = DvbS;
-
-		if (((frontend_info.caps & FE_CAN_2G_MODULATION) != 0) ||
-		    (strcmp(frontend_info.name, "Conexant CX24116/CX24118") == 0) ||
-		    (strcmp(frontend_info.name, "Genpix 8psk-to-USB2 DVB-S") == 0) ||
-		    (strcmp(frontend_info.name, "STB0899 Multistandard") == 0)) {
-			transmissionTypes |= DvbS2;
-		}
+	if (!transmissionTypes) {
+		switch (frontend_info.type) {
+		case FE_QAM:
+			transmissionTypes = DvbC;
+			break;
+		case FE_QPSK:
+			transmissionTypes = DvbS;
+
+			if (((frontend_info.caps & FE_CAN_2G_MODULATION) != 0) ||
+			    (strcmp(frontend_info.name, "Conexant CX24116/CX24118") == 0) ||
+			    (strcmp(frontend_info.name, "Genpix 8psk-to-USB2 DVB-S") == 0) ||
+			    (strcmp(frontend_info.name, "STB0899 Multistandard") == 0)) {
+				transmissionTypes |= DvbS2;
+			}
 
-		break;
-	case FE_OFDM:
-		transmissionTypes = DvbT;
-		break;
-	case FE_ATSC:
-		transmissionTypes = Atsc;
-		break;
-	default:
-		Log("DvbLinuxDevice::startDevice: unknown type") << frontend_info.type <<
-			QLatin1String("for frontend") << frontendPath;
-		return;
+			break;
+		case FE_OFDM:
+			transmissionTypes = DvbT;
+			break;
+		case FE_ATSC:
+			transmissionTypes = Atsc;
+			break;
+		default:
+			Log("DvbLinuxDevice::startDevice: unknown type") << frontend_info.type <<
+				QLatin1String("for frontend") << frontendPath;
+			return;
+		}
 	}
 
 	capabilities = 0;
@@ -420,6 +457,45 @@ bool DvbLinuxDevice::tune(const DvbTransponder &transponder)
 	stopDvr();
 	dvb_frontend_parameters params;
 
+	if (HasDelSys) {
+		struct dtv_properties props;
+		struct dtv_property dvb_prop[1];
+		unsigned delsys;
+
+		switch (transponder.getTransmissionType()) {
+		case DvbTransponderBase::DvbS:
+			delsys = SYS_DVBS;
+			break;
+		case DvbTransponderBase::DvbS2:
+			delsys = SYS_DVBS2;
+			break;
+		case DvbTransponderBase::DvbC:
+			delsys = SYS_DVBC_ANNEX_A;
+			break;
+		case DvbTransponderBase::DvbT:
+			delsys = SYS_DVBT;
+			break;
+		case DvbTransponderBase::Atsc:
+			delsys = SYS_ATSC;
+			break;
+		default:
+			Log("DvbLinuxDevice::tune: unknown transmission type") <<
+				transponder.getTransmissionType();
+			return false;
+		}
+
+		dvb_prop[0].cmd = DTV_DELIVERY_SYSTEM;
+		dvb_prop[0].u.data = delsys;
+		props.num = 1;
+		props.props = dvb_prop;
+		if (ioctl(frontendFd, FE_SET_PROPERTY, &props) < 0) {
+			Log("DvbLinuxDevice::tune: couldn't switch delivery system to") <<
+				transponder.getTransmissionType();
+			return false;
+		}
+	}
+
+
 	switch (transponder.getTransmissionType()) {
 	case DvbTransponderBase::DvbC: {
 		const DvbCTransponder *dvbCTransponder = transponder.as<DvbCTransponder>();
diff --git a/src/dvb/dvbdevice_linux.h b/src/dvb/dvbdevice_linux.h
index a65e6ec..e5e4f13 100644
--- a/src/dvb/dvbdevice_linux.h
+++ b/src/dvb/dvbdevice_linux.h
@@ -73,6 +73,7 @@ private:
 	void stopDvr();
 	void run();
 
+	bool HasDelSys;
 	bool ready;
 	QString deviceId;
 	QString frontendName;
