Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAB2hGpk028987
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 21:43:16 -0500
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAB2h05v019570
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 21:43:01 -0500
Received: by ti-out-0910.google.com with SMTP id 24so1846608tim.7
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 18:43:00 -0800 (PST)
Message-ID: <1cf807b00811101842k1ce60474rd9ed17f28ae5772f@mail.gmail.com>
Date: Tue, 11 Nov 2008 10:42:59 +0800
From: "Kris Huang" <imaborg@gmail.com>
To: mark.paulus@verizonbusiness.com
In-Reply-To: <49185431.2070701@verizonbusiness.com>
MIME-Version: 1.0
References: <1cf807b00811100709p5c70701aoa11043e4d12388c8@mail.gmail.com>
	<49185431.2070701@verizonbusiness.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: How to stop driver from loading to prevent from hanging during
	booting
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

    Thanks Mark.
    I've downloaded a copy of the missing firmware file but have no luck.
    In dmesg, it shows having problem when trying to use the firmware file.
    Though I still can't switch channel in tvtime, but the video is working*
*alright.*
   *I am seriously considering opening the tin box to see what exactly the
tuner chip is.
   (I can find the decoder chip which is saa7135 actually, but didn't see
the tuner chip)*

 *  It's very kind of you also provided me a way to modify the blacklist
file when the file system is under read-only status.
   The funny thing is I can still boot into system by using the previously
built kernel. ( 2.6.24-21-generic is still in the Grub menu)
   So I still have access to modify the blacklist and disable the saa7134
driver from loading.
   It's really appreciated.
   Thank you.
   Kris.
*
*
On Mon, Nov 10, 2008 at 11:33 PM, Mark Paulus <
mark.paulus@verizonbusiness.com> wrote:

>
>
> Kris Huang wrote:
>
>> Hi,
>>
>>  Good day.
>>  In order to get my Compro T750F channel switch working, I use hg and
>> download the latest v4l drivers. After make install and reboot, my Ubuntu
>> Intrepid box just hanged. I am not that familiar with Ubuntu, so I don't
>> know how to stop the trouble driver from being loaded during the boot
>> process.
>>  Any ideas?
>>  Thanks.
>>
>>
> looks like you need to add a file to /etc/modprobe.d directory,
> something called, maybe, v4l-blacklist, and in it, put in the driver name
> that is hanging....  (looks like saa7134).
>
> Have you downloaded firmware for this card, and put it into
> /lib/firmware?
> There looks to be a bit of info in this post:
> http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017433.html
>
> BTW, if booting into single user mode still tries to load the
> driver, then you will need to boot off of a CD or floppy.  Your
> Install media might have a "Go to Shell" option where you can
> mount your hard drive and then edit your files, or something like
> Tomsrtbt disk, or "The Ultimate Boot CD (UBCD)), or even
> Mythubuntu or Knoppix/Mythknoppix.  Basically
> you need to boot any kind of linux kernel/system that will allow you to go
> to a shell, mount your hard drive,
> and then have vi or some other editor that will allow you to create the
> file(s) you need.
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
