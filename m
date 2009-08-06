Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n76KJCBQ016158
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 16:19:12 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n76KItab014104
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 16:18:55 -0400
Received: by gxk21 with SMTP id 21so1399880gxk.3
	for <video4linux-list@redhat.com>; Thu, 06 Aug 2009 13:18:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7B37F9.8070905@tmr.com>
References: <4A7B2BDB.5000906@tmr.com>
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
	<4A7B37F9.8070905@tmr.com>
Date: Thu, 6 Aug 2009 16:18:54 -0400
Message-ID: <829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Is there any working video capture card which works and is
	still made?
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

On Thu, Aug 6, 2009 at 4:07 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> Though I covered that, the signal of interest is clear QAM and NTSC
> (analog). I haven't seem any cards for busses other than PCI or PCIe, USB is
> only on a dongle (AFAIK). If I could pass access to the bus back to a VM I
> could just run XP under KVM, but that's not exactly supported, either.

Well, I'm not sure you really answered the question.  What bus type
specifically are you looking for?  For PCI you can go with HVR-1600 or
PCTV 800i.  For USB you can get HVR-950q or HVR-1950 if you want an
onboard MPEG encoder.  There are lots of products which are currently
supported.  A good amount of this also depends on which distro and
version you are interested in (since that effects which kernel it is
up to relative to when support was added for products).

Have you looked at the product matrices on the Wiki:

http://linuxtv.org/wiki/index.php/ATSC_USB_Devices
http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards
http://linuxtv.org/wiki/index.php/ATSC_PCIe_Cards

> I was hoping someone would pop up with a solution like a dual mode HDhomerun
> or slingshot, too much to hope.
>
>> Might also be nice what your large collection is composed of, since we
>> might be able to get some of them to work.
>>
>
> Nothing with a driver, unfortunately, and much of it obsolete by this time,
> ie. driver now but out of production. When the FCC stopped approving
> non-digital cards a lot of stuff went off the market. I'd go with a mix of
> analog card and HDhomerun if I had to.

Well, the notion of "nothing with a driver" is pretty subjective.  We
are adding driver support for products all the time, and if you threw
out a list of product names they might now be supported or could be
supported with minimal effort.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
