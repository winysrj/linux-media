Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9E7hajC004221
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 03:43:36 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9E7hLP0007010
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 03:43:21 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2070742rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 00:43:21 -0700 (PDT)
Message-ID: <59dfca000810140043p71dc351dy9c68ce8a8a6a985b@mail.gmail.com>
Date: Tue, 14 Oct 2008 02:43:21 -0500
From: Lucas <jaffa225man@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <48EBAD93.5010301@rongage.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48EBAD93.5010301@rongage.org>
Subject: Re: V4L Help Needed
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

I'm no expert here, but I think I may know your issue, Ron.  Although
you don't have an saa7134-based card, this page may help, particularly
the commands near the bottom:
http://www.linuxtv.org/v4lwiki/index.php/Saa7134-alsa .  If that
doesn't work (and computer internals are familiar to you) you may be
able to attach an audio cable from your capture card to one of your
soundcard's inputs and then adjust the volume on that input.  In
general, the video4linux wiki
(http://www.linuxtv.org/v4lwiki/index.php/Main_Page) is usually quite
helpful, as is this list.

Good luck,

   Lucas


On Tue, Oct 7, 2008 at 1:42 PM, Ron Gage <ron@rongage.org> wrote:
> Can someone please point me to some place where I can get support for a
> V4L/V4L2 problem I am having.
>
> I have a BT878 based card - a Viewcast Osprey 230.  The video works great.
>  The audio does not.  The audio device (/dev/dsp1) is coming up, but no
> audio is coming out.  Changing settings via alsamixer - any setting(s) -
> makes no difference.
>
> Can someone please help me here!
>
> OS is Slackware 12, kernel 2.6.26.5, test app is vlc.
>
> Ron Gage
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
