Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53J1SXN021155
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 15:01:28 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53J0SXW009378
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 15:00:28 -0400
Received: by wr-out-0506.google.com with SMTP id c57so553966wra.9
	for <video4linux-list@redhat.com>; Tue, 03 Jun 2008 12:00:28 -0700 (PDT)
Message-ID: <3192d3cd0806031200k48d63141hefbb3df5d812e903@mail.gmail.com>
Date: Tue, 3 Jun 2008 21:00:28 +0200
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Daniel Gimpelevich" <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <loom.20080603T165006-806@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48457617.mail5YC1S9Z5F@vesta.asc.rssi.ru>
	<loom.20080603T165006-806@post.gmane.org>
Cc: video4linux-list@redhat.com
Subject: Re: v4l API question: any support for HDTV is possible?
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

2008/6/3 Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>:
> Sergey Kostyuk <kostyuk <at> vesta.asc.rssi.ru> writes:
>
>> > Have you not seen this at all? http://dxr3.sf.net
>>
>> I know that project. The DXR3 boards dont have HDTV capabilities.
>
> The v4l API is a framework for frame grabbers and hardware encoders. There
> exists no unified API for hardware decoders such as yours. Each hardware decoder
> driver supplies an API of its own. The DXR3 project is most similar
> hardware-wise to what you're coding. Other projects in that category include:

I thought v4l2 has support for video output? Have a look at
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#OUTPUT

Maybe its time to come up with an extension for v4l to support
decoders?! As far as I can see
the DVB API hase some output stuff, as there exists FF-DVB cards with
an mpeg2 decoder
on it. But I think that there should be an api for decoding which gets
used by dvb cards, dxr3
and all other encoder cards.

Greets,
Christian Gmeiner

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
