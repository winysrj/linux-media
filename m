Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:53981 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab2FZKY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 06:24:29 -0400
Received: from ONYX.xi-lite.lan (unknown [193.34.35.244])
	by co202.xi-lite.net (Postfix) with ESMTPS id E94E0260282
	for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 12:26:56 +0200 (CEST)
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 26 Jun 2012 11:25:28 +0100
Subject: RE: DiBcom adapter problems
Message-ID: <C73E570AC040D442A4DD326F39F0F00E138E953403@SAPHIR.xi-lite.lan>
References: <CAHPEttnVm-wMN1N_Ay2tfbxsZyvFBCtGmSfAYRNZuoH3nX1PxQ@mail.gmail.com>
In-Reply-To: <CAHPEttnVm-wMN1N_Ay2tfbxsZyvFBCtGmSfAYRNZuoH3nX1PxQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
the xc5000 seems not to support DMB-T/H: "[ 2458.525608] xc5000: delivery system is not supported!". Anyway, this is not related to the dibcom device.

regards,
Olivier
________________________________________
From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Choi Wing Chan [chanchoiwing@gmail.com]
Sent: Sunday, June 24, 2012 12:06 AM
To: linux-media@vger.kernel.org
Subject: RE: DiBcom adapter problems

the patch correct the error about no support system, however, my card
still can not scan any channels.

[ 2458.524854] set_delivery_system() Using delivery system 13 emulated
as if it were a 3
[ 2458.524855] change delivery system on cache to 13
[ 2458.524857] dvbv3_type : delivery_system = 13
[ 2458.524858] dtv_property_cache_sync() Preparing OFDM req
[ 2458.524859] dvbv3_type : delivery_system = 13
[ 2458.524860] dtv_property_legacy_params_sync() Preparing OFDM req
[ 2458.524861] dvb_frontend_add_event
[ 2458.524896] dvb_frontend_swzigzag_autotune: drift:0 inversion:0
auto_step:0 auto_sub_step:0 started_auto_step:0
[ 2458.524899] lgs8gxx: lgs8gxx_set_fe
[ 2458.525608] xc5000: delivery system is not supported!
[ 2458.525610] lgs8gxx: lgs8gxx_auto_detect
[ 2458.527558] lgs8gxx: try GI 945
[ 2458.724898] dvb_frontend_ioctl (69)
[ 2460.670065] lgs8gxx: try GI 945
[ 2462.812594] lgs8gxx: try GI 420
[ 2464.955133] lgs8gxx: try GI 420
[ 2467.097660] lgs8gxx: try GI 595
[ 2469.240181] lgs8gxx: try GI 945
[ 2471.382719] lgs8gxx: try GI 945
[ 2473.525253] lgs8gxx: try GI 420
[ 2475.667781] lgs8gxx: try GI 420
[ 2477.810317] lgs8gxx: try GI 595
[ 2479.952853] lgs8gxx: lgs8gxx_auto_detect failed
[ 2480.067822] lgs8gxx: lgs8gxx_read_status
[ 2480.069688] lgs8gxx: AFC = 5469 kHz
[ 2480.070629] lgs8gxx: Reg 0x4B: 0x02
[ 2480.070630] lgs8gxx: lgs8gxx_read_status: fe_status=0x0
[ 2480.270678] dvb_frontend_ioctl (69)
[ 2480.270680] lgs8gxx: lgs8gxx_read_status
[ 2480.272562] lgs8gxx: AFC = 5649 kHz
[ 2480.273504] lgs8gxx: Reg 0x4B: 0x02
[ 2480.273505] lgs8gxx: lgs8gxx_read_status: fe_status=0x0
[ 2480.473548] dvb_frontend_ioctl (69)
[ 2480.473553] lgs8gxx: lgs8gxx_read_status
[ 2480.475438] lgs8gxx: AFC = 5579 kHz
[ 2480.476379] lgs8gxx: Reg 0x4B: 0x02
[ 2480.476380] lgs8gxx: lgs8gxx_read_status: fe_status=0x0


may be an error in the driver, or an error in the frontend.c. have to
compare both logs from 3.2 and 3.4.
--
http://chanchoiwing.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
