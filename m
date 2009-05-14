Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f168.google.com ([209.85.218.168])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <armel.frey@gmail.com>) id 1M4bHO-0006eP-OB
	for linux-dvb@linuxtv.org; Thu, 14 May 2009 15:47:23 +0200
Received: by bwz12 with SMTP id 12so1286752bwz.17
	for <linux-dvb@linuxtv.org>; Thu, 14 May 2009 06:46:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 May 2009 15:46:47 +0200
Message-ID: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>
From: armel frey <armel.frey@gmail.com>
To: "DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] DVB-S2 frontend doesn't work!
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0283147507=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0283147507==
Content-Type: multipart/alternative; boundary=001636c5a5373011780469df8fb0

--001636c5a5373011780469df8fb0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi everyone!

I have a problem with my HVR-4000 card.

I installed the firmware cx24116 find on
http://tevii.com/Tevii_linuxdriver_0815.rar
sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw
/lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
sudo ln -s /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
/lib/firmware/dvb-fe-cx24116.fw

I installed S2API find on http://linuxtv.org/hg/~stoth/s2/

make & make install
cp ./linux/include/linux/dvb/* /usr/include/linux/dvb/

and I installed szap-s2 find on http://mercurial.intuxication.org/hg/szap-s2

Every seems to be ok...
I can tune an DVB-S signal, but not DVB-S2...
I try to tune a DVB-S2 signal with a symbols rate of 75335000 (>45000000)
and I have this error message with dmesg :

[ 450.409150] DVB: frontend 0 symbol rate 75335000 out of range
(1000000..45000000)

So I try dvbsnoop to see the frontend information :

# dvbsnoop -s feinfo
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------
Device: /dev/dvb/adapter0/frontend0
Basic capabilities:
Name: "Conexant CX24116/CX24118"
Frontend-type: QPSK (DVB-S)
Frequency (min): 950.000 MHz
Frequency (max): 2150.000 MHz
Frequency stepsiz: 1.011 MHz
Frequency tolerance: 5.000 MHz
Symbol rate (min): 1.000000 MSym/s
Symbol rate (max): 45.000000 MSym/s
Symbol rate tolerance: 0 ppm
Notifier delay: 0 ms
Frontend capabilities:
auto inversion
FEC 1/2
FEC 2/3
FEC 3/4
FEC 4/5
FEC 5/6
FEC 6/7
FEC 7/8
FEC AUTO
QPSK
Current parameters:
Error(95): frontend ioctl: Operation not supported

That means the DVB-S2 frontend is not recognized... only DVB-S, but this is
my frontend (/dev/dvb/adapter0/frontend0) :

/*
* frontend.h
*
* Copyright (C) 2000 Marcus Metzler marcus@convergence.de
* Ralph Metzler ralph@convergence.de
* Holger Waechtler holger@convergence.de
* Andre Draszik ad@convergence.de
* for convergence integrated media GmbH
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public License
* as published by the Free Software Foundation; either version 2.1
* of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*
*/
#ifndef _DVBFRONTEND_H_
#define _DVBFRONTEND_H_
#include <linux/types.h>

typedef enum fe_type {
FE_QPSK,
FE_QAM,
FE_OFDM,
FE_ATSC
} fe_type_t;

typedef enum fe_caps {
FE_IS_STUPID = 0,
FE_CAN_INVERSION_AUTO = 0x1,
FE_CAN_FEC_1_2 = 0x2,
FE_CAN_FEC_2_3 = 0x4,
FE_CAN_FEC_3_4 = 0x8,
FE_CAN_FEC_4_5 = 0x10,
FE_CAN_FEC_5_6 = 0x20,
FE_CAN_FEC_6_7 = 0x40,
FE_CAN_FEC_7_8 = 0x80,
FE_CAN_FEC_8_9 = 0x100,
FE_CAN_FEC_AUTO = 0x200,
FE_CAN_QPSK = 0x400,
FE_CAN_QAM_16 = 0x800,
FE_CAN_QAM_32 = 0x1000,
FE_CAN_QAM_64 = 0x2000,
FE_CAN_QAM_128 = 0x4000,
FE_CAN_QAM_256 = 0x8000,
FE_CAN_QAM_AUTO = 0x10000,
FE_CAN_TRANSMISSION_MODE_AUTO = 0x20000,
FE_CAN_BANDWIDTH_AUTO = 0x40000,
FE_CAN_GUARD_INTERVAL_AUTO = 0x80000,
FE_CAN_HIERARCHY_AUTO = 0x100000,
FE_CAN_8VSB = 0x200000,
FE_CAN_16VSB = 0x400000,
FE_HAS_EXTENDED_CAPS = 0x800000, /* We need more bitspace for newer APIs,
indicate this. */
FE_CAN_2G_MODULATION = 0x10000000, /* frontend supports "2nd generation
modulation" (DVB-S2) */
FE_NEEDS_BENDING = 0x20000000, /* not supported anymore, don't use (frontend
requires frequency bending) */
FE_CAN_RECOVER = 0x40000000, /* frontend can recover from a cable unplug
automatically */
FE_CAN_MUTE_TS = 0x80000000 /* frontend can stop spurious TS data output */
} fe_caps_t;

struct dvb_frontend_info {
char name[128];
fe_type_t type;
__u32 frequency_min;
__u32 frequency_max;
__u32 frequency_stepsize;
__u32 frequency_tolerance;
__u32 symbol_rate_min;
__u32 symbol_rate_max;
__u32 symbol_rate_tolerance; /* ppm */
__u32 notifier_delay; /* DEPRECATED */
fe_caps_t caps;
};

