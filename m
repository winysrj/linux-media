Return-path: <linux-media-owner@vger.kernel.org>
Received: from 213-133-109-209.clients.your-server.de ([213.133.109.209]:41832
	"EHLO smtp.hora-obscura.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab0FNMO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 08:14:29 -0400
Message-ID: <4C161B62.9020601@hora-obscura.de>
Date: Mon, 14 Jun 2010 15:06:58 +0300
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org
Subject: Re: [OT] preferred video apps?
References: <20100430095721.b1da05af.rdunlap@xenotime.net> <4BDB7A5B.7070204@redhat.com>
In-Reply-To: <4BDB7A5B.7070204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.05.2010 03:48, Mauro Carvalho Chehab wrote:
> Randy Dunlap wrote:
>   
>> Hi,
>>
>> Sorry for a non-kernel question, but I'd like to get some suggestions
>> on video recording and editing software, please.
>>
>> If it matters, this is mostly for recording & editing sports events (matches).
>>
>> Reply privately if you prefer ...
>>     
> Please, _do_not_ reply privately ;) 
>
> We should build a relation of the userspace applications we need to care when 
> testing for regressions, so, this is not OT. It would be nice to hear what are
> the preferred open source applications.
>
> From my side, those are the applications I use:
> 	analog: xawtv 3, xawtv 4, tvtime, mencoder, ffmpeg
>
> Only mencoder and ffmpeg can record - but xawtv (and xdtv) call them.
>   
gstreamer can record too :) A few examples:

stream to screen:
gst-launch v4l2src ! xvimagesink

capture 1 image
gst-launch v4l2src num-buffers=1 ! jpegenc ! filesink location="test.jpeg"

stream to screen and capture video (-e is needed to terminate video on
ctrl-c)
gst-launch -e v4l2src ! tee name=t ! queue ! xvimagesink t. !
ffenc_mpeg4 ! avimux ! filesink location="video.avi"

same as before, but select resolution and framerate
gst-launch -e v4l2src !
"video/x-raw-yuv,width=320,height=240,framerate=(fraction)15/1" ! tee
name=t ! queue ! xvimagesink t. ! ffenc_mpeg4 ! avimux ! filesink
location="video.avi"

(see man gst-launch-0.10 for more examples)

Stefan
> On digital side, I use kaffeine, gnutv and vlc. Kaffeine and gnutv can record. 
> Not sure about vlc.
>
> mplayer is capable of working with both analog and digital (and, by consequence,
> mencoder).
>
> Although I don't use, mythtv and vdr are also very popular applications. AFAIK,
> both have record support.
>
>   

