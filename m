Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59985 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3L0Fhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Dec 2013 00:37:34 -0500
Received: by mail-qc0-f170.google.com with SMTP id x13so8499151qcv.1
        for <linux-media@vger.kernel.org>; Thu, 26 Dec 2013 21:37:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	<CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
Date: Fri, 27 Dec 2013 00:37:33 -0500
Message-ID: <CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
Subject: Fwd: v4l2: The device does not support the streaming I/O method.
From: Andy <dssnosher@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to capture input from /dev/video0 which is Hauppauge Win
150 MCE PCI card but I get the following error which has no record on
google

[video4linux2,v4l2 @ 0xb080d60] The device does not support the
streaming I/O method.
/dev/video0: Function not implemented

Here is the ffmpeg command
ffmpeg -y -f:v video4linux2 -i /dev/video0 -f:a alsa -ac 1 -i hw:1,0
-threads 2 -override_ffserver -flags +global_header -vcodec libx264 -s
320x240 -preset superfast -r 7.5 -acodec aac -ar 44100
ipgoeshere:port/dvbstest.ffm

Disregard the DVB syntax, not relevant

Any idea what is causing the error?