/**
* Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
* the meaning of this struct...
*/

struct dvb_diseqc_master_cmd {
__u8 msg [6]; /* { framing, address, command, data [3] } */
__u8 msg_len; /* valid values are 3...6 */
};

struct dvb_diseqc_slave_reply {
__u8 msg [4]; /* { framing, data [3] } */
__u8 msg_len; /* valid values are 0...4, 0 means no msg */
int timeout; /* return from ioctl after timeout ms with */
}; /* errorcode when no message was received */

typedef enum fe_sec_voltage {
SEC_VOLTAGE_13,
SEC_VOLTAGE_18,
SEC_VOLTAGE_OFF
} fe_sec_voltage_t;

typedef enum fe_sec_tone_mode {
SEC_TONE_ON,
SEC_TONE_OFF
} fe_sec_tone_mode_t;

typedef enum fe_sec_mini_cmd {
SEC_MINI_A,
SEC_MINI_B
} fe_sec_mini_cmd_t;

typedef enum fe_status {
FE_HAS_SIGNAL = 0x01, /* found something above the noise level */
FE_HAS_CARRIER = 0x02, /* found a DVB signal */
FE_HAS_VITERBI = 0x04, /* FEC is stable */
FE_HAS_SYNC = 0x08, /* found sync bytes */
FE_HAS_LOCK = 0x10, /* everything's working... */
FE_TIMEDOUT = 0x20, /* no lock within the last ~2 seconds */
FE_REINIT = 0x40 /* frontend was reinitialized, */
} fe_status_t; /* application is recommended to reset */

/* DiSEqC, tone and parameters */
typedef enum fe_spectral_inversion {
INVERSION_OFF,
INVERSION_ON,
INVERSION_AUTO
} fe_spectral_inversion_t;

typedef enum fe_code_rate {
FEC_NONE = 0,
FEC_1_2,
FEC_2_3,
FEC_3_4,
FEC_4_5,
FEC_5_6,
FEC_6_7,
FEC_7_8,
FEC_8_9,
FEC_AUTO,
FEC_3_5,
FEC_9_10,
} fe_code_rate_t;

typedef enum fe_modulation {
QPSK,
QAM_16,
QAM_32,
QAM_64,
QAM_128,
QAM_256,
QAM_AUTO,
VSB_8,
VSB_16,
PSK_8,
APSK_16,
APSK_32,
DQPSK,
} fe_modulation_t;

typedef enum fe_transmit_mode {
TRANSMISSION_MODE_2K,
TRANSMISSION_MODE_8K,
TRANSMISSION_MODE_AUTO
} fe_transmit_mode_t;

typedef enum fe_bandwidth {
BANDWIDTH_8_MHZ,
BANDWIDTH_7_MHZ,
BANDWIDTH_6_MHZ,
BANDWIDTH_AUTO
} fe_bandwidth_t;


typedef enum fe_guard_interval {
GUARD_INTERVAL_1_32,
GUARD_INTERVAL_1_16,
GUARD_INTERVAL_1_8,
GUARD_INTERVAL_1_4,
GUARD_INTERVAL_AUTO
} fe_guard_interval_t;


typedef enum fe_hierarchy {
HIERARCHY_NONE,
HIERARCHY_1,
HIERARCHY_2,
HIERARCHY_4,
HIERARCHY_AUTO
} fe_hierarchy_t;


struct dvb_qpsk_parameters {
__u32 symbol_rate; /* symbol rate in Symbols per second */
fe_code_rate_t fec_inner; /* forward error correction (see above) */
};

struct dvb_qam_parameters {
__u32 symbol_rate; /* symbol rate in Symbols per second */
fe_code_rate_t fec_inner; /* forward error correction (see above) */
fe_modulation_t modulation; /* modulation type (see above) */
};

struct dvb_vsb_parameters {
fe_modulation_t modulation; /* modulation type (see above) */
};

struct dvb_ofdm_parameters {
fe_bandwidth_t bandwidth;
fe_code_rate_t code_rate_HP; /* high priority stream code rate */
fe_code_rate_t code_rate_LP; /* low priority stream code rate */
fe_modulation_t constellation; /* modulation type (see above) */
fe_transmit_mode_t transmission_mode;
fe_guard_interval_t guard_interval;
fe_hierarchy_t hierarchy_information;
};


struct dvb_frontend_parameters {
__u32 frequency; /* (absolute) frequency in Hz for QAM/OFDM/ATSC */

/* intermediate frequency in kHz for QPSK */
fe_spectral_inversion_t inversion;
union {
struct dvb_qpsk_parameters qpsk;
struct dvb_qam_parameters qam;
struct dvb_ofdm_parameters ofdm;
struct dvb_vsb_parameters vsb;
} u;

};


struct dvb_frontend_event {
fe_status_t status;
struct dvb_frontend_parameters parameters;
};

/* S2API Commands */
#define DTV_UNDEFINED 0
#define DTV_TUNE 1
#define DTV_CLEAR 2
#define DTV_FREQUENCY 3
#define DTV_MODULATION 4
#define DTV_BANDWIDTH_HZ 5
#define DTV_INVERSION 6
#define DTV_DISEQC_MASTER 7
#define DTV_SYMBOL_RATE 8
#define DTV_INNER_FEC 9
#define DTV_VOLTAGE 10
#define DTV_TONE 11
#define DTV_PILOT 12
#define DTV_ROLLOFF 13
#define DTV_DISEQC_SLAVE_REPLY 14

