Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGIHEL4022974
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:17:14 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAGIGxsb013548
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 13:16:59 -0500
Received: by ey-out-2122.google.com with SMTP id 4so761902eyf.39
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 10:16:58 -0800 (PST)
Message-ID: <412bdbff0811161016w91fc6c1s67e84519e2505b05@mail.gmail.com>
Date: Sun, 16 Nov 2008 13:16:58 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: CityK <cityk@rogers.com>
In-Reply-To: <4920603D.20906@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491CC096.7090107@rogers.com>
	<f3ae23390811140559i5e235c3bvabe8d5004d57165@mail.gmail.com>
	<4920603D.20906@rogers.com>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: AVerMedia EZMaker USB Gold
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

On Sun, Nov 16, 2008 at 1:02 PM, CityK <cityk@rogers.com> wrote:
> Re: 7136
>
> Currently there haven't been many reports of devices using this IC.
> Last spring, Janneg obtained a device using the 7136 and this lead to a
> brief discussion on irc about it.  IIRC, Manu Abrahams, who had access
> to the datasheet at the time and upon a cursory inspection of its info,
> thought that it was likely that support for the chip could be
> incorporated into the existing 713x driver.  I forget any specifics
> about the chip, but I seem to recall that there is something unique
> about it.  (I also seem to recall that it has component input that is
> good enough for capturing full res HDTV...not that many vendors would
> ever implement access to that though).
>
> Anyway, I haven't seen much mention of the chip since, but did happen to
> coincidently catch this post just the other day:
> * http://marc.info/?l=linux-video&m=122675953217105&w=2
> The importance of which becomes clear when seeing:
> *
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Ultimate_Stick_(808e)
>
> So I have cc'ed Devin in on the message as perhaps you two could
> collaborate on this, and I imagine Devin would appreciate any help once
> all the "fun" legal aspect is settled with NXP.

Yes.  I am working on getting the datasheet for this device, and will
definitely be doing driver support for it (unless somebody manages to
beat me to it).  It's good to know what other devices are using this
chip, so I can pick one up and make sure I don't do anything that is
specific to the Pinnacle 808e.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
