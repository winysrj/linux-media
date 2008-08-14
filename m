Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7EIFmVI019784
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:15:48 -0400
Received: from smtp40.hccnet.nl (smtp40.hccnet.nl [62.251.0.29])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m7EIFaRU018803
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:15:37 -0400
Message-ID: <48A4763D.8030509@hccnet.nl>
Date: Thu, 14 Aug 2008 20:15:25 +0200
From: Gert Vervoort <gert.vervoort@hccnet.nl>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
In-Reply-To: <20080814093320.49265ec1@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: MPEG stream work
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dmitri Belimov wrote:
> Hi All
>
>   
Hi Dmitri
> Now I have MPEG stream from the saa6752hs MPEG encoder TV card of Beholder M6.
>
> See test video 
> http://debian.oshec.org/binary/tmp/mpeg01.dat
>
> This is my script for configure TV card and read data
>
> <script start>
>
> echo "Set Frequency..."
> ./v4l2-ctl --set-freq=623.25 -d /dev/video0
> echo "Set INPUT Id"
> ./v4l2-ctl --set-input=0 -d /dev/video0
> echo "Set Norm"
> ./v4l2-ctl -s=secam-d -d /dev/video0
> echo "Set INPUT Id"
> ./v4l2-ctl --set-input=0 -d /dev/video1
> echo "Set Norm"
> ./v4l2-ctl -s=secam-d -d /dev/video1
> echo "Start MPEG"
> echo "Configure MPEG stream"
> echo "Set Bitrate mode"
> ./v4l2-ctl -c video_bitrate_mode=0 -d /dev/video1
> echo "Set audio sampling frequency"
> ./v4l2-ctl -c audio_sampling_frequency=1 -d /dev/video1
> echo "Set audio encoding"
> ./v4l2-ctl -c audio_encoding_layer=1 -d /dev/video1
> echo "Set audio bitrate"
> ./v4l2-ctl -c audio_layer_ii_bitrate=11 -d /dev/video1
> echo "Set video bitrate"
> ./v4l2-ctl -c video_bitrate=7500000 -d /dev/video1
> ./v4l2-ctl -c video_peak_bitrate=9500000 -d /dev/video1
> echo "Set aspect video"
> ./v4l2-ctl -c video_aspect=1 -d /dev/video1
>
> cat /dev/video1 > test
>
> <script stop>
>
> But I have a trouble. I can't set correct Freq for TV tuner. I send command to tuner
> but data from tuner to MPEG encoder is wrong. The encoder send to host stream with "snow window".
> Anybody can help me??
>
>   
When video on the input of the SAA6752 is not valid video (eg a tuner 
which is not properly tuned), then usually it will not work properly (at 
least it will not contain compressed video in the output stream). 
However the "snow window" you see seems to be correct video in eyes of 
the SAA6752 (contains correct syncs), see it has encoded it. The TS 
stream is valid, I can play it back (with xine and ffplay) and see the 
"snow window". The encoder seem to have done a proper job.

Do you also see this "snow window" on the video device of the SAA7143 
(eg xawtv -c /dev/video0)?
That should show the same video signal (but scaled), as is send to the 
SAA6752.
The tuner (CVBS) signal is send to the SAA7134, which will do the analog 
video decoding / analog to digital conversion, the resulting 656 digital 
video signal goes both to the scaler/DMA (visible on /dev/video0) and in 
parallel it also goes to the ITU656 output to which to SAA6752 is connected.

If your TV-card has a CVBS input, you could try what happens if you 
connect an other video source (eg DVD, VCR).

  Gert





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
