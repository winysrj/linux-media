Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2PH5N93018038
	for <video4linux-list@redhat.com>; Thu, 25 Mar 2010 13:05:23 -0400
Received: from mail.hidayahonline.org (hidayahonline.org [67.19.146.138])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2PH5DLJ008359
	for <video4linux-list@redhat.com>; Thu, 25 Mar 2010 13:05:14 -0400
Message-ID: <4BAB97C8.4000506@hidayahonline.org>
Date: Thu, 25 Mar 2010 13:05:12 -0400
From: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Re: [ogg-dev] On-the-Fly multiplexing Video
References: <7ad6557e3fe0cc26a7e5be8c7d5c7da5.squirrel@www.openmeetings.org>
In-Reply-To: <7ad6557e3fe0cc26a7e5be8c7d5c7da5.squirrel@www.openmeetings.org>
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

On 03/25/2010 11:16 AM, George Chriss wrote:
>
>>
>>> It sounds good to me. Could you tell me how to create on-the-fly live
> video streaming? What program should i installed?
>
> Slightly off-topic, but there are tie-ins to Ogg here.
>
>
> There are at least three approaches to Theora-based live streaming:
>  -ffmpeg2theora (+Icecast2)
>    Works best with DV video, as combining audio with v4l input is not yet
> implemented.  This tool is a standard-bearer for Theora encoding.
>
>  -VLC (+Icecast2)
>    Documented here:
>     http://en.flossmanuals.net/TheoraCookbook/VLCStreaming
>    I haven't much experience here -- perhaps others can chime in?
>
>  -Flumotion
>    There are two versions: DIY-FLOSS and 'appliance-mode' by Flumotion
> Services, SA.  The company develops and thus is tightly integrated with
> GStreamer, although the DIY-FLOSS version is hard to setup and not
> well-documented.  It is also known to crash on window launch.
> 'Appliance-mode' works well but is not suitable for casual usage.
>   
Gstreamer is another great & viable option for Ogg streaming.  The
shout2send element can be used to send an ogg stream to an Icecast
server.  It's not very well documented though, unfortunately, but works
great in my experience.  It'll handle everything from capturing v4l2
through to streaming, including multiplexing in audio.  Works great with
DV as well.

-- 
      Basil Mohamed Gohar
abu_hurayrah@hidayahonline.org
http://www.basilgohar.com/blog
basilgohar on irc.freenode.net
GPG Key Fingerprint:  5AF4B362

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
