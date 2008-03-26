Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q1YDm2018665
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 21:34:13 -0400
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q1XhsW015898
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 21:33:43 -0400
Received: by el-out-1112.google.com with SMTP id n30so2008107elf.7
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 18:33:42 -0700 (PDT)
Message-ID: <37219a840803251833l5103a709q116a323951cf95e5@mail.gmail.com>
Date: Tue, 25 Mar 2008 21:33:42 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "kevin liu" <lwtbenben@gmail.com>
In-Reply-To: <9618a85a0803251823x6962b6b2hfc2ceda8e6fbeb34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9618a85a0803251823x6962b6b2hfc2ceda8e6fbeb34@mail.gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PVR-250 on Ubuntu 7.10
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

On Tue, Mar 25, 2008 at 9:23 PM, kevin liu <lwtbenben@gmail.com> wrote:
>  >  Hi all,
>  >
>  >  Hopefully someone out there can help - I'm a relative newbie to Linux,
>  >  and am trying to get my TV card, PVR-250 to work on Ubuntu 7.10.
>  >
>  >  I've read a few "guides" on the web for older versions of Ubuntu, and
>  >  none of them have got me very far.  All I want to be able to do is watch
>  >  live TV, if this is possible!
>  >
>  >  In hardware information I have listed "iTVC16 (CX23416) MPEG-2 Encoder"
>  >  which I am sure is the device.
>  >
>  >  Can anyone give me any advice as to what needs to be done / installed?

> Hi,
>     Of course you can watch live TV using your sweet TV card under Ubuntu7.10.
>  In my opinion, you should set up both the driver and the application.
>     So what's your current status?
>     Is your card USB or PCI?
>     Does any driver find your device successfully?
>
>     The list may need some extra information to help you!


The PVR250 is supported by the 'ivtv' driver, which is included by
default with Ubuntu Gutsy, the version that you are running.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
