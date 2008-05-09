Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49JIah9013477
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 15:18:36 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49JIQWV022951
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 15:18:26 -0400
Received: by wr-out-0506.google.com with SMTP id c57so613559wra.9
	for <video4linux-list@redhat.com>; Fri, 09 May 2008 12:18:26 -0700 (PDT)
Message-ID: <d9def9db0805091218k4534a4a4v6e657ccab46c6e0b@mail.gmail.com>
Date: Fri, 9 May 2008 21:18:25 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: rmantovani@libero.it
In-Reply-To: <1210347474.15033.10.camel@mandoch.ael.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210347474.15033.10.camel@mandoch.ael.it>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: How to view camera output with xine
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

On 5/9/08, Roberto Mantovani - A&L <rmantovani@libero.it> wrote:
> Hi,
>
> I'm working on a em28xx based usb camera.
>
> How can I view the camera output with xine ?
>
> With mplayer I run the command : mplayer tv://
>
> With xine I've tried : xine v4l2:// but xine give me a message : "there
> is no input plugin available to handle v4l2://", but if I try xine
> --list-pugins there is :
> -Input:
>    ...,v4l_tv, ...
>
> I have to write a program in fltk to handle the video out of the cam.
> Do you know other methods to use the video out of the camera in a
> program ?
>

xine is currently not supported by that device, there's a project to
add support for it  but it's stalled and lies around on my disk at the
moment...

Currently mplayer, tvtime and vlc are verified.
Whereas vlc needs to be patched. As for video the latest svn version
should work out of the box, but it still requires an audiopatch for
proper audio playback.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
