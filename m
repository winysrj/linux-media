Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50514 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbbAMV2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 16:28:13 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so5376370wes.1
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 13:28:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
	<CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com>
	<CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
	<CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
Date: Tue, 13 Jan 2015 22:28:11 +0100
Message-ID: <CAPx3zdRNEKy=3yaVYpzOm7yiQjmoKDdwSgNu3Y41ikbCn0-Dig@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
From: Francesco Other <francesco.other@gmail.com>
To: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the previous message, maybe it isn't readable!

I created a file named frequency with this content:

# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy

T 698000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO # Mediaset 4

--------------------------------------------

but when I scan with command

scan frequency > channels.conf

I obtained a blank file.

This is the output:

$ scan frequency > channels.conf
scanning frequency
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 698000000 0 9 9 6 2 4 4
>>> tune to: 698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.

--------------------------------------------

This is the system log when scanning is active (at the end I
disconnected the device):

Jan 13 22:25:01 Linux kernel: [ 2274.543224] smsusb_sendrequest:
sending MSG_SMS_RF_TUNE_REQ(561) size: 20
Jan 13 22:25:01 Linux kernel: [ 2274.581759] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 22:25:01 Linux kernel: [ 2274.581874] smsusb_onresponse:
received MSG_SMS_RF_TUNE_RES(562) size: 12
Jan 13 22:25:01 Linux kernel: [ 2274.684257] smsusb_onresponse:
received MSG_SMS_HO_INBAND_POWER_IND(631) size: 16
Jan 13 22:25:01 Linux kernel: [ 2274.743291] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:01 Linux kernel: [ 2274.743498] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:01 Linux kernel: [ 2274.943586] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:01 Linux kernel: [ 2274.943758] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:01 Linux kernel: [ 2274.980125] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:01 Linux kernel: [ 2275.002873] smsusb_onresponse:
received MSG_SMS_SIGNAL_DETECTED_IND(827) size: 8
Jan 13 22:25:01 Linux kernel: [ 2275.002885] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 22:25:01 Linux kernel: [ 2275.002999] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:01 Linux kernel: [ 2275.003998] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:01 Linux kernel: [ 2275.080006] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:01 Linux kernel: [ 2275.143858] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:01 Linux kernel: [ 2275.144021] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:01 Linux kernel: [ 2275.144108] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.144255] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.144381] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.144503] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.144531] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.144628] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 22:25:01 Linux kernel: [ 2275.179880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:01 Linux kernel: [ 2275.279749] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:02 Linux kernel: [ 2275.302998] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:02 Linux kernel: [ 2275.380029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:02 Linux kernel: [ 2275.380748] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:02 Linux kernel: [ 2275.380997] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:02 Linux kernel: [ 2275.480632] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 22:25:02 Linux kernel: [ 2275.580511] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:02 Linux kernel: [ 2275.681380] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:02 Linux kernel: [ 2275.781258] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:02 Linux kernel: [ 2275.882253] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:02 Linux kernel: [ 2275.983128] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:02 Linux kernel: [ 2276.000999] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:02 Linux kernel: [ 2276.083004] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:02 Linux kernel: [ 2276.182878] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:02 Linux kernel: [ 2276.203501] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:02 Linux kernel: [ 2276.283880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:02 Linux kernel: [ 2276.296024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:02 Linux kernel: [ 2276.296129] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:03 Linux kernel: [ 2276.383760] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:03 Linux kernel: [ 2276.484631] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:03 Linux kernel: [ 2276.585133] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:03 Linux kernel: [ 2276.587499] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:03 Linux kernel: [ 2276.786382] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:03 Linux kernel: [ 2276.886254] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:03 Linux kernel: [ 2276.928024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:03 Linux kernel: [ 2276.928248] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:03 Linux kernel: [ 2276.987134] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:03 Linux kernel: [ 2277.087009] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2828
Jan 13 22:25:03 Linux kernel: [ 2277.187882] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:03 Linux kernel: [ 2277.287751] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:04 Linux kernel: [ 2277.387754] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:04 Linux kernel: [ 2277.403125] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:04 Linux kernel: [ 2277.404024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:04 Linux kernel: [ 2277.404248] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:04 Linux kernel: [ 2277.587510] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:04 Linux kernel: [ 2277.788386] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:04 Linux kernel: [ 2277.812024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:04 Linux kernel: [ 2277.812249] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:04 Linux kernel: [ 2277.888257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:04 Linux kernel: [ 2277.988128] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:04 Linux kernel: [ 2278.089003] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:04 Linux kernel: [ 2278.189883] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:04 Linux kernel: [ 2278.212024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:04 Linux kernel: [ 2278.212130] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:05 Linux kernel: [ 2278.369009] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:05 Linux kernel: [ 2278.468753] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:05 Linux kernel: [ 2278.568637] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:05 Linux kernel: [ 2278.599255] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:05 Linux kernel: [ 2278.644030] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:05 Linux kernel: [ 2278.660253] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:05 Linux kernel: [ 2278.668500] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 22:25:05 Linux kernel: [ 2278.768386] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:05 Linux kernel: [ 2278.868255] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:05 Linux kernel: [ 2278.968129] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:05 Linux kernel: [ 2279.069129] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:05 Linux kernel: [ 2279.140026] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:05 Linux kernel: [ 2279.140250] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:05 Linux kernel: [ 2279.169005] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:06 Linux kernel: [ 2279.368762] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:06 Linux kernel: [ 2279.468630] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:06 Linux kernel: [ 2279.568637] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:06 Linux kernel: [ 2279.668505] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:06 Linux kernel: [ 2279.684039] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:06 Linux kernel: [ 2279.684251] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:06 Linux kernel: [ 2279.769378] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:06 Linux kernel: [ 2279.799877] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:06 Linux kernel: [ 2279.869262] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:06 Linux kernel: [ 2279.969137] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:06 Linux kernel: [ 2279.973501] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:06 Linux kernel: [ 2280.073136] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:06 Linux kernel: [ 2280.174009] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:06 Linux kernel: [ 2280.273877] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 22:25:06 Linux kernel: [ 2280.300023] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:06 Linux kernel: [ 2280.300132] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:07 Linux kernel: [ 2280.373756] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:07 Linux kernel: [ 2280.573638] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:07 Linux kernel: [ 2280.673506] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:07 Linux kernel: [ 2280.774379] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:07 Linux kernel: [ 2280.874257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:07 Linux kernel: [ 2280.974261] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:07 Linux kernel: [ 2280.988026] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:07 Linux kernel: [ 2280.988251] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:07 Linux kernel: [ 2280.997250] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:07 Linux kernel: [ 2281.074138] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:25:07 Linux kernel: [ 2281.150806] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 22:25:07 Linux kernel: [ 2281.151000] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 22:25:07 Linux kernel: [ 2281.174012] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:07 Linux kernel: [ 2281.274880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:08 Linux kernel: [ 2281.374757] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:08 Linux kernel: [ 2281.475627] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:08 Linux kernel: [ 2281.575637] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 22:25:08 Linux kernel: [ 2281.641257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 22:25:08 Linux kernel: [ 2281.740503] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:08 Linux kernel: [ 2281.748027] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:08 Linux kernel: [ 2281.748131] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:08 Linux kernel: [ 2281.840385] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3580
Jan 13 22:25:08 Linux kernel: [ 2281.941263] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 22:25:08 Linux kernel: [ 2282.142008] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:08 Linux kernel: [ 2282.151960] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 22:25:08 Linux kernel: [ 2282.152125] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 22:25:08 Linux kernel: [ 2282.196762] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:08 Linux kernel: [ 2282.242003] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:09 Linux kernel: [ 2282.342878] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:09 Linux kernel: [ 2282.543636] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:09 Linux kernel: [ 2282.576034] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:09 Linux kernel: [ 2282.576249] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:09 Linux kernel: [ 2282.643632] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:09 Linux kernel: [ 2282.743379] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:09 Linux kernel: [ 2282.843380] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:09 Linux kernel: [ 2282.943262] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:09 Linux kernel: [ 2283.043137] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:09 Linux kernel: [ 2283.143009] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:09 Linux kernel: [ 2283.243007] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:10 Linux kernel: [ 2283.342879] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:10 Linux kernel: [ 2283.352628] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:10 Linux kernel: [ 2283.396256] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:10 Linux kernel: [ 2283.450753] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3016
Jan 13 22:25:10 Linux kernel: [ 2283.468029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:10 Linux kernel: [ 2283.473877] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:10 Linux kernel: [ 2283.550627] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:10 Linux kernel: [ 2283.751512] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:10 Linux kernel: [ 2283.851381] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:10 Linux kernel: [ 2283.951259] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:10 Linux kernel: [ 2284.152013] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:10 Linux kernel: [ 2284.252015] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:11 Linux kernel: [ 2284.352880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:11 Linux kernel: [ 2284.420127] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:11 Linux kernel: [ 2284.420262] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:11 Linux kernel: [ 2284.452754] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:25:11 Linux kernel: [ 2284.553629] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:11 Linux kernel: [ 2284.592392] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:11 Linux kernel: [ 2284.654633] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:11 Linux kernel: [ 2284.754507] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:11 Linux kernel: [ 2284.854387] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 22:25:11 Linux kernel: [ 2284.954257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:11 Linux kernel: [ 2284.997640] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:25:11 Linux kernel: [ 2285.096139] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 22:25:11 Linux kernel: [ 2285.196010] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:11 Linux kernel: [ 2285.296880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:12 Linux kernel: [ 2285.396890] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:12 Linux kernel: [ 2285.416026] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:12 Linux kernel: [ 2285.416132] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:12 Linux kernel: [ 2285.598643] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:12 Linux kernel: [ 2285.793135] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:12 Linux kernel: [ 2285.798504] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 22:25:12 Linux kernel: [ 2285.898387] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:12 Linux kernel: [ 2285.998264] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:12 Linux kernel: [ 2286.098137] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:12 Linux kernel: [ 2286.198013] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:13 Linux kernel: [ 2286.398886] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:13 Linux kernel: [ 2286.460029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:13 Linux kernel: [ 2286.471004] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:13 Linux kernel: [ 2286.498755] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:13 Linux kernel: [ 2286.598765] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3204
Jan 13 22:25:13 Linux kernel: [ 2286.698514] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:13 Linux kernel: [ 2286.799381] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:13 Linux kernel: [ 2286.899387] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:13 Linux kernel: [ 2286.984639] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:13 Linux kernel: [ 2286.991509] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:13 Linux kernel: [ 2287.083135] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:13 Linux kernel: [ 2287.183007] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:14 Linux kernel: [ 2287.383884] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:14 Linux kernel: [ 2287.483758] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 22:25:14 Linux kernel: [ 2287.552025] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:14 Linux kernel: [ 2287.552136] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:14 Linux kernel: [ 2287.583756] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:14 Linux kernel: [ 2287.684641] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:14 Linux kernel: [ 2287.784507] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:14 Linux kernel: [ 2287.884385] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:14 Linux kernel: [ 2287.984257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:14 Linux kernel: [ 2288.084266] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:14 Linux kernel: [ 2288.184134] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 22:25:14 Linux kernel: [ 2288.187631] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:14 Linux kernel: [ 2288.284008] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 22:25:15 Linux kernel: [ 2288.383892] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:15 Linux kernel: [ 2288.483764] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:15 Linux kernel: [ 2288.583631] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:15 Linux kernel: [ 2288.676040] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:15 Linux kernel: [ 2288.676252] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:15 Linux kernel: [ 2288.684630] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:15 Linux kernel: [ 2288.784507] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:15 Linux kernel: [ 2288.885386] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:15 Linux kernel: [ 2288.986257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:15 Linux kernel: [ 2288.994254] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:15 Linux kernel: [ 2289.094265] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:15 Linux kernel: [ 2289.194140] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:15 Linux kernel: [ 2289.294011] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:16 Linux kernel: [ 2289.388383] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:16 Linux kernel: [ 2289.394880] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:16 Linux kernel: [ 2289.594760] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:16 Linux kernel: [ 2289.694640] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:16 Linux kernel: [ 2289.795508] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3204
Jan 13 22:25:16 Linux kernel: [ 2289.828025] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:16 Linux kernel: [ 2289.828135] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:16 Linux kernel: [ 2289.895388] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:16 Linux kernel: [ 2289.995258] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:16 Linux kernel: [ 2290.095263] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:16 Linux kernel: [ 2290.196141] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:17 Linux kernel: [ 2290.395886] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:17 Linux kernel: [ 2290.586763] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:17 Linux kernel: [ 2290.595756] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 22:25:17 Linux kernel: [ 2290.695642] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:17 Linux kernel: [ 2290.766257] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 22:25:17 Linux kernel: [ 2290.866510] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 22:25:17 Linux kernel: [ 2290.966384] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:17 Linux kernel: [ 2291.004024] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:25:17 Linux kernel: [ 2291.004136] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:25:17 Linux kernel: [ 2291.067258] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:17 Linux kernel: [ 2291.161362] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 22:25:17 Linux kernel: [ 2291.161515] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 22:25:17 Linux kernel: [ 2291.167134] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 22:25:17 Linux kernel: [ 2291.268142] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2452
Jan 13 22:25:18 Linux kernel: [ 2291.368007] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 22:25:18 Linux kernel: [ 2291.467890] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 22:25:18 Linux kernel: [ 2291.568758] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:18 Linux kernel: [ 2291.769517] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 22:25:18 Linux kernel: [ 2291.785142] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:25:18 Linux kernel: [ 2291.869511] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 22:25:18 Linux kernel: [ 2291.969389] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:18 Linux kernel: [ 2292.070260] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 22:25:18 Linux kernel: [ 2292.149215] usb 1-1: USB disconnect,
device number 9

--------------------------------------------

Now, in which way can I tzap?

Regards

Francesco

2015-01-13 17:13 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
> Good to know about DVB on this chip. This is sms2270 id :-)
>
> I think you can get more  information from module debug messages.
>
> Try
>         options smsusb debug=3
> on /etc/modprobe.d.
>
> Then reload it and try to tzap one of channels found by scan to look
> for some lock.  You will have more debug messages now.
>
> Cheers,
>  - Roberto
>
>
>
>
>  - Roberto
>
>
> On Tue, Jan 13, 2015 at 12:35 PM, Francesco Other
> <francesco.other@gmail.com> wrote:
>> Hi Roberto, thanks for your fast reply.
>>
>> I'm from Italy, a DVB-T region. With Windows the device works fine, it
>> receives all the channels from multiplexes.
>> I don't know if my device has the SMS2270 chip, I know the ID,
>> 187f:0600, and the link on the Terratec site:
>> http://www.terratec.net/details.php?artnr=145258#.VLU5Z2SG9LY
>>
>> In that site there are the software and the Windows driver, if you
>> install those driver you can obtain the dvb_rio.inp driver from
>> system32 folder.
>> I forced the DVB-T mode because without it in dmesg output I see that
>> system ask for isdbt_rio.inp, but with DVB-T forced mode the system
>> ask for dvb_rio.inp.
>>
>> I can't understand why I can't receive any channels from multiplexes,
>> the signal is ok, I can see this from many software (Kaffeine, w_scan,
>> scan, TvHeadend).
>>
>> Can you help me please?
>>
>> Best Regards
>>
>> Francesco
>>
>>
>> 2015-01-13 16:21 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
>>> Hi Francesco,
>>>
>>> You are using Siano SMS2270, am I right?
>>>
>>> My guess you're using ISDB-T firmware to program your ic, but are you in
>>> ISDB-T region? I use same firmware name here and works fine (Brazil) and it
>>> seems loaded ok on your log.
>>>
>>> I never saw an DVB firmware available to sms2270. Your tuner is working fine
>>> under Windows with provided software ?
>>>
>>> Cheers,
>>>   - Roberto
>>>
>>>
>>>
>>>
>>>
>>>
>>>  - Roberto
>>>
>>> On Tue, Jan 13, 2015 at 11:50 AM, Francesco Other
>>> <francesco.other@gmail.com> wrote:
>>>>
>>>> Is there a gentleman that can help me with my problem? On linuxtv.org
>>>> they said that someone here sure will help me.
>>>>
>>>> I submitted the problem here:
>>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>>
>>>> Regards
>>>>
>>>> Francesco
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
