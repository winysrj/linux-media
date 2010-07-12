Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6CENXdW024570
	for <video4linux-list@redhat.com>; Mon, 12 Jul 2010 10:23:33 -0400
Received: from mail-gy0-f174.google.com (mail-gy0-f174.google.com
	[209.85.160.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6CENMAW021519
	for <video4linux-list@redhat.com>; Mon, 12 Jul 2010 10:23:22 -0400
Received: by gye5 with SMTP id 5so3232326gye.33
	for <video4linux-list@redhat.com>; Mon, 12 Jul 2010 07:23:22 -0700 (PDT)
Message-ID: <4C3B248E.5050901@gmail.com>
Date: Mon, 12 Jul 2010 11:19:58 -0300
From: Bruno Barberi Gnecco <brunobg@gmail.com>
MIME-Version: 1.0
To: "Vitor P." <dodecaphonic@gmail.com>
Subject: Re: Multiple webcams using the same driver
References: <AANLkTilZ4-9RNbk-QLKo8KpjsxMwFEf7avg4Fjn7Kxx6@mail.gmail.com>
In-Reply-To: <AANLkTilZ4-9RNbk-QLKo8KpjsxMwFEf7avg4Fjn7Kxx6@mail.gmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

	I only tested 2 Lifecams (model 045e:075d) simultaneously and it worked, but I think they 
were on different buses. But you won't be able to synchronize USB webcams -- it seems to 
be impossible, as there is no hardware support for triggers (it's either internal or not 
supported by the USB). Some firewire cameras support that, but for most purposes you can 
live without synchronization if your frame rate is 30fps or more.

	Now, my turn: have you been able to turn off the autogain and autoexposure of these cams? 
Mine are recognized as v4l1 and I can't find a way to do that.

	See you,

> Hello, all. I'm new to this list, and I bring a question. I'm sorry if the
> archives hold its answer; I swear I've tried every search I could think of
> and still didn't find a definitive answer to my question.
>
> I'm trying to build a sort of Street View car, for kicks, using cheap
> webcams as the source for the images. I have gotten seven Microsoft LifeCam
> VX-1000 from a friend, and proceeded to connect all of them to powered USB
> hubs. They were recognized, and a couple of V4L applications were used to
> test them individually; all went great.
>
> But my use case, alas, requires them to fire simultaneously, or as close to
> at the same time as possible. I couldn't: whenever I tried more than one
> camera on the same bus, "libv4l2: error turning on stream: Input/output
> error
> libv4l2: error reading: Invalid argument
> v4l2: read: Invalid argument" popped on my face. On two different buses,
> fine.
>
> Is it really not possible to use this camera (with "sonixj") in conjunction
> with sister cameras of the same model?
>
> Thanks in advance. I apologize for any mistakes and my unquestionable
> ignorance.
>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
