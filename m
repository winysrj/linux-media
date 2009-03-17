Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:39889 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762843AbZCQAcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 20:32:25 -0400
Received: by ewy25 with SMTP id 25so3688058ewy.37
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 17:32:22 -0700 (PDT)
Subject: Re: [linux-dvb] EC168 and MT2060
From: "t.Hgch" <pureherz@gmail.com>
Reply-To: pureherz@gmail.com
To: linux-media@vger.kernel.org
Cc: Tanguy PRUVOT <tanguy.pruvot@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <49BE7031.50005@iki.fi>
References: <1237129041.7993.38.camel@0ri0n> <49BD3B31.8030308@iki.fi>
	 <1237146464.7993.94.camel@0ri0n> <49BD5D0E.3090304@iki.fi>
	 <1237208613.8685.13.camel@0ri0n>
	 <fe7b409d0903160826m23961c90i147661d0fa083c8e@mail.gmail.com>
	 <49BE7031.50005@iki.fi>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:32:17 +0100
Message-Id: <1237249937.19477.8.camel@0ri0n>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I found that my card isn't locking on certain frequencies,Could it be a
problem of signal strength? In widows it gets all channels though.
Here is the log:

[41630.298168] ec100_init
[41630.299611] 40 21 ff 00 c6 01 01 00 >>> 00 
[41630.301225] 40 21 09 00 c6 01 02 00 >>> b1 fe 
[41630.302605] 40 21 0b 00 c6 01 01 00 >>> 16 
[41630.304375] 40 21 0c 00 c6 01 01 00 >>> d9 
[41630.305727] 40 21 0d 00 c6 01 01 00 >>> 99 
[41630.307099] 40 21 16 00 c6 01 01 00 >>> 2f 
[41630.308103] 40 21 20 00 c6 01 01 00 >>> 40 
[41630.309099] 40 21 2b 00 c6 01 01 00 >>> 33 
[41630.310102] 40 21 2c 00 c6 01 01 00 >>> 20 
[41630.311099] 40 21 35 00 c6 01 01 00 >>> 9b 
[41630.311975] 40 21 38 00 c6 01 01 00 >>> 88 
[41630.312849] 40 21 3b 00 c6 01 01 00 >>> 00 
[41630.313721] 40 21 49 00 c6 01 01 00 >>> a0 
[41630.314597] 40 21 4c 00 c6 01 01 00 >>> fb 
[41630.315600] 40 21 4d 00 c6 01 01 00 >>> 13 
[41630.316599] 40 21 5b 00 c6 01 01 00 >>> 70 
[41630.317602] 40 21 86 00 c6 01 01 00 >>> 04 
[41630.318598] 40 21 87 00 c6 01 01 00 >>> 01 
[41630.319474] 40 21 89 00 c6 01 01 00 >>> c8 
[41630.320474] 40 21 93 00 c6 01 01 00 >>> da 
[41630.321348] 40 21 9c 00 c6 01 01 00 >>> 57 
[41630.322224] 40 21 a6 00 c6 01 01 00 >>> 9d 
[41630.323098] 40 21 a7 00 c6 01 01 00 >>> 1a 
[41630.324096] 40 21 a8 00 c6 01 01 00 >>> c0 
[41630.325227] 40 21 19 00 c6 01 02 00 >>> 36 fe 

->Basically repeats this sequence until timeout

