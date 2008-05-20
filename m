Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1JyRVS-0006H6-2N
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 15:03:55 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 1B3DE2FA8BF
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 15:03:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 11956130012D
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 15:03:49 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cbRzGHWmzp09 for <linux-dvb@linuxtv.org>;
	Tue, 20 May 2008 15:03:41 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id CEE82130012C
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 15:03:41 +0200 (CEST)
Message-ID: <4832CC2D.50305@anevia.com>
Date: Tue, 20 May 2008 15:03:41 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [HVR 1300] MPEG stream errors
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

Dear all,
I've been experiencing issues regarding the PS output by my HVR 1300. 
Using vlc, after some time (let's say 25 minutes), the decoder starts 
showing artefacts, sound being buggy, and outputs the following messages :

main debug: decoded 106/108 pictures
main warning: output date isn't PTS date, requesting resampling (-40016)
main warning: buffer is 40016 in advance, triggering downsampling
main warning: resampling stopped after 9625000 usec (drift: -463)
main debug: decoded 107/108 pictures
main warning: output date isn't PTS date, requesting resampling (-40334)
mpeg_audio debug: emulated startcode (no startcode on following frame)
main warning: buffer is 111705 in advance, triggering downsampling
main warning: resampling stopped after 16000000 usec (drift: -733)
main warning: vout synchro warning: pts != current_date (-40022)
main warning: backward_pts != dts (120033)
main warning: backward_pts != current_pts (120022)
main warning: vout synchro warning: pts != current_date (-120044)
mpeg_audio debug: emulated startcode (no startcode on following frame)
main warning: buffer is 95100 in advance, triggering downsampling
mpeg_audio debug: emulated startcode (no startcode on following frame)
main warning: audio drift is too big (-191246), clearing out
main warning: timing screwed, stopping resampling
main warning: audio drift is too big (-191080), clearing out
main warning: mixer start isn't output start (-85382)

[...] a.s.o. !!!!

If I stop/start the decoder, it's ok for about the same 25 minutes. But 
if I let it go, artefacts go worse and finally vlc will come to crash.
Of course I don't have this issue with a KNC TV Station DVR (based on a 
saa7134 and saa6752hs), which can run for months.
I'm using a 2.6.22.19 kernel, with a v4l-dvb snapshot from 2007/07, with 
about all significant patches related to cx88* applied to it. It looks 
to me that this is related to the blackbird side of the card.

Anyone experiencing the same issue as me ? Anyone having a clue on 
what's happening ?

Thanks a lot for your time !

-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
