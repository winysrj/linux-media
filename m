Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0M7vZYZ006829
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 02:57:35 -0500
Received: from mail-pz0-f180.google.com (mail-pz0-f180.google.com
	[209.85.222.180])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0M7vJSJ015346
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 02:57:20 -0500
Received: by pzk10 with SMTP id 10so698559pzk.19
	for <video4linux-list@redhat.com>; Thu, 21 Jan 2010 23:57:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <13c9a3ca1001211916n558736e9ic8dc17f4dfe99d37@mail.gmail.com>
References: <13c9a3ca1001211916n558736e9ic8dc17f4dfe99d37@mail.gmail.com>
Date: Fri, 22 Jan 2010 15:57:19 +0800
Message-ID: <cad107561001212357w2c90a11bl413e165eee6c05ea@mail.gmail.com>
Subject: Re: streamer
From: Jeyner Gil Caga <jeynergilcaga@gmail.com>
To: Cristiana Tenti <cristenti@gmail.com>,
        video4linux list <video4linux-list@redhat.com>
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

Hi Cristiana,

I have done this with PPC440Epx about 2 years ago but I don't have the
modified XAWTV source codes, configuration and the makefiles  right now.
As far as I can remember, I did the following things and I suggest you do
the same:

-make sure that your USB webcam works in normal linux installation, not
uclinux.
-determine the basic plugins needed to make it work, i think v4l2 and jpeg
plugins are needed, this case, you need to edit the makefiles so that it
will only compile the necessary plugins. in XAWTV, there is a folder for the
plugins. try to take a look into it. also, take note that when you install
the XAWTV package, the plugin directory should only contain the basic
plugins i mentioned.
-once you know the basic plugins, try to cross-compile them. i think you
need to set your plugin directory. after cross compiling, try to copy the
streamer, its plugins and libraries.
 I hope this helps.

On Fri, Jan 22, 2010 at 11:16 AM, Cristiana Tenti <cristenti@gmail.com>wrote:

> Hello,
> I'm a new user :)
>
> I'm working on a simple project and for that I only need to a software for
> uclinux to acquire a raw image from my usb webcam.
> On Ubuntu I'm using STREAMER but I cannot find the source code to install
> it
> on my uclinux platform.
>
> Anyway I found xawtv and I saw that this usefull software has as tool
> STREAMER.
>
> Do you know if it is possible compile only streamer and not all package of
> xawtv?
>
> Please, if you can help me answer me!!!
>
> Thank you in advance,
>
> Best Regards
>
> --
> -Cristiana
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