/* Basic enumeration set for querying unlimited capabilities */
#define DTV_FE_CAPABILITY_COUNT 15
#define DTV_FE_CAPABILITY 16
#define DTV_DELIVERY_SYSTEM 17
#if 0

/* ISDB */

/* maybe a dup of DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID ??? */

#define DTV_ISDB_SEGMENT_IDX 18

/* 1, 3 or 13 ??? */

#define DTV_ISDB_SEGMENT_WIDTH 19

/* the central segment can be received independently or 1/3 seg in SB-mode
*/

#define DTV_ISDB_PARTIAL_RECEPTION 20

/* sound broadcasting is used 0 = 13segment, 1 = 1 or 3 see
DTV_ISDB_PARTIAL_RECEPTION */

#define DTV_ISDB_SOUND_BROADCASTING 21

/* only used in SB */

/* determines the initial PRBS of the segment (to match with 13seg channel)
*/
#define DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID 22
#define DTV_ISDB_LAYERA_FEC 23
#define DTV_ISDB_LAYERA_MODULATION 24
#define DTV_ISDB_LAYERA_SEGMENT_WIDTH 25
#define DTV_ISDB_LAYERA_TIME_INTERLEAVER 26
#define DTV_ISDB_LAYERB_FEC 27
#define DTV_ISDB_LAYERB_MODULATION 28
#define DTV_ISDB_LAYERB_SEGMENT_WIDTH 29
#define DTV_ISDB_LAYERB_TIME_INTERLEAVING 30
#define DTV_ISDB_LAYERC_FEC 31
#define DTV_ISDB_LAYERC_MODULATION 32
#define DTV_ISDB_LAYERC_SEGMENT_WIDTH 33
#define DTV_ISDB_LAYERC_TIME_INTERLEAVING 34

#endif
#define DTV_API_VERSION 35
#define DTV_API_VERSION 35
#define DTV_CODE_RATE_HP 36
#define DTV_CODE_RATE_LP 37
#define DTV_GUARD_INTERVAL 38
#define DTV_TRANSMISSION_MODE 39
#define DTV_HIERARCHY 40
#define DTV_MAX_COMMAND DTV_HIERARCHY

typedef enum fe_pilot {
PILOT_ON,
PILOT_OFF,
PILOT_AUTO,
} fe_pilot_t;

typedef enum fe_rolloff {
ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
ROLLOFF_20,
ROLLOFF_25,
ROLLOFF_AUTO,
} fe_rolloff_t;

typedef enum fe_delivery_system {
SYS_UNDEFINED,
SYS_DVBC_ANNEX_AC,
SYS_DVBC_ANNEX_B,
SYS_DVBT,
SYS_DSS,
SYS_DVBS,
SYS_DVBS2,
SYS_DVBH,
SYS_ISDBT,
SYS_ISDBS,
SYS_ISDBC,
SYS_ATSC,
SYS_ATSCMH,
SYS_DMBTH,
SYS_CMMB,
SYS_DAB,
} fe_delivery_system_t;

struct dtv_cmds_h {
char *name; /* A display name for debugging purposes */
__u32 cmd; /* A unique ID */
/* Flags */
__u32 set:1; /* Either a set or get property */
__u32 buffer:1; /* Does this property use the buffer? */
__u32 reserved:30; /* Align */
};

struct dtv_property {
__u32 cmd;
__u32 reserved[3];
union {
__u32 data;
struct {
__u8 data[32];
__u32 len;
__u32 reserved1[3];

void *reserved2;
} buffer;
} u;
int result;
} __attribute__ ((packed));

/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */

#define DTV_IOCTL_MAX_MSGS 64
struct dtv_properties {
__u32 num;
struct dtv_property *props;
};

#define FE_SET_PROPERTY _IOW('o', 82, struct dtv_properties)
#define FE_GET_PROPERTY _IOR('o', 83, struct dtv_properties)



/**
* When set, this flag will disable any zigzagging or other "normal" tuning
* behaviour. Additionally, there will be no automatic monitoring of the lock
* status, and hence no frontend events will be generated. If a frontend
device
* is closed, this flag will be automatically turned off when the device is
* reopened read-write.

*/

#define FE_TUNE_MODE_ONESHOT 0x01


#define FE_GET_INFO _IOR('o', 61, struct dvb_frontend_info)
#define FE_DISEQC_RESET_OVERLOAD _IO('o', 62)
#define FE_DISEQC_SEND_MASTER_CMD _IOW('o', 63, struct
dvb_diseqc_master_cmd)
#define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64, struct
dvb_diseqc_slave_reply)
#define FE_DISEQC_SEND_BURST _IO('o', 65) /* fe_sec_mini_cmd_t */
#define FE_SET_TONE _IO('o', 66) /* fe_sec_tone_mode_t */
#define FE_SET_VOLTAGE _IO('o', 67) /* fe_sec_voltage_t */
#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO('o', 68) /* int */
#define FE_READ_STATUS _IOR('o', 69, fe_status_t)
#define FE_READ_BER _IOR('o', 70, __u32)
#define FE_READ_SIGNAL_STRENGTH _IOR('o', 71, __u16)
#define FE_READ_SNR _IOR('o', 72, __u16)
#define FE_READ_UNCORRECTED_BLOCKS _IOR('o', 73, __u32)
#define FE_SET_FRONTEND _IOW('o', 76, struct dvb_frontend_parameters)
#define FE_GET_FRONTEND _IOR('o', 77, struct dvb_frontend_parameters)
#define FE_SET_FRONTEND_TUNE_MODE _IO('o', 81) /* unsigned int */
#define FE_GET_EVENT _IOR('o', 78, struct dvb_frontend_event)
#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */

