Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gn.apc.org ([217.72.179.5]:54538 "EHLO mail.gn.apc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0G1Sw1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:52:27 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.gn.apc.org (Postfix) with ESMTP id 53A197F21E6
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 19:45:54 +0100 (BST)
Received: from mail.gn.apc.org ([127.0.0.1])
	by localhost (mail.gn.apc.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qmibmNt3bGEJ for <linux-media@vger.kernel.org>;
	Wed, 28 Jul 2010 19:45:52 +0100 (BST)
Received: from anonymous ([10.254.254.3])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: mimo-mail)
	by mail.gn.apc.org (Postfix) with ESMTPSA id 8FF307F21F9
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 19:45:51 +0100 (BST)
From: mimo <mimo@restoel.net>
To: linux-media@vger.kernel.org
Subject: Re: AverMedia Volar Black HD (A850) - crashes in mythtv, does not find HD
Date: Wed, 28 Jul 2010 19:45:46 +0100
References: <201007281357.40321.mimo@gn.apc.org>
In-Reply-To: <201007281357.40321.mimo@gn.apc.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281945.47229.mimo@restoel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just as a follow up when I run with debug=1 then I get this when the soup hits the fan:

[20057.560929] af9013_init
[20057.560942] af9013_reset
[20057.564856] af9013_power_ctrl: onoff:1
[20057.568983] af9013_set_adc_ctrl: adc_clock:28000
[20057.568993] af913_div: a:28000000 b:1000000 x:19
[20057.569002] af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
[20057.569008] af9013_set_adc_ctrl: adc_cw:00 00 e0 
[20057.573979] af9013_init: load ofsm settings
[20057.630229] af9013_init: load tuner specific settings
[20057.684977] af9013_init: setting ts mode
[20057.686473] af9013_lock_led: onoff:1
[20057.687480] af9013_i2c_gate_ctrl: enable:1
[20057.688225] af9013_i2c_gate_ctrl: enable:1
[20057.689599] af9013_i2c_gate_ctrl: enable:0
[20057.690349] af9013_i2c_gate_ctrl: enable:1
[20057.692102] af9013_i2c_gate_ctrl: enable:0
[20057.692978] af9013_i2c_gate_ctrl: enable:1
[20057.708103] af9013_i2c_gate_ctrl: enable:0
[20057.708599] af9013_i2c_gate_ctrl: enable:0
[20057.789900] af9013_set_frontend: freq:482000000 bw:0
[20057.789914] af9013_i2c_gate_ctrl: enable:1
[20057.791984] af9013_i2c_gate_ctrl: enable:0
[20057.792724] af9013_i2c_gate_ctrl: enable:1
[20057.794098] af9013_i2c_gate_ctrl: enable:0
[20057.794984] af9013_i2c_gate_ctrl: enable:1
[20057.810104] af9013_i2c_gate_ctrl: enable:0
[20057.810598] af9013_i2c_gate_ctrl: enable:1
[20057.811977] af9013_i2c_gate_ctrl: enable:0
[20057.812805] af9013_i2c_gate_ctrl: enable:1
[20057.830352] af9013_i2c_gate_ctrl: enable:0
[20057.986992] af9013_i2c_gate_ctrl: enable:1
[20057.990222] af9013_i2c_gate_ctrl: enable:0
[20058.090765] af9013_set_coeff: adc_clock:28000 bw:0
[20058.090775] af9013_set_coeff: coeff:02 9c bc 15 05 39 78 0a 00 a7 34 3f 00 a7 2f 05 00 a7 29 cc 01 4e 5e 03 
[20058.101485] af913_div: a:4570000 b:28000000 x:23
[20058.101498] af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
[20058.101506] af9013_set_freq_ctrl: freq_cw:cc 1b 6b 
[20058.102597] af913_div: a:4570000 b:28000000 x:23
[20058.102606] af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
[20058.102613] af9013_set_freq_ctrl: freq_cw:cc 1b 6b 
[20058.103732] af913_div: a:4570000 b:28000000 x:23
[20058.103741] af913_div: a:18560000 b:28000000 x:23 r:1369140 r:14e434
[20058.103748] af9013_set_freq_ctrl: freq_cw:34 e4 14 
[20058.109474] af9013_set_frontend: auto TPS
[20058.111108] af9013_update_signal_strength
[20058.907974] af9013_get_frontend
[20060.223964] af9013_update_signal_strength
[20060.246843] af9013_update_ber_unc: err bits:99 total bits:16320000 abort count:0
[20062.155949] af9013_update_signal_strength
[20062.178571] af9013_update_ber_unc: err bits:107 total bits:16320000 abort count:0
[20063.786934] af9013_update_signal_strength
[20063.810685] af9013_update_ber_unc: err bits:159 total bits:16320000 abort count:0
[20065.522920] af9013_update_signal_strength
[20065.546670] af9013_update_ber_unc: err bits:170 total bits:16320000 abort count:0
[20067.506902] af9013_update_signal_strength
[20067.530529] af9013_update_ber_unc: err bits:73 total bits:16320000 abort count:0
[20069.778884] af9013_update_signal_strength

(loads of these)

mimo
