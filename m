Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JZXrW-0005rq-IE
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 21:47:47 +0100
Received: by ug-out-1314.google.com with SMTP id o29so356117ugd.20
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 13:47:43 -0700 (PDT)
Message-ID: <47D8416B.8020804@googlemail.com>
Date: Wed, 12 Mar 2008 20:47:39 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.127.1205345831.830.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.127.1205345831.830.linux-dvb@linuxtv.org>
Subject: [linux-dvb]  Implementing support for multi-channel
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

 > It's (partly) for a research project, so I have to look at all possible
 > solutions, software being one, so dvbstreamer is part of the solution  :-)
 > The others are at driver and hardware level (the hardware supports this).

I can try to explain you what I have understood.
Please anybody correct me where I am wrong.
The following is true in the case of a USB card capable of passing the whole TS to the kernel.

1 tuner => only 1 frequency!

The dvr is useless since it can be opened only once.

You can open the demux as many times as you want.
Each time you set a filter.
Then you can read from them.

You can filter

1) based on a PID
2) just get the whole signal
3) set a section filter

case 1 and 2: you can decide whether to get the TS or PES version of the stream.
I am not too sure about PES. TS is pretty easy to use.

If you want to get a channel (audio + video), then you are in trouble.
I can only filter 1 pid, or the whole TS. So you would need to get the whole signal from each demux 
and filter (audio, video, subtitles...) in your userspace application (which is a big waste!)

I have tried to ask (but did not get any answer) in this list, what people think about multi pid 
filter, so that you can get a full channel in each demux.

Hope it helps.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
