Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84FgSJA027695
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 11:42:29 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.182])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84FekTs003153
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 11:40:46 -0400
Received: by py-out-1112.google.com with SMTP id a29so4635pyi.0
	for <video4linux-list@redhat.com>; Thu, 04 Sep 2008 08:40:43 -0700 (PDT)
Message-ID: <f4fceb150809040812j5be9b4a8pc2456254e3fbefa1@mail.gmail.com>
Date: Thu, 4 Sep 2008 18:12:58 +0300
From: "Yair Weinberger" <yairwein@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48BFEAF2.9060805@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4fceb150809011152n2a0adf2aqffb67a4cf87449c3@mail.gmail.com>
	<f4fceb150809011155pa06831eoff1ef993d3eb17c9@mail.gmail.com>
	<48BFEAF2.9060805@linuxtv.org>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Hauppauge WinTV USB2-Stick with Hardy
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

Hi,
Thanks for your help.
My hardware's ID doesn't appear also on the tm6010 tree. (grep -r
"0x2040, 0x6610" * returns nothing).
It appears that it is actually HVR 900H.

Anything else I should try?

  Wein

On Thu, Sep 4, 2008 at 5:04 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Yair Weinberger wrote:
>>
>> Hi,
>> I bought a new Hauppauge WinTV USB2-Stick (At least that's the writing
>> on the card).  According to the v4l documentation, this card should be
>> supported in the em28xx drivers (card #4).  However, in the
>> documentation the vendor & device ID should be 2040:4200 or 2040:4201,
>> and my output of lsusb is 2040:6610.
>> I checked the em28xx-cards.c file, and my ID doesn't seem to appear
>> there (nor in any other file as far as I know).
>> The device is of course not automatically recognized, Output of dmesg
>> | grep em28xx:
>> [  198.082257] em28xx v4l2 driver version 0.1.0 loaded
>> [  198.082294] usbcore: registered new interface driver em28xx
>>
>> Trying to load it with card=4 produced the following error in the dmesg
>> output:
>> em28xx probing error: endpoint is non-ISO endpoint.
>>
>> I attached what I think is the appropriate inf file from the Windows
>> drivers disk (renamed as text).  I will happily provide more data if
>> required.
>>
>> Any advice will be appreciated,
>>  Wein
>
> The 66xx model is not supported my the em28xx driver.
>
> For this you need Mauro's tm6010 development trees at
> linuxtv.org/hg/~mchehab/... although I'm not sure what level of support he
> has for that unit.
>
> - Steve
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