#endif /*_DVBFRONTEND_H_*/




sorry about the structure of the text...

So I don't understand why my frontend doesn't recognized DVB-S2...
If anyone have an idea????

Thanks,

--001636c5a5373011780469df8fb0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi everyone!</div>
<div>=A0</div>
<div>I have a problem with my HVR-4000 card. </div>
<div>=A0</div>
<div>I installed the firmware cx24116 find on <a class=3D"external free" ti=
tle=3D"http://tevii.com/Tevii_linuxdriver_0815.rar" href=3D"http://tevii.co=
m/Tevii_linuxdriver_0815.rar" rel=3D"nofollow">http://tevii.com/Tevii_linux=
driver_0815.rar</a><br>
</div>
<div>sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw /lib/firmware/dvb-=
fe-cx24116-1.23.86.1.fw<br>sudo ln -s /lib/firmware/dvb-fe-cx24116-1.23.86.=
1.fw /lib/firmware/dvb-fe-cx24116.fw</div>
<div>=A0</div>
<div>I installed S2API find on <a href=3D"http://linuxtv.org/hg/~stoth/s2/"=
>http://linuxtv.org/hg/~stoth/s2/</a></div>
<div>=A0</div>
<div>make &amp; make install</div>
<div>cp ./linux/include/linux/dvb/* /usr/include/linux/dvb/</div>
<div>=A0</div>
<div>and I installed szap-s2 find on <a class=3D"external free" title=3D"ht=
tp://mercurial.intuxication.org/hg/szap-s2" href=3D"http://mercurial.intuxi=
cation.org/hg/szap-s2" rel=3D"nofollow">http://mercurial.intuxication.org/h=
g/szap-s2</a></div>

<div>=A0</div>
<div>Every seems to be ok...</div>
<div>I can tune an DVB-S signal, but not DVB-S2...</div>
<div>I try to tune a DVB-S2 signal with a symbols rate of 75335000 (&gt;450=
00000) and I have this error message with dmesg :</div>
<div><font size=3D"2"></font>=A0</div>
<div><font size=3D"2">[ 450.409150] DVB: frontend 0 symbol rate 75335000 ou=
t of range (1000000..45000000)</font></div>
<div>=A0</div>
<div>So I try dvbsnoop to see the frontend information :</div>
<div>=A0</div><font size=3D"2">
<div># dvbsnoop -s feinfo</div>
<div>dvbsnoop V1.4.50 -- <a href=3D"http://dvbsnoop.sourceforge.net/">http:=
//dvbsnoop.sourceforge.net/</a> </div>
<div>---------------------------------------------------------</div>
<div>FrontEnd Info...</div>
<div>---------------------------------------------------------</div>
<div>Device: /dev/dvb/adapter0/frontend0</div>
<div>Basic capabilities:</div>
<div>Name: &quot;Conexant CX24116/CX24118&quot;</div>
<div>Frontend-type: QPSK (DVB-S)</div>
<div>Frequency (min): 950.000 MHz</div>
<div>Frequency (max): 2150.000 MHz</div>
<div>Frequency stepsiz: 1.011 MHz</div>
<div>Frequency tolerance: 5.000 MHz</div>
<div>Symbol rate (min): 1.000000 MSym/s</div>
<div>Symbol rate (max): 45.000000 MSym/s</div>
<div>Symbol rate tolerance: 0 ppm</div>
<div>Notifier delay: 0 ms</div>
<div>Frontend capabilities:</div>
<div>auto inversion</div>
<div>FEC 1/2</div>
<div>FEC 2/3</div>
<div>FEC 3/4</div>
<div>FEC 4/5</div>
<div>FEC 5/6</div>
<div>FEC 6/7</div>
<div>FEC 7/8</div>
<div>FEC AUTO</div>
<div>QPSK</div>
<div>Current parameters:</div>
<div>Error(95): frontend ioctl: Operation not supported</div></font>
<div>=A0</div>
<div>That means the DVB-S2 frontend is not recognized... only DVB-S, but th=
is is my frontend (/dev/dvb/adapter0/frontend0) :</div>
<div>=A0</div><font size=3D"2">
<div>/*</div>
<div>* frontend.h</div>
<div>*</div>
<div>* Copyright (C) 2000 Marcus Metzler <a href=3D"mailto:marcus@convergen=
ce.de">marcus@convergence.de</a></div>
<div>* Ralph Metzler <a href=3D"mailto:ralph@convergence.de">ralph@converge=
nce.de</a></div>
<div>* Holger Waechtler <a href=3D"mailto:holger@convergence.de">holger@con=
vergence.de</a></div>
<div>*=A0Andre Draszik <a href=3D"mailto:ad@convergence.de">ad@convergence.=
de</a></div>
<div>* for convergence integrated media GmbH</div>
<div>*</div>
<div>* This program is free software; you can redistribute it and/or</div>
<div>* modify it under the terms of the GNU Lesser General Public License</=
div>
<div>* as published by the Free Software Foundation; either version 2.1</di=
v>
<div>* of the License, or (at your option) any later version.</div>
<div>*</div>
<div>* This program is distributed in the hope that it will be useful,</div=
>
<div>* but WITHOUT ANY WARRANTY; without even the implied warranty of</div>
<div>* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the</div>
<div>* GNU General Public License for more details.</div>
<div>*</div>
<div>* You should have received a copy of the GNU Lesser General Public Lic=
ense</div>
<div>* along with this program; if not, write to the Free Software</div>
<div>* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307=
, USA.</div>
<div>*</div>
<div>*/</div>
<div>#ifndef _DVBFRONTEND_H_</div>
<div>#define _DVBFRONTEND_H_</div>
<div>#include &lt;linux/types.h&gt;</div>
<div>=A0</div>
<div>typedef enum fe_type {</div>
<div>FE_QPSK,</div>
<div>FE_QAM,</div>
<div>FE_OFDM,</div>
<div>FE_ATSC</div>
<div>} fe_type_t;</div>
<div>=A0</div>
<div>typedef enum fe_caps {</div>
<div>FE_IS_STUPID =3D 0,</div>
<div>FE_CAN_INVERSION_AUTO =3D 0x1,</div>
<div>FE_CAN_FEC_1_2 =3D 0x2,</div>
<div>FE_CAN_FEC_2_3 =3D 0x4,</div>
<div>FE_CAN_FEC_3_4 =3D 0x8,</div>
<div>FE_CAN_FEC_4_5 =3D 0x10,</div>
<div>FE_CAN_FEC_5_6 =3D 0x20,</div>
<div>FE_CAN_FEC_6_7 =3D 0x40,</div>
<div>FE_CAN_FEC_7_8 =3D 0x80,</div>
<div>FE_CAN_FEC_8_9 =3D 0x100,</div>
<div>FE_CAN_FEC_AUTO =3D 0x200,</div>
<div>FE_CAN_QPSK =3D 0x400,</div>
<div>FE_CAN_QAM_16 =3D 0x800,</div>
<div>FE_CAN_QAM_32 =3D 0x1000,</div>
<div>FE_CAN_QAM_64 =3D 0x2000,</div>
<div>FE_CAN_QAM_128 =3D 0x4000,</div>
<div>FE_CAN_QAM_256 =3D 0x8000,</div>
<div>FE_CAN_QAM_AUTO =3D 0x10000,</div>
<div>FE_CAN_TRANSMISSION_MODE_AUTO =3D 0x20000,</div>
<div>FE_CAN_BANDWIDTH_AUTO =3D 0x40000,</div>
<div>FE_CAN_GUARD_INTERVAL_AUTO =3D 0x80000,</div>
<div>FE_CAN_HIERARCHY_AUTO =3D 0x100000,</div>
<div>FE_CAN_8VSB =3D 0x200000,</div>
<div>FE_CAN_16VSB =3D 0x400000,</div>
<div>FE_HAS_EXTENDED_CAPS =3D 0x800000, /* We need more bitspace for newer =
APIs, indicate this. */</div>
<div>FE_CAN_2G_MODULATION =3D 0x10000000, /* frontend supports &quot;2nd ge=
neration modulation&quot; (DVB-S2) */</div>
<div>FE_NEEDS_BENDING =3D 0x20000000, /* not supported anymore, don&#39;t u=
se (frontend requires frequency bending) */</div>
<div>FE_CAN_RECOVER =3D 0x40000000, /* frontend can recover from a cable un=
plug automatically */</div>
<div>FE_CAN_MUTE_TS =3D 0x80000000 /* frontend can stop spurious TS data ou=
tput */</div>
<div>} fe_caps_t;=A0</div>
<div>=A0</div>
<div>struct dvb_frontend_info {</div>
<div>char name[128];</div>
<div>fe_type_t type;</div>
<div>__u32 frequency_min;</div>
<div>__u32 frequency_max;</div>
<div>__u32 frequency_stepsize;</div>
<div>__u32 frequency_tolerance;</div>
<div>__u32 symbol_rate_min;</div>
<div>__u32 symbol_rate_max;</div>
<div>__u32 symbol_rate_tolerance; /* ppm */</div>
<div>__u32 notifier_delay; /* DEPRECATED */</div>
<div>fe_caps_t caps;</div>
<div>};</div>
<div>=A0</div>
<div>/**</div>
<div>* Check out the DiSEqC bus spec available on <a href=3D"http://www.eut=
elsat.org/">http://www.eutelsat.org/</a> for</div>
<div>* the meaning of this struct...</div>
<div>*/</div>
<div>=A0</div>
<div>struct dvb_diseqc_master_cmd {</div>
<div>__u8 msg [6]; /* { framing, address, command, data [3] } */</div>
<div>__u8 msg_len; /* valid values are 3...6 */</div>
<div>};</div>
<div>=A0</div>
<div>struct dvb_diseqc_slave_reply {</div>
<div>__u8 msg [4]; /* { framing, data [3] } */</div>
<div>__u8 msg_len; /* valid values are 0...4, 0 means no msg */</div>
<div>int timeout; /* return from ioctl after timeout ms with */</div>
<div>}; /* errorcode when no message was received */</div>
<div>=A0</div>
<div>typedef enum fe_sec_voltage {</div>
<div>SEC_VOLTAGE_13,</div>
<div>SEC_VOLTAGE_18,</div>
<div>SEC_VOLTAGE_OFF</div>
<div>} fe_sec_voltage_t;</div>
<div>=A0</div>
<div>typedef enum fe_sec_tone_mode {</div>
<div>SEC_TONE_ON,</div>
<div>SEC_TONE_OFF</div>
<div>} fe_sec_tone_mode_t;</div>
<div>=A0</div>
<div>typedef enum fe_sec_mini_cmd {</div>
<div>SEC_MINI_A,</div>
<div>SEC_MINI_B</div>
<div>} fe_sec_mini_cmd_t;</div>
<div>=A0</div>
<div>typedef enum fe_status {</div>
<div>FE_HAS_SIGNAL =3D 0x01, /* found something above the noise level */</d=
iv>
<div>FE_HAS_CARRIER =3D 0x02, /* found a DVB signal */</div>
<div>FE_HAS_VITERBI =3D 0x04, /* FEC is stable */</div>
<div>FE_HAS_SYNC =3D 0x08, /* found sync bytes */</div>
<div>FE_HAS_LOCK =3D 0x10, /* everything&#39;s working... */</div>
<div>FE_TIMEDOUT =3D 0x20, /* no lock within the last ~2 seconds */</div>
<div>FE_REINIT =3D 0x40 /* frontend was reinitialized, */</div>
<div>} fe_status_t; /* application is recommended to reset */</div>
<p>/* DiSEqC, tone and parameters */</p>
<div>typedef enum fe_spectral_inversion {</div>
<div>INVERSION_OFF,</div>
<div>INVERSION_ON,</div>
<div>INVERSION_AUTO</div>
<div>} fe_spectral_inversion_t;</div>
<div>=A0</div>
<div>typedef enum fe_code_rate {</div>
<div>FEC_NONE =3D 0,</div>
<div>FEC_1_2,</div>
<div>FEC_2_3,</div>
<div>FEC_3_4,</div>
<div>FEC_4_5,</div>
<div>FEC_5_6,</div>
<div>FEC_6_7,</div>
<div>FEC_7_8,</div>
<div>FEC_8_9,</div>
<div>FEC_AUTO,</div>
<div>FEC_3_5,</div>
<div>FEC_9_10,</div>
<div>} fe_code_rate_t;</div>
<div>=A0</div>
<div>typedef enum fe_modulation {</div>
<div>QPSK,</div>
<div>QAM_16,</div>
<div>QAM_32,</div>
<div>QAM_64,</div>
<div>QAM_128,</div>
<div>QAM_256,</div>
<div>QAM_AUTO,</div>
<div>VSB_8,</div>
<div>VSB_16,</div>
<div>PSK_8,</div>
<div>APSK_16,</div>
<div>APSK_32,</div>
<div>DQPSK,</div>
<div>} fe_modulation_t;</div>
<div>=A0</div>
<div>typedef enum fe_transmit_mode {</div>
<div>TRANSMISSION_MODE_2K,</div>
<div>TRANSMISSION_MODE_8K,</div>
<div>TRANSMISSION_MODE_AUTO</div>
<div>} fe_transmit_mode_t;</div>
<div>=A0</div>
<div>typedef enum fe_bandwidth {</div>
<div>BANDWIDTH_8_MHZ,</div>
<div>BANDWIDTH_7_MHZ,</div>
<div>BANDWIDTH_6_MHZ,</div>
<div>BANDWIDTH_AUTO</div>
<div>} fe_bandwidth_t;</div>
<p>=A0</p>
<div>typedef enum fe_guard_interval {</div>
<div>GUARD_INTERVAL_1_32,</div>
<div>GUARD_INTERVAL_1_16,</div>
<div>GUARD_INTERVAL_1_8,</div>
<div>GUARD_INTERVAL_1_4,</div>
<div>GUARD_INTERVAL_AUTO</div>
<div>} fe_guard_interval_t;</div>
<p>=A0</p>
<div>typedef enum fe_hierarchy {</div>
<div>HIERARCHY_NONE,</div>
<div>HIERARCHY_1,</div>
<div>HIERARCHY_2,</div>
<div>HIERARCHY_4,</div>
<div>HIERARCHY_AUTO</div>
<div>} fe_hierarchy_t;</div>
<p>=A0</p>
<div>struct dvb_qpsk_parameters {</div>
<div>__u32 symbol_rate; /* symbol rate in Symbols per second */</div>
<div>fe_code_rate_t fec_inner; /* forward error correction (see above) */</=
div>
<div>};</div>
<div>=A0</div>
<div>struct dvb_qam_parameters {</div>
<div>__u32 symbol_rate; /* symbol rate in Symbols per second */</div>
<div>fe_code_rate_t fec_inner; /* forward error correction (see above) */</=
div>
<div>fe_modulation_t modulation; /* modulation type (see above) */</div>
<div>};</div>
<div>=A0</div>
<div>struct dvb_vsb_parameters {</div>
<div>fe_modulation_t modulation; /* modulation type (see above) */</div>
<div>};</div>
<div>=A0</div>
<div>struct dvb_ofdm_parameters {</div>
<div>fe_bandwidth_t bandwidth;</div>
<div>fe_code_rate_t code_rate_HP; /* high priority stream code rate */</div=
>
<div>fe_code_rate_t code_rate_LP; /* low priority stream code rate */</div>
<div>fe_modulation_t constellation; /* modulation type (see above) */</div>
<div>fe_transmit_mode_t transmission_mode;</div>
<div>fe_guard_interval_t guard_interval;</div>
<div>fe_hierarchy_t hierarchy_information;</div>
<div>};</div>
<p>=A0</p>
<div>struct dvb_frontend_parameters {</div>
<div>__u32 frequency; /* (absolute) frequency in Hz for QAM/OFDM/ATSC */</d=
iv>
<div>=A0</div>
<div>/* intermediate frequency in kHz for QPSK */</div>
<div>fe_spectral_inversion_t inversion;</div>
<div>union {</div>
<div>struct dvb_qpsk_parameters qpsk;</div>
<div>struct dvb_qam_parameters qam;</div>
<div>struct dvb_ofdm_parameters ofdm;</div>
<div>struct dvb_vsb_parameters vsb;</div>
<div>} u;</div>
<div>=A0</div>
<div>};</div>
<p>=A0</p>
<div>struct dvb_frontend_event {</div>
<div>fe_status_t status;</div>
<div>struct dvb_frontend_parameters parameters;</div>
<div>};</div>
<div>=A0</div>
<div>/* S2API Commands */</div>
<div>#define DTV_UNDEFINED 0</div>
<div>#define DTV_TUNE 1</div>
<div>#define DTV_CLEAR 2</div>
<div>#define DTV_FREQUENCY 3</div>
<div>#define DTV_MODULATION 4</div>
<div>#define DTV_BANDWIDTH_HZ 5</div>
<div>#define DTV_INVERSION 6</div>
<div>#define DTV_DISEQC_MASTER 7</div>
<div>#define DTV_SYMBOL_RATE 8</div>
<div>#define DTV_INNER_FEC 9</div>
<div>#define DTV_VOLTAGE 10</div>
<div>#define DTV_TONE 11</div>
<div>#define DTV_PILOT 12</div>
<div>#define DTV_ROLLOFF 13</div>
<div>#define DTV_DISEQC_SLAVE_REPLY 14</div>
<div>=A0</div>
<div>/* Basic enumeration set for querying unlimited capabilities */</div>
<div>#define DTV_FE_CAPABILITY_COUNT 15</div>
<div>#define DTV_FE_CAPABILITY 16</div>
<div>#define DTV_DELIVERY_SYSTEM 17</div>
<div>#if 0</div>
<p>/* ISDB */</p>
<p>/* maybe a dup of DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID ??? */</p>
<p>#define DTV_ISDB_SEGMENT_IDX 18</p>
<p>/* 1, 3 or 13 ??? */</p>
<p>#define DTV_ISDB_SEGMENT_WIDTH 19</p>
<p>/* the central segment can be received independently or 1/3 seg in SB-mo=
de */</p>
<p>#define DTV_ISDB_PARTIAL_RECEPTION 20</p>
<p>/* sound broadcasting is used 0 =3D 13segment, 1 =3D 1 or 3 see DTV_ISDB=
_PARTIAL_RECEPTION */</p>
<p>#define DTV_ISDB_SOUND_BROADCASTING 21</p>
<p>/* only used in SB */</p>
<p>/* determines the initial PRBS of the segment (to match with 13seg chann=
el) */</p>
<div>#define DTV_ISDB_SOUND_BROADCASTING_SUBCHANNEL_ID 22</div>
<div>#define DTV_ISDB_LAYERA_FEC 23</div>
<div>#define DTV_ISDB_LAYERA_MODULATION 24</div>
<div>#define DTV_ISDB_LAYERA_SEGMENT_WIDTH 25</div>
<div>#define DTV_ISDB_LAYERA_TIME_INTERLEAVER 26</div>
<div>#define DTV_ISDB_LAYERB_FEC 27</div>
<div>#define DTV_ISDB_LAYERB_MODULATION 28</div>
<div>#define DTV_ISDB_LAYERB_SEGMENT_WIDTH 29</div>
<div>#define DTV_ISDB_LAYERB_TIME_INTERLEAVING 30</div>
<div>#define DTV_ISDB_LAYERC_FEC 31</div>
<div>#define DTV_ISDB_LAYERC_MODULATION 32</div>
<div>#define DTV_ISDB_LAYERC_SEGMENT_WIDTH 33</div>
<div>#define DTV_ISDB_LAYERC_TIME_INTERLEAVING 34</div>
<p>#endif</p>
<div>#define DTV_API_VERSION 35</div>
<div>#define DTV_API_VERSION 35</div>
<div>#define DTV_CODE_RATE_HP 36</div>
<div>#define DTV_CODE_RATE_LP 37</div>
<div>#define DTV_GUARD_INTERVAL 38</div>
<div>#define DTV_TRANSMISSION_MODE 39</div>
<div>#define DTV_HIERARCHY 40</div>
<div>#define DTV_MAX_COMMAND DTV_HIERARCHY</div>
<div>=A0</div>
<div>typedef enum fe_pilot {</div>
<div>PILOT_ON,</div>
<div>PILOT_OFF,</div>
<div>PILOT_AUTO,</div>
<div>} fe_pilot_t;</div>
<div>=A0</div>
<div>typedef enum fe_rolloff {</div>
<div>ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */</div>
<div>ROLLOFF_20,</div>
<div>ROLLOFF_25,</div>
<div>ROLLOFF_AUTO,</div>
<div>} fe_rolloff_t;</div>
<div>=A0</div>
<div>typedef enum fe_delivery_system {</div>
<div>SYS_UNDEFINED,</div>
<div>SYS_DVBC_ANNEX_AC,</div>
<div>SYS_DVBC_ANNEX_B,</div>
<div>SYS_DVBT,</div>
<div>SYS_DSS,</div>
<div>SYS_DVBS,</div>
<div>SYS_DVBS2,</div>
<div>SYS_DVBH,</div>
<div>SYS_ISDBT,</div>
<div>SYS_ISDBS,</div>
<div>SYS_ISDBC,</div>
<div>SYS_ATSC,</div>
<div>SYS_ATSCMH,</div>
<div>SYS_DMBTH,</div>
<div>SYS_CMMB,</div>
<div>SYS_DAB,</div>
<div>} fe_delivery_system_t;</div>
<div>=A0</div>
<div>struct dtv_cmds_h {</div>
<div>char *name; /* A display name for debugging purposes */</div>
<div>__u32 cmd; /* A unique ID */</div>
<div>/* Flags */</div>
<div>__u32 set:1; /* Either a set or get property */</div>
<div>__u32 buffer:1; /* Does this property use the buffer? */</div>
<div>__u32 reserved:30; /* Align */</div>
<div>};</div>
<div>=A0</div>
<div>struct dtv_property {</div>
<div>__u32 cmd;</div>
<div>__u32 reserved[3];</div>
<div>union {</div>
<div>__u32 data;</div>
<div>struct {</div>
<div>__u8 data[32];</div>
<div>__u32 len;</div>
<div>__u32 reserved1[3];</div>
<div>=A0</div>
<div>void *reserved2;</div>
<div>} buffer;</div>
<div>} u;</div>
<div>int result;</div>
<div>} __attribute__ ((packed));</div>
<p>/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */</p>
<p>#define DTV_IOCTL_MAX_MSGS 64</p>
<div>struct dtv_properties {</div>
<div>__u32 num;</div>
<div>struct dtv_property *props;</div>
<div>};</div>
<div>=A0</div>
<div>#define FE_SET_PROPERTY _IOW(&#39;o&#39;, 82, struct dtv_properties)</=
div>
<div>#define FE_GET_PROPERTY _IOR(&#39;o&#39;, 83, struct dtv_properties)</=
div>
<p>=A0</p>
<p>/**</p>
<div>* When set, this flag will disable any zigzagging or other &quot;norma=
l&quot; tuning</div>
<div>* behaviour. Additionally, there will be no automatic monitoring of th=
e lock</div>
<div>* status, and hence no frontend events will be generated. If a fronten=
d device</div>
<div>* is closed, this flag will be automatically turned off when the devic=
e is</div>
<div>* reopened read-write.</div>
<p>*/</p>
<p>#define FE_TUNE_MODE_ONESHOT 0x01</p>
<p>=A0</p>
<div>#define FE_GET_INFO _IOR(&#39;o&#39;, 61, struct dvb_frontend_info)</d=
iv>
<div>#define FE_DISEQC_RESET_OVERLOAD _IO(&#39;o&#39;, 62)</div>
<div>#define FE_DISEQC_SEND_MASTER_CMD _IOW(&#39;o&#39;, 63, struct dvb_dis=
eqc_master_cmd)</div>
<div>#define FE_DISEQC_RECV_SLAVE_REPLY _IOR(&#39;o&#39;, 64, struct dvb_di=
seqc_slave_reply)</div>
<div>#define FE_DISEQC_SEND_BURST _IO(&#39;o&#39;, 65) /* fe_sec_mini_cmd_t=
 */</div>
