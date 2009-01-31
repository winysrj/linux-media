Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0VB74iq018113
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 06:07:04 -0500
Received: from smtp-out5.blueyonder.co.uk (smtp-out5.blueyonder.co.uk
	[195.188.213.8])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0VB6oKO020470
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 06:06:50 -0500
Message-ID: <498430DF.7080507@blueyonder.co.uk>
Date: Sat, 31 Jan 2009 11:07:11 +0000
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Jackson Yee <jackson@gotpossum.com>,
	Video 4 Linux <video4linux-list@redhat.com>
References: <497CD894.7070101@blueyonder.co.uk>
	<26aa882f0901251857k1f4eea3cs83360b15dfdc8f5a@mail.gmail.com>
In-Reply-To: <26aa882f0901251857k1f4eea3cs83360b15dfdc8f5a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Capturing to AVI using streamer
Reply-To: ian.davidson@bigfoot.com
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



Jackson Yee wrote:
> Ian,
>
> I'm not familiar with streamer, but your problem could be either
> hardware or software. Please install mplayer on your Fedora system,
> run the command 'midentify' on your AVI file, and post the results for
> us. You may also want to use other software such as XawTV or TVTime on
> your Fedora system to test the capture hardware as well.
>
> Regards,
> Jackson Yee
> The Possum Company
> 540-818-4079
> me@gotpossum.com
>
> On Sun, Jan 25, 2009 at 4:24 PM, Ian Davidson
> <id012c3076@blueyonder.co.uk> wrote:
>   
>> I used to capture video to AVI format using streamer on a single processor
>> system running Fedora Core 4.  I would set up streamer to run for 40 minutes
>> - but at a convenient time stop streamer using Ctrl-C (according to the
>> documentation) and the AVI file would be 'wrapped up' nicely.  I could take
>> the AVI file to a Windows machine and edit the captured video.
>>
>> I am now using streamer as before but on a dual processor system running
>> Fedora 9.  I get an AVI file but some editing software is unable to find the
>> video stream.
>>
>> Is this a problem caused by a) the change of hardware or b) the change of
>> software?
>>
>> Ian
>>
>> --
>> Ian Davidson
>> 239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
>> --
>> Facts used in this message may or may not reflect an underlying objective
>> reality. Facts are supplied for personal use only. Recipients quoting
>> supplied information do so at their own risk. Facts supplied may vary in
>> whole or part from widely accepted standards. While painstakingly
>> researched, facts may or may not be indicative of actually occurring events
>> or natural phenomena. The author accepts no responsibility for personal loss
>> or injury resulting from memorisation and subsequent use.
>>
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>>     

streamer is part of the same bundle as xawtv.

Here is the output from midentify


ID_VIDEO_ID=0
ID_AUDIO_ID=1
ID_FILENAME=Sun23-1841.avi
ID_DEMUXER=avi
ID_VIDEO_FORMAT=MJPG
ID_VIDEO_BITRATE=4161976
ID_VIDEO_WIDTH=352
ID_VIDEO_HEIGHT=288
ID_VIDEO_FPS=25.000
ID_VIDEO_ASPECT=0.0000
ID_AUDIO_FORMAT=1
ID_AUDIO_BITRATE=705600
ID_AUDIO_RATE=0
ID_AUDIO_NCH=0
ID_LENGTH=2041.68
ID_SEEKABLE=1
ID_VIDEO_CODEC=ffmjpeg
ID_AUDIO_BITRATE=705600
ID_AUDIO_RATE=44100
ID_AUDIO_NCH=1
ID_AUDIO_CODEC=pcm


-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
