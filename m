Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9H3jlqR021357
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 23:45:47 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9H3jWhp023120
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 23:45:33 -0400
Received: by rv-out-0506.google.com with SMTP id f6so308228rvb.51
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 20:45:32 -0700 (PDT)
Message-ID: <59dfca000810162045g5da1a738n66ca8a9305493be4@mail.gmail.com>
Date: Thu, 16 Oct 2008 22:45:32 -0500
From: Lucas <jaffa225man@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <48f79598.2dc.ed1.1231012865@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f79598.2dc.ed1.1231012865@uninet.com.br>
Subject: Re: grabing audio from capture card
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

I don't know all that much about the subject, but I just answered a
similar query a few days ago.  You may have some luck reading the v4l
wiki: http://www.linuxtv.org/v4lwiki/index.php/Main_Page .  In
particular, I think the driver you will want to load is "snd-bt87x"
for your audio.  See
"http://www.linuxtv.org/v4lwiki/index.php/Snd-bt87x_(alsa_bt878_driver)"
for that.  Although, it's not specifically about your card, you might
find the commands at the bottom section of this page to be mainly what
you need (maybe with device-name customizations for your system) too:
"http://www.linuxtv.org/v4lwiki/index.php/Saa7134-alsa".  After you've
loaded your ALSA driver, you may want to `cat /proc/asound/cards` to
get an idea about the order your cards are in for their device names.
I like the low-latency "sox" command at the bottom of the saa7134-alsa
page with my card, such as: "
sox -q -c 2 -s -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -r 32000
/dev/dsp", although it hogs all output to the soundcard. (Note:
/dev/dsp1 and /dev/dsp should reflect the device names for your
capture card, and soundcard, respectively.)

Good luck,

  Lucas

On Thu, Oct 16, 2008 at 2:27 PM,  <danflu@uninet.com.br> wrote:
> Hello!
>
> I have have a capture card (Prolink Pixelview) and i'm
> currently trying to grab audio samples from it. It has an
> "audio input" and an "audio output"
>
> I tested audio using xawtv (Included a "p2 to rca adaptor"
> to plug a digital camcorder in audio input.) and it worked
> well using the loopback cable that conects "audio out" from
> tv card to the sound card "line in" but did not work without
> using this loopback cable...
>
> My device generates the following output:
>
> cap.driver: bttv
> cap.card: BT878 video (Prolink Pixelview
> cap.bus_info: PCI:0000:05:01.0
> cap.version: 2321
>
> Printing /dev/video0 capabilities
>
> V4L2_CAP_VIDEO_CAPTURE
> V4L2_CAP_VIDEO_OVERLAY
> V4L2_CAP_VBI_CAPTURE
> V4L2_CAP_TUNER
> V4L2_CAP_READWRITE
> V4L2_CAP_STREAMING
>
>
> What device should i use to grab audio samples (videox ?) ?
> The usage of the v4l api is the same to grab audio ? (memory
> mapping etc?)
>
> I observed that xawtv did not playback any audio without the
> loopback cable, so it seems that it is not possible to
> capture audio using v4l without this cable, is it true ???
>
> Please help !
> Thank you
> Daniel
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>


-- 
Protect your digital freedom and privacy, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
On a related note, also see BadVista.org: Stopping Vista adoption by
promoting free software

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