<div>#define FE_SET_TONE _IO(&#39;o&#39;, 66) /* fe_sec_tone_mode_t */</div=
>
<div>#define FE_SET_VOLTAGE _IO(&#39;o&#39;, 67) /* fe_sec_voltage_t */</di=
v>
<div>#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO(&#39;o&#39;, 68) /* int */</div=
>
<div>#define FE_READ_STATUS _IOR(&#39;o&#39;, 69, fe_status_t)</div>
<div>#define FE_READ_BER _IOR(&#39;o&#39;, 70, __u32)</div>
<div>#define FE_READ_SIGNAL_STRENGTH _IOR(&#39;o&#39;, 71, __u16)</div>
<div>#define FE_READ_SNR _IOR(&#39;o&#39;, 72, __u16)</div>
<div>#define FE_READ_UNCORRECTED_BLOCKS _IOR(&#39;o&#39;, 73, __u32)</div>
<div>#define FE_SET_FRONTEND _IOW(&#39;o&#39;, 76, struct dvb_frontend_para=
meters)</div>
<div>#define FE_GET_FRONTEND _IOR(&#39;o&#39;, 77, struct dvb_frontend_para=
meters)</div>
<div>#define FE_SET_FRONTEND_TUNE_MODE _IO(&#39;o&#39;, 81) /* unsigned int=
 */</div>
<div>#define FE_GET_EVENT _IOR(&#39;o&#39;, 78, struct dvb_frontend_event)<=
/div>
<div>#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO(&#39;o&#39;, 80) /* unsigne=
d int */</div>
<div>=A0</div>
<div>#endif /*_DVBFRONTEND_H_*/</div></font>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div>sorry about the structure of the text...</div>
<div>=A0</div>
<div>So I don&#39;t understand why my frontend doesn&#39;t recognized DVB-S=
2...</div>
<div>If anyone have an idea????</div>
<div>=A0</div>
<div>Thanks,</div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>

--001636c5a5373011780469df8fb0--


--===============0283147507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0283147507==--
