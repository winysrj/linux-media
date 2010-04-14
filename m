Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <d.belimov@gmail.com>) id 1O1qes-0001HD-4m
	for linux-dvb@linuxtv.org; Wed, 14 Apr 2010 02:40:46 +0200
Received: from mail-ew0-f221.google.com ([209.85.219.221])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1O1qer-0005Fu-BK; Wed, 14 Apr 2010 02:40:45 +0200
Received: by ewy21 with SMTP id 21so2735656ewy.5
	for <linux-dvb@linuxtv.org>; Tue, 13 Apr 2010 17:40:43 -0700 (PDT)
Date: Wed, 14 Apr 2010 10:42:56 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20100414104256.19cfdcc6@glory.loctelecom.ru>
Mime-Version: 1.0
Subject: [linux-dvb] saa7134 only one MPEG device
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
