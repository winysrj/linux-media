Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6DFXU7d003623
	for <video4linux-list@redhat.com>; Tue, 13 Jul 2010 11:33:30 -0400
Received: from web58203.mail.re3.yahoo.com (web58203.mail.re3.yahoo.com
	[68.142.236.141])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o6DFXIsg014948
	for <video4linux-list@redhat.com>; Tue, 13 Jul 2010 11:33:18 -0400
Message-ID: <76976.57753.qm@web58203.mail.re3.yahoo.com>
Date: Tue, 13 Jul 2010 08:06:35 -0700 (PDT)
From: "C L." <rosc2112@yahoo.com>
Subject: pchdtv & transcode capture?
To: video4linux-list@redhat.com
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

First, let me know if there is a way to search the list archives, my searches through google haven't been very helpful. 2nd, I've looked over the v4l wiki extensively, and have this as a test script:

transcode:

transcode -x v4l2,v4l2 -M 2 -i /dev/video0 -p /dev/dsp1 -y ffmpeg -F mpeg4 -f 0,4 -I 1 -g 720x480 -u 100 -E 48000,16,2 --lame_preset medium -o $1.avi

or in mplayer:

mencoder -tv driver=v4l2:width=720:height=480:norm=ntsc:alsa=1:adevice=hw.1:amode=1 -ffourcc XVID -fps 30000/1001 -ovc lavc -lavcopts vcodec=mpeg4:mbd=2 -oac mp3lame -lameopts cbr:br=128 -o outfile.avi tv://

I'm having problems with a pchdtv 5500 card, not the least of which is lack of documentation and support by the manufacturer. I'm thinking of just ditching this card since it doesn't seem to work very well as a plain capture card. I have to run the 'tvtime' program just to get the card initialized and tuned into the main channel (channel 3, where I have my Dish tv splitter plugged into the tuner's rca plug.)

I've had no luck whatsoever getting this card to work in dvb mode, using the tools provided by pchdtv or elsewhere that I've found. I assume that's because I am using the ntsc output from my dish tv receiver which isn't exactly an "approved" purpose for this card.

Anyway, when I try to capture video with either transcode or mencoder, I'm running into 2 big problems: 1, the audio is horribly out of sync, and 2, the gamma & color is horrendous. I have an AMD X4 940 cpu, so it should be plenty fast to cap sound in sync, presumably.

If anyone has any experience with this card and could point me to some useful tips on how to improve the captures, I'd be much obliged.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
