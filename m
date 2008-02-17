Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1HH1SfP024279
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 12:01:28 -0500
Received: from smtpout.kotinet.com (smtpout.kotinet.com [212.50.215.76])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1HH0tIE001099
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 12:00:55 -0500
Message-ID: <47B86835.9060505@iki.fi>
Date: Sun, 17 Feb 2008 19:00:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Muppet Man <muppetman4662@yahoo.com>
References: <653934.59125.qm@web34401.mail.mud.yahoo.com>
In-Reply-To: <653934.59125.qm@web34401.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Jussi Torhonen <jt@iki.fi>
Subject: Re: Trouble compiling driver in PClinuxOS
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

heis
This same error occurs with CentOS 5.1 i386 (32-bit). Solution can be 
found from:
http://mysettopbox.tv/phpBB2/viewtopic.php?p=105504
Please fix.

regards
Antti

Muppet Man wrote:
> Greetings all,
> I am having trouble compiling the latest v4l-dvb in order to get my pinnicale pci card to work.  I am running PClinuxOS 2007.  I have downloaded the latest tree, mkdir v4l-dvb extracted the tz file to that folder, went into root mode and got this error when I make the file
> 
> make -C /home/ed/v4l-dvb/v4l
> make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.18.8.tex5/build
> make -C /lib/modules/2.6.18.8.tex5/build SUBDIRS=/home/ed/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-2.6.18.8.tex5'
>   CC [M]  /home/ed/v4l-dvb/v4l/videodev.o
> /home/ed/v4l-dvb/v4l/videodev.c:491: error: unknown field 'dev_attrs' specified in initializer
> /home/ed/v4l-dvb/v4l/videodev.c:491: warning: initialization from incompatible pointer type
> /home/ed/v4l-dvb/v4l/videodev.c:492: error: unknown field 'dev_release' specified in initializer
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: missing braces around initializer
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: (near initialization for 'video_class.subsys')
> /home/ed/v4l-dvb/v4l/videodev.c:492: warning: initialization from incompatible pointer type
> make[3]: *** [/home/ed/v4l-dvb/v4l/videodev.o] Error 1
> make[2]: *** [_module_/home/ed/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.18.8.tex5'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
> 
> I know this driver works because I had it running under ubuntu, but I heard so much about PClinuxOS that I thought I would give it a shot.
> 
> Any help would be greatly appreciated.
> Ed

-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
