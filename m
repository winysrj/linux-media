Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:9906 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZGWJky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 05:40:54 -0400
Received: by ey-out-2122.google.com with SMTP id 9so255379eyd.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 02:40:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 11:40:54 +0200
Message-ID: <d9def9db0907230240w6d3a41fcv2fcef6cbb6e2cb8c@mail.gmail.com>
Subject: em28xx driver crashes device
From: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

[24004.018614] EEPROM ID= 0x9567eb1a, hash = 0x1067368a
[24004.018618] Vendor/Product ID= eb1a:2861
[24004.018622] AC97 audio (5 sample rates)
[24004.018626] 500mA max power
[24004.018629] Table at 0x04, strings=0x206a, 0x0000, 0x0000
[24004.049201]  failed!
[24004.049210] em28xx #0: reading from i2c device failed (error=-71)
[24004.049444]  failed!
[24004.049451] em28xx #0: reading from i2c device failed (error=-71)
[24004.049655]  failed!
[24004.049659] em28xx #0: reading from i2c device failed (error=-71)
[24004.049891]  failed!
[24004.049895] em28xx #0: reading from i2c device failed (error=-71)
[24004.050141]  failed!
[24004.050145] em28xx #0: reading from i2c device failed (error=-71)
[24004.050393]  failed!
[24004.050396] em28xx #0: reading from i2c device failed (error=-71)
[24004.050641]  failed!
[24004.050644] em28xx #0: reading from i2c device failed (error=-71)
[24004.050890]  failed!
[24004.050894] em28xx #0: reading from i2c device failed (error=-71)
[24004.051141]  failed!
[24004.051145] em28xx #0: reading from i2c device failed (error=-71)
[24004.051392]  failed!
[24004.051395] em28xx #0: reading from i2c device failed (error=-71)
[24004.051641]  failed!
[24004.051645] em28xx #0: reading from i2c device failed (error=-71)
[24004.051892]  failed!
[24004.051895] em28xx #0: reading from i2c device failed (error=-71)
[24004.052140]  failed!
[24004.052143] em28xx #0: reading from i2c device failed (error=-71)
[24004.052393]  failed!
[24004.052396] em28xx #0: reading from i2c device failed (error=-71)
[24004.052642]  failed!
[24004.052645] em28xx #0: reading from i2c device failed (error=-71)
[24004.052892]  failed!
[24004.052895] em28xx #0: reading from i2c device failed (error=-71)
[24004.057741]  failed!
[24004.057746] em28xx #0: reading from i2c device failed (error=-71)
[24004.057880]  failed!
[24004.057884] em28xx #0: reading from i2c device failed (error=-71)
[24004.058125]  failed!
[24004.058129] em28xx #0: reading from i2c device failed (error=-71)
[24004.058379]  failed!
[24004.058383] em28xx #0: reading from i2c device failed (error=-71)
[24004.058628]  failed!
[24004.058633] em28xx #0: reading from i2c device failed (error=-71)
[24004.058880]  failed!
[24004.058883] em28xx #0: reading from i2c device failed (error=-71)
[24004.059128]  failed!
[24004.059131] em28xx #0: reading from i2c device failed (error=-71)
[24004.059380]  failed!
[24004.059383] em28xx #0: reading from i2c device failed (error=-71)
[24004.059636]  failed!
[24004.059640] em28xx #0: reading from i2c device failed (error=-71)
[24004.059914]  failed!
[24004.059917] em28xx #0: reading from i2c device failed (error=-71)
[24004.060140]  failed!
[24004.060145] em28xx #0: reading from i2c device failed (error=-71)
[24004.060388]  failed!
[24004.060392] em28xx #0: reading from i2c device failed (error=-71)
[24004.060636]  failed!
[24004.060640] em28xx #0: reading from i2c device failed (error=-71)
[24004.060884]  failed!
[24004.060887] em28xx #0: reading from i2c device failed (error=-71)
[24004.061126]  failed!
[24004.061132] em28xx #0: reading from i2c device failed (error=-71)
[24004.062214]  failed!
[24004.062219] em28xx #0: reading from i2c device failed (error=-71)
[24004.062378]  failed!
[24004.062383] em28xx #0: reading from i2c device failed (error=-71)
[24004.062632]  failed!
[24004.062636] em28xx #0: reading from i2c device failed (error=-71)
[24004.062884]  failed!
[24004.062889] em28xx #0: reading from i2c device failed (error=-71)
[24004.063126]  failed!
[24004.063131] em28xx #0: reading from i2c device failed (error=-71)
[24004.063375]  failed!
[24004.063380] em28xx #0: reading from i2c device failed (error=-71)
[24004.063626]  failed!
[24004.063631] em28xx #0: reading from i2c device failed (error=-71)
[24004.063875]  failed!
[24004.063880] em28xx #0: reading from i2c device failed (error=-71)
[24004.064127]  failed!
[24004.064132] em28xx #0: reading from i2c device failed (error=-71)
[24004.064376]  failed!
[24004.064380] em28xx #0: reading from i2c device failed (error=-71)
[24004.064625]  failed!
[24004.064630] em28xx #0: reading from i2c device failed (error=-71)
[24004.064876]  failed!
[24004.064881] em28xx #0: reading from i2c device failed (error=-71)
[24004.065126]  failed!
[24004.065130] em28xx #0: reading from i2c device failed (error=-71)
[24004.065376]  failed!
[24004.065381] em28xx #0: reading from i2c device failed (error=-71)
[24004.065626]  failed!
[24004.065632] em28xx #0: reading from i2c device failed (error=-71)
[24004.065875]  failed!
[24004.065880] em28xx #0: reading from i2c device failed (error=-71)
[24004.066126]  failed!
[24004.066131] em28xx #0: reading from i2c device failed (error=-71)
[24004.066376]  failed!
[24004.066381] em28xx #0: reading from i2c device failed (error=-71)
[24004.066625]  failed!
[24004.066629] em28xx #0: reading from i2c device failed (error=-71)
[24004.066875]  failed!
[24004.066880] em28xx #0: reading from i2c device failed (error=-71)
[24004.066890] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[24004.066900] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[24004.066908] em28xx #0: Please send an email with this log to:
[24004.066916] em28xx #0: 	V4L Mailing List <video4linux-list@redhat.com>
[24004.066924] em28xx #0: Board eeprom hash is 0x1067368a


can someone just check for errors if one error occures stop it?
We're facing that this driver crashes entire devices.

regards,
Markus
