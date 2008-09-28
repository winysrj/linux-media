Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8S0LplA026420
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 20:21:52 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8S0Lel7028164
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 20:21:40 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1590728rvb.51
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 17:21:40 -0700 (PDT)
Message-ID: <208cbae30809271721m4bd152d8gc5b7e404711d9a53@mail.gmail.com>
Date: Sun, 28 Sep 2008 04:21:40 +0400
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080925113932.GA21999@shell.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30809250429m64c1c552ud18ff5064602e3c0@mail.gmail.com>
	<20080925113932.GA21999@shell.devel.redhat.com>
Subject: Re: radio-mr800 usb driver
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

On Thu, Sep 25, 2008 at 3:39 PM, Alan Cox <alan@redhat.com> wrote:
> On Thu, Sep 25, 2008 at 03:29:55PM +0400, Alexey Klimov wrote:
>> Driver works fine with kradio & gnomeradio applications. Works normal
>> under Linux kernel  2.6.27-rc6 (released 9 Sep 2008), compiles without
>> warnings with gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) on
>> x86-architecture machine.
>
> Looks nice and clean to me. No obvious mistakes. Probably the warn()
> statements should include the module name so people know which module
> produced them if they ever want to file a bug.
>
> Alan

Hello,
I'm so sorry. I put err() and warn() statements in "static int __init
amradio_init(void)" section, compile, insmod module and looked at
dmesg. So i got smth like this:

radio_mr800: 0.01 AverMedia MR 800 USB FM radio driver
radio_mr800: Error statement test
radio_mr800: Warn statement test

Seems, like warn() statement already includes module name.
Maybe I configured kernel in debug mode, that's why i got module name
in dmesg or it's default behaviour of kernel-message logging API ?

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
