Return-path: <mchehab@pedra>
Received: from gateway15.websitewelcome.com ([69.93.179.23]:42480 "HELO
	gateway15.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751708Ab0JVHM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:12:28 -0400
Received: from [74.125.83.46] (port=48680 helo=mail-gw0-f46.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1P9BeO-0001sZ-6F
	for linux-media@vger.kernel.org; Fri, 22 Oct 2010 02:02:52 -0500
Received: by gwj21 with SMTP id 21so798304gwj.19
        for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 00:02:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
Date: Fri, 22 Oct 2010 09:02:51 +0200
Message-ID: <AANLkTinNfh=-VtbDacrK5YvzTHv5k7n-7Br2sod83Gxa@mail.gmail.com>
Subject: Re: Wintv-HVR-1120 woes
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In addition, during analog scan, I get the following errors:

[ 6327.420037] tda18271c2_rf_tracking_filters_correction: [1-0060|M]
error -22 on line 278
[ 6327.468028] tda18271_calc_ir_measure: [1-0060|M] error -34 on line 716
[ 6327.468074] tda18271_calc_bp_filter: [1-0060|M] error -34 on line 648
[ 6327.468117] tda18271_calc_rf_band: [1-0060|M] error -34 on line 682
[ 6327.468159] tda18271_calc_gain_taper: [1-0060|M] error -34 on line 699


On Thu, Oct 21, 2010 at 11:25 PM, Sasha Sirotkin <demiurg@femtolinux.com> wrote:
> I'm having all sorts of troubles with Wintv-HVR-1120 on Ubuntu 10.10
> (kernel 2.6.35-22). Judging from what I've seen on the net, including
> this mailing list, I'm not the only one not being able to use this
> card and no solution seem to exist.
>
> Problems:
> 1. The driver yells various cryptic error messages
> ("tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1,
> i2c_transfer returned: -5", "tda18271_set_analog_params: [1-0060|M]
> error -5 on line 1045", etc)
> 2. DVB-T scan (using w_scan) produces no results
> 3. Analog seems to work, but with very poor quality
>
> Any suggestions would be greatly appreciated.
>
