Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51188 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKDPDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 10:03:21 -0500
Received: by mail-ie0-f173.google.com with SMTP id tr6so7601726ieb.4
        for <linux-media@vger.kernel.org>; Tue, 04 Nov 2014 07:03:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <20141102225704.GM3136@valkosipuli.retiisi.org.uk> <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
 <20141104115839.GN3136@valkosipuli.retiisi.org.uk> <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 4 Nov 2014 15:02:58 +0000
Message-ID: <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
To: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've add to change guvcview so that it now generates it's own
monotonic timestamps, kernel timestamps (uvcvideo at least), caused a
similar problem, e.g:
I would get a couple of frames with correct timestamps, then I would
get at least one with a value lower than the rest, this caused
playback to stutter.
I didn't had time to check the cause, but it has been like this for
quite some time now.

Regards,
Paulo

2014-11-04 12:42 GMT+00:00 Rémi Denis-Courmont <remi@remlab.net>:
> Le 2014-11-04 14:58, Sakari Ailus a écrit :
>>>
>>> > Have you tried with a different application to see if the problem
>>> > persists?
>>>
>>> Tried mplayer and cheese now, and it seems they are not affected, so
>>> it's an issue with vlc. I wonder why it doesn't like newer flags..
>>>
>>> Ohwell, sorry for the noise.
>>
>>
>> I guess the newer VLC could indeed pay attention to the monotonic
>> timestamp
>> flag. Remi, any idea?
>
>
> VLC takes the kernel timestamp, if monotonic, since version 2.1. Otherwise,
> it generates its own inaccurate timestamp. So either that code is wrong, or
> the kernel timestamps are.
>
> --
> Rémi Denis-Courmont
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
