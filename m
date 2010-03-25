Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2PFH7wo021216
	for <video4linux-list@redhat.com>; Thu, 25 Mar 2010 11:17:08 -0400
Received: from esc09.hostican.com (esc09.hostican.com [208.79.203.2])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2PFGx3q014847
	for <video4linux-list@redhat.com>; Thu, 25 Mar 2010 11:16:59 -0400
Message-ID: <7ad6557e3fe0cc26a7e5be8c7d5c7da5.squirrel@www.openmeetings.org>
Date: Thu, 25 Mar 2010 11:16:56 -0400
Subject: Re: [ogg-dev] On-the-Fly multiplexing Video
From: "George Chriss" <gchriss@openmeetings.org>
To: "Pandu Rakimanputra" <pandu.rakiman@gmail.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
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

[Re-posting to video4linux-list as the original didn't make it though.]

----- Subject: Re: [ogg-dev] On-the-Fly multiplexing Video
> From:    "ogg.k.ogg.k@googlemail.com" <ogg.k.ogg.k@googlemail.com> Date:
   Tue, March 23, 2010 08:00
> To:      "Pandu Rakimanputra" <pandu.rakiman@gmail.com>
> Cc:      ogg-dev@xiph.org
> --------------------------------------------------------------------------
>
>> It sounds good to me. Could you tell me how to create on-the-fly live
video streaming? What program should i installed?

Slightly off-topic, but there are tie-ins to Ogg here.


There are at least three approaches to Theora-based live streaming:
 -ffmpeg2theora (+Icecast2)
   Works best with DV video, as combining audio with v4l input is not yet
implemented.  This tool is a standard-bearer for Theora encoding.

 -VLC (+Icecast2)
   Documented here:
    http://en.flossmanuals.net/TheoraCookbook/VLCStreaming
   I haven't much experience here -- perhaps others can chime in?

 -Flumotion
   There are two versions: DIY-FLOSS and 'appliance-mode' by Flumotion
Services, SA.  The company develops and thus is tightly integrated with
GStreamer, although the DIY-FLOSS version is hard to setup and not
well-documented.  It is also known to crash on window launch.
'Appliance-mode' works well but is not suitable for casual usage.

Playback in the HTML5 <video> element:
 http://openvideoalliance.org/wiki/index.php?title=Playback

==

My subjective experience with FireWire is that it is unpredictably
unreliable either immediately or over the course of a day -- problems seem
to originate from non-spec-compliant controller chips in cameras and tape
decks.  This is unfortunate given the ubiquity of DV, and a large part of
the reason I prefer composite video.

Composite video is also easier to manage -- documentation started here:
 http://openmeetings.org/wiki/OMwiki:Gear
I haven't found a suitable v4l USB device that grabs video+audio, but I'm
hopeful that this won't be too hard to pin down.


==

Ideally, multiple <video> elements can be shown in-browser, each one
stemming from a separate video source (main cam, 2nd cam, slides).  This
is new territory, I think, especially as it relates to time alignment and
A/V sync.  Alternatively, multiple streams can be provided server-side and
the client can decide which to stream and view (e.g., via a <video>
playlist).

In the interim, I use hardware mixing on a single stream.


Hope this helps,
George

CC: video4linux-list




> ---------------------------- Original Message
---------------------------- Subject: Re: [ogg-dev] On-the-Fly
multiplexing Video
> From:    "ogg.k.ogg.k@googlemail.com" <ogg.k.ogg.k@googlemail.com> Date:
   Tue, March 23, 2010 08:00
> To:      "Pandu Rakimanputra" <pandu.rakiman@gmail.com>
> Cc:      ogg-dev@xiph.org
> --------------------------------------------------------------------------
>
>> It sounds good to me. Could you tell me how to create on-the-fly live
video streaming? What program should i installed?
>
> I suggest you start by downloading, and reading the documentation
(including, but not limited to, the output of any --help option, files
in the doc tree, README files, etc) of the following:
> ffmpeg2theora
> liboggz (including oggz-merge)
> oggfwd
> In case you want to ask where to find them, Google knows.
> In particular, ffmpeg2theora's --help output contains an example of live
streaming
> from a v4l input using other tools and pipes. You should be able to get
it from there using some of the oggz tools, and maybe named pipes.
_______________________________________________
> ogg-dev mailing list
> ogg-dev@xiph.org
> http://lists.xiph.org/mailman/listinfo/ogg-dev
>
>


-- 




-- 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