[41630.425407] ec100_set_frontend: freq:842000000 bw:0
[41630.426115] 40 21 00 00 c6 00 01 00 >>> ff 
[41630.427106] 40 21 ff 00 c6 01 01 00 >>> 00 
[41630.428352] 40 21 09 00 c6 01 02 00 >>> b1 fe 
[41630.429351] 40 21 0b 00 c6 01 01 00 >>> 16 
[41630.430236] 40 21 0c 00 c6 01 01 00 >>> d9 
[41630.431223] 40 21 0d 00 c6 01 01 00 >>> 99 
[41630.432416] 40 21 16 00 c6 01 01 00 >>> 5f 
[41630.433350] 40 21 20 00 c6 01 01 00 >>> 40 
[41630.434232] 40 21 2b 00 c6 01 01 00 >>> 33 
[41630.435097] 40 21 2c 00 c6 01 01 00 >>> 20 
[41630.435981] 40 21 35 00 c6 01 01 00 >>> 83 
[41630.436974] 40 21 38 00 c6 01 01 00 >>> 88 
[41630.437851] 40 21 3b 00 c6 01 01 00 >>> 00 
[41630.438856] 40 21 49 00 c6 01 01 00 >>> a0 
[41630.439852] 40 21 4c 00 c6 01 01 00 >>> fb 
[41630.440723] 40 21 4d 00 c6 01 01 00 >>> 93 
[41630.441600] 40 21 5b 00 c6 01 01 00 >>> 70 
[41630.442601] 40 21 86 00 c6 01 01 00 >>> 04 
[41630.443601] 40 21 87 00 c6 01 01 00 >>> 01 
[41630.444482] 40 21 89 00 c6 01 01 00 >>> c8 
[41630.445475] 40 21 93 00 c6 01 01 00 >>> da 
[41630.446354] 40 21 9c 00 c6 01 01 00 >>> 57 
[41630.447351] 40 21 a6 00 c6 01 01 00 >>> 9d 
[41630.448354] 40 21 a7 00 c6 01 01 00 >>> 19 
[41630.449225] 40 21 a8 00 c6 01 01 00 >>> d2 
[41630.450360] 40 21 19 00 c6 01 02 00 >>> 36 fe 
[41630.451472] 40 21 09 00 c6 01 02 00 >>> b1 fe 
[41630.452480] 40 21 0e 00 c6 01 01 00 >>> 34 
[41630.453351] 40 21 0f 00 c6 01 01 00 >>> a0 
[41630.454234] 40 21 10 00 c6 01 01 00 >>> 00 
[41630.455102] 40 21 11 00 c6 01 01 00 >>> 20 
[41630.456103] 40 21 16 00 c6 01 01 00 >>> 5f 
[41630.457100] 40 21 2b 00 c6 01 01 00 >>> 43 
[41630.458112] 40 21 44 00 c6 01 01 00 >>> c0 
[41630.459097] 40 21 45 00 c6 01 01 00 >>> 01 
[41630.460109] 40 21 46 00 c6 01 01 00 >>> 9a 
[41630.461100] 40 21 49 00 c6 01 01 00 >>> b0 
[41630.461978] 40 21 5c 00 c6 01 01 00 >>> 00 
[41630.462979] 40 21 5d 00 c6 01 01 00 >>> 00 
[41630.463981] 40 21 6a 00 c6 01 01 00 >>> 3b 
[41630.464976] 40 21 6b 00 c6 01 01 00 >>> 84 
[41630.465859] 40 21 6c 00 c6 01 01 00 >>> 9a 
[41630.466854] 40 21 6d 00 c6 01 01 00 >>> 4e 
[41630.467848] 40 21 6e 00 c6 01 01 00 >>> 41 
[41630.468725] 40 21 6f 00 c6 01 01 00 >>> e8 
[41630.469604] 40 21 70 00 c6 01 01 00 >>> 82 
[41630.470602] 40 21 88 00 c6 01 01 00 >>> 7e 
[41630.471601] 40 21 8a 00 c6 01 01 00 >>> 38 
[41630.472604] 40 21 95 00 c6 01 01 00 >>> 03 
[41630.473601] 40 21 4d 00 c6 01 01 00 >>> 93 
[41630.474601] 40 21 a6 00 c6 01 01 00 >>> 9d 
[41630.475601] 40 21 a7 00 c6 01 01 00 >>> 19 
[41630.476476] 40 21 a8 00 c6 01 01 00 >>> d2 
[41630.477603] 40 21 09 00 c6 01 02 00 >>> f3 fe 
[41630.633503] 40 21 2b 00 c6 01 01 00 >>> 33 
[41630.634499] 40 21 88 00 c6 01 01 00 >>> fe 
[41630.635727] 40 21 09 00 c6 01 02 00 >>> f3 fe 
[41630.736238] 40 04 01 00 0b 00 00 00 >>> 
[41630.736357] 40 04 00 00 0a 00 00 00 >>> 
[41630.736483] 40 03 06 00 04 ff 00 00 >>> 
[41630.736615] 40 03 58 00 67 ff 00 00 >>> 
[41630.736730] 40 03 18 00 05 ff 00 00 >>> 
[41630.736854] 40 04 01 00 08 00 00 00 >>> 
[41630.736981] 40 03 49 00 1b ff 00 00 >>> 
[41630.737103] 40 03 72 00 1c ff 00 00 >>> 
[41630.737232] 40 03 bb 00 0c ff 00 00 >>> 
[41630.737354] 40 03 31 00 0d ff 00 00 >>> 
[41630.737486] 40 03 24 00 08 ff 00 00 >>> 
[41630.737602] 40 03 00 00 00 ff 00 00 >>> 
[41630.737736] 40 03 20 00 00 ff 00 00 >>> 
[41630.737986] c0 03 00 00 01 ff 01 00 <<< 02 
[41630.738105] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.738231] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.750251] c0 03 00 00 01 ff 01 00 <<< 13 
[41630.750359] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.750481] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.760612] c0 03 00 00 01 ff 01 00 <<< 13 
[41630.760767] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.760855] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.770991] c0 03 00 00 01 ff 01 00 <<< 13 
[41630.771105] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.771237] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.781356] c0 03 00 00 01 ff 01 00 <<< 13 
[41630.781485] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.781606] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.791739] c0 03 00 00 01 ff 01 00 <<< 13 
[41630.791853] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.791984] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.802108] c0 03 00 00 01 ff 01 00 <<< 34 
[41630.802236] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.802354] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.812483] c0 03 00 00 01 ff 01 00 <<< 35 
[41630.812614] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.812731] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.822860] c0 03 00 00 01 ff 01 00 <<< 35 
[41630.822986] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.823104] c0 03 00 00 24 ff 01 00 <<< 00 
[41630.833250] c0 03 00 00 01 ff 01 00 <<< 35
-<Cut>-
[41631.525990] c0 03 00 00 24 ff 01 00 <<< 00 
[41631.526117] c0 03 00 00 24 ff 01 00 <<< 00 
[41631.536123] c0 03 00 00 01 ff 01 00 <<< 35 
[41631.536238] c0 03 00 00 24 ff 01 00 <<< 00 
[41631.536368] c0 03 00 00 24 ff 01 00 <<< 00 
[41631.536372] ec100_set_frontend: freq:842000000 bw:0
[41631.537502] 40 21 09 00 c6 01 02 00 >>> b1 fe 
[41631.538502] 40 21 0e 00 c6 01 01 00 >>> 34 
[41631.539487] 40 21 0f 00 c6 01 01 00 >>> a0 
[41631.540372] 40 21 10 00 c6 01 01 00 >>> 00 
[41631.541369] 40 21 11 00 c6 01 01 00 >>> 20 
...

I also get this from time to time but don't how to reproduce exactly:

[33044.376068] ec168_rw_udev: usb_control_msg failed :-110

Regards,

Tony

