Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63499 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3EJGQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 02:16:11 -0400
Received: by mail-ob0-f176.google.com with SMTP id wc20so3813372obb.35
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 23:16:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP6c-yw3Ms_N_381N9HpUJLd_6UB7B30k8GSP25+c-h2i3MFiQ@mail.gmail.com>
References: <CAP6c-yw3Ms_N_381N9HpUJLd_6UB7B30k8GSP25+c-h2i3MFiQ@mail.gmail.com>
Date: Fri, 10 May 2013 16:16:11 +1000
Message-ID: <CAP6c-ywedzyPGHS0Ja1vw-GfJQwZ2EM6WQ8SVSbrJitrNXdZwQ@mail.gmail.com>
Subject: Fwd: DVB recording failures in recent Fedora kernel
From: Paul Wilson <mylists@wilsononline.id.au>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Up until recently My recording has been very stable but the last
couple of kernels or updates I'm seeing occasion failures in my
recordings.

Can someone tell if the following errors are driver bugs?

Linux mythbox.salsola 3.8.11-100.fc17.i686 #1 SMP

Here is my dmesg output

248375.223277] tda18271_read_regs: [18-0060|S] ERROR: i2c_transfer returned: -5
[248375.223280] tda18271_ir_cal_init: [18-0060|S] error -5 on line 812
[248375.223282] tda18271_init: [18-0060|S] error -5 on line 836
[248375.223285] tda18271_tune: [18-0060|S] error -5 on line 909
[248375.223287] tda18271_set_params: [18-0060|S] error -5 on line 984
[271757.587443] saa7164_api_i2c_read() error, ret(2) = 0x13
[271757.587450] tda18271_read_regs: [18-0060|S] ERROR: i2c_transfer returned: -5
[271757.587453] tda18271_ir_cal_init: [18-0060|S] error -5 on line 812
[271757.587456] tda18271_init: [18-0060|S] error -5 on line 836
[271757.587458] tda18271_tune: [18-0060|S] error -5 on line 909
[271757.587461] tda18271_set_params: [18-0060|S] error -5 on line 984
[326161.053901] saa7164_api_i2c_read() error, ret(2) = 0x13
[326161.053907] tda18271_read_regs: [18-0060|S] ERROR: i2c_transfer returned: -5
[326161.053910] tda18271_ir_cal_init: [18-0060|S] error -5 on line 812
[326161.053913] tda18271_init: [18-0060|S] error -5 on line 836
[326161.053915] tda18271_tune: [18-0060|S] error -5 on line 909
[326161.053918] tda18271_set_params: [18-0060|S] error -5 on line 984
[359677.846084] saa7164_api_i2c_read() error, ret(2) = 0x13
[359677.846090] tda18271_read_regs: [18-0060|S] ERROR: i2c_transfer returned: -5
[359677.846093] tda18271_ir_cal_init: [18-0060|S] error -5 on line 812
[359677.846096] tda18271_init: [18-0060|S] error -5 on line 836
[359677.846099] tda18271_tune: [18-0060|S] error -5 on line 909

Paul
