Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:24095 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0DLE6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 00:58:22 -0400
Received: by ey-out-2122.google.com with SMTP id d26so405892eyd.19
        for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 21:58:21 -0700 (PDT)
Date: Mon, 12 Apr 2010 15:00:31 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: saa7134 only one MPEG device
Message-ID: <20100412150031.3ac6b3ca@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

Now saa7134 can support only one MPEG device. It can be MPEG2 encoder or DVB frontend.
struct saa7134_dev->mops.

But our TV card has two different MPEG devices: encoder and DVB frontend.
I make some chandes for support both. But pointer to MPEG ops is only one.
This is dmesh log with my changes.

[   33.587365] befor request_submodules
[   33.587530] saa7133[0]: registered device video0 [v4l2]
[   33.587592] saa7133[0]: registered device vbi0
[   33.587658] saa7133[0]: registered device radio0
[   33.592894] request_mod_async
[   33.592940]   request mod empress
[   33.644596]     saa7134_ts_register start
[   33.644645]       mpeg_ops_attach start
[   33.644730]         saa7133[0]: registered device video1 [mpeg]
[   33.644777]       mpeg_ops_attach OK stop
[   33.644822]     saa7134_ts_register stop
[   33.645894]   dvb = 2
[   33.645940]   request mod dvb
[   33.767654]     call saa7134_ts_register
[   33.767703]       saa7134_ts_register start
[   33.767749]         mpeg_ops_attach start
[   33.767800]         mpeg_ops_attach FAIL stop, mops already exist FAILURE
[   33.767846]       saa7134_ts_register stop

Who can help me for add support multiple MPEG devices for saa7134?

With my best regards, Dmitry.
