Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4AD9Cks016876
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 09:09:12 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4AD91XF020228
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 09:09:01 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1865873rvb.51
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 06:09:01 -0700 (PDT)
Message-ID: <e686f5060805100609y3e6813b4mcbf5daf21ad03a93@mail.gmail.com>
Date: Sat, 10 May 2008 09:09:00 -0400
From: "Brandon Jenkins" <bcjenkins@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1210384088.3292.109.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e686f5060805091255m70e5d959i1ee3169232aadda2@mail.gmail.com>
	<1210378476.3292.52.camel@palomino.walls.org>
	<e686f5060805091810h5ce89e7dide1c1138d2ad30b7@mail.gmail.com>
	<1210384088.3292.109.camel@palomino.walls.org>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Steven Toth <stoth@hauppauge.com>
Subject: Re: Is anyone else running a CX18 in 64bit OS?
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

On Fri, May 9, 2008 at 9:48 PM, Andy Walls <awalls@radix.net> wrote:
> On Fri, 2008-05-09 at 21:10 -0400, Brandon Jenkins wrote:
>> On Fri, May 9, 2008 at 8:14 PM, Andy Walls <awalls@radix.net> wrote:
>> > On Fri, 2008-05-09 at 15:55 -0400, Brandon Jenkins wrote:
>> >
>> > Brandon,
>> >
>> > Yes I'm running the cx18 driver with an HVR-1600 on a 64 bit OS.
>> >
>> >> I have noticed an appreciable difference in video capture quality.
>> >
>> > The first analog capture after a modprobe of the cx18 is usually
>> > terrible and unwatchable due to apparently lost frames or no initial
>> > audio followed by audio and lost frames.  The work around is to stop the
>> > analog capture and restart.
>> >
>> > Would you characterize the analog capture quality problems as being only
>> > on weak channels or strong channels as well?
>> >
>> >>  The
>> >> timeline for the change is exactly the same time that development
>> >> ceased on the IVTV version of CX18 and moved to V4L.
>> >
>> > I'm not clear on exactly what versions you mean.  Do you have hg
>> > repository names and change ID's?
>> >
>> >
>> >>  I see heavy
>> >> pixelation in analog capture and the dvb tuner module returns far
>> >> fewer channels on a scan than before. I would like to troubleshoot,
>> >> please let me know what is needed.
>> >
>> >
>> > Since you have the two particular source trees at hand, could you do a
>> > recursive diff so we can see the changes?  That hopefully will narrow
>> > the search for potential causes.
>> >
>> > Regards,
>> > Andy
>> >
>> >> I am attaching dmesg/channel.conf/channel scan output for v4l drivers
>> >> comparing the results from a cx18 and a cx23885 card. (hvr-1600 and
>> >> hvr-1800) If I switch back to the older ivtv and mxl500s dvb tuner all
>> >> works fine.
>> >>
>> >> Thanks in advance
>> >>
>> >> Brandon
>> >
>> >
>> >
>> Andy,
>>
>> Thanks for the response.
>>
>> I am running the following command in rc.local to start a capture and
>> then kill it.
>>
>> cat /dev/video3 > /dev/null & sleep 8 && kill $!
>>
>> Is that sufficient for an initial capture?
>
> Without testing it, I'm going to say, I imagine it would be from the
> look of it.
>
>
>> I am recording via svideo from a DirecTV signal. All signal levels are
>> consistent.
>
> OK.  I looked at the cx28885 channels.conf, after I sent the questions,
> and noticed you didn't have terrestrial over the air source.  I saw you
> have the same local channels on QAM that I get over 8-VSB: WETA-HD,
> WUSA-HD, 9-Radar, CW50, etc.
>
>> The driver base which works for me is cx18-8788bde67f6c it is the
>> older cx18-ivtv branch
>
> This is precisely the version (with a small change for auto chroma
> subcarrier locking) that I use when I need to leave my machine with a
> reliable cx18 driver with digital capability for use with MythTV.
> ("General Hospital" *must* be recorded properly daily!)
>
>
>> The version I am having issues with was built from a v4l-dvb pull this morning.
>>
>> I did not mention this in my email but it was in the log files; I am
>> scanning QAM for DVB. With the mxl500x.ko frontend everything works
>> well. With mxl5005s.ko in the new v4l-dvb scanning is broken.
>
> OK.  Steve just introduced that mxl5005s driver from a separate code
> base.  I've copied him on this e-mail to let him know of the problem.
>
> I'll have to do the pull and test scanning my 8VSB stations.
>
> -Andy
>
>> rdiff -r cx18-8788bde67f6c v4l-dvb output attached.
>>
>> Brandon
>
>
Andy,

I can also switch over to my roof antenna and scan. I'll do that
today. Are you doing any analog capture and are you seeing any
pixelation/blocking? I have a 46MB/60sec sample capture that
demonstrates it if interested.

The pixelation/blocking is not present in the older cx18-8788bde67f6c build.

Regards,

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
