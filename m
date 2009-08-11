Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BHbllQ025631
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 13:37:47 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7BHbTjT006806
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 13:37:30 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n7BHbT6b010114
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 13:37:29 -0400
Message-ID: <4A81AC59.5020306@tmr.com>
Date: Tue, 11 Aug 2009 13:37:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
References: <4A7B2BDB.5000906@tmr.com>	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>	<4A7B37F9.8070905@tmr.com>
	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
In-Reply-To: <829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

I thank all the folks who wrote me directly, but... see below.

Devin Heitmueller wrote:
> On Thu, Aug 6, 2009 at 4:07 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>> Though I covered that, the signal of interest is clear QAM and NTSC
>> (analog). I haven't seem any cards for busses other than PCI or PCIe, USB is
>> only on a dongle (AFAIK). If I could pass access to the bus back to a VM I
>> could just run XP under KVM, but that's not exactly supported, either.
> 
> Well, I'm not sure you really answered the question.  What bus type
> specifically are you looking for?  For PCI you can go with HVR-1600 or
> PCTV 800i.  For USB you can get HVR-950q or HVR-1950 if you want an
> onboard MPEG encoder.  There are lots of products which are currently
> supported.  A good amount of this also depends on which distro and
> version you are interested in (since that effects which kernel it is
> up to relative to when support was added for products).
> 
> Have you looked at the product matrices on the Wiki:
> 
> http://linuxtv.org/wiki/index.php/ATSC_USB_Devices
> http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards
> http://linuxtv.org/wiki/index.php/ATSC_PCIe_Cards
> 
>> I was hoping someone would pop up with a solution like a dual mode HDhomerun
>> or slingshot, too much to hope.
>>
>>> Might also be nice what your large collection is composed of, since we
>>> might be able to get some of them to work.
>>>
Since you quoted the HVR-950Q as working, I tried one of those. Someone else 
said the ATI HDTV-Wonder works. Neither do. I tried all of the programs people 
swore work with these cards: tvtime, xawtv, cheese, and vlc. Mythtv appears to 
need the whole system tuned to be a pvr, not the intent here, users want to 
monitor CNN, MSNBC, and similar news or financial channels in a window without 
needing to get a TV for each seat.

And after all that I am still at ground zero, not only nothing I would date try 
to give to an end user, but nothing I want to use myself, tuning by frequencies 
in MHz, good grief! The kernel loads drivers and makes entries in /dev/dvb 
and/or /dev/videoN, but none of the software people suggested does anything useful.

>> Nothing with a driver, unfortunately, and much of it obsolete by this time,
>> ie. driver now but out of production. When the FCC stopped approving
>> non-digital cards a lot of stuff went off the market. I'd go with a mix of
>> analog card and HDhomerun if I had to.
> 
> Well, the notion of "nothing with a driver" is pretty subjective.  We
> are adding driver support for products all the time, and if you threw
> out a list of product names they might now be supported or could be
> supported with minimal effort.
> 
> Devin
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
