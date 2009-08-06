Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n76K7aPn008129
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 16:07:36 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n76K7Mh0029122
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 16:07:22 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n76K7LDn017752
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 16:07:21 -0400
Message-ID: <4A7B37F9.8070905@tmr.com>
Date: Thu, 06 Aug 2009 16:07:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
CC: video4linux M/L <video4linux-list@redhat.com>
References: <4A7B2BDB.5000906@tmr.com>
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
In-Reply-To: <829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Is there any working video capture card which works and is still
 made?
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

Devin Heitmueller wrote:
> On Thu, Aug 6, 2009 at 3:15 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>   
>> I have a lovely collection of capture cards which either don't work or are
>> no longer available new. Is there any such card?
>>
>> Note: I can't tell a client to buy hardware on eBay, or to patch a kernel,
>> or commit to providing patched kernel... and we're in Time-Warned land,
>> where the signal is a mix of clear digital, crypto-digital, and NTSC. I
>> *can* tell someone to spend money to get something supported, which they
>> could buy in some small quantity.
>>
>> I would be happy with a box like the HDhomerun, which does a nice job on the
>> tiny list of clear digital signals, the Hauppauge HVR-2250 is ideal, but
>> doesn't work because the driver isn't in the kernel and the windows stuff
>> doesn't run on ndiswrapper (too complex to support anyway).
>>
>> Any thoughts, or is it just not currently happening?
>>
>> --
>> bill davidsen <davidsen@tmr.com>
>>  CTO TMR Associates, Inc
>>
>> "You are disgraced professional losers. And by the way, give us our money
>> back."
>>   - Representative Earl Pomeroy,  Democrat of North Dakota
>> on the A.I.G. executives who were paid bonuses  after a federal bailout.
>>     
>
> There are lots of cards that work.  The big questions lie in what bus
> type you need (USB/PCI/PCIe), and what featureset (ATSC, ClearQAM,
> analog, IR, etc.)
>
>   
Though I covered that, the signal of interest is clear QAM and NTSC 
(analog). I haven't seem any cards for busses other than PCI or PCIe, 
USB is only on a dongle (AFAIK). If I could pass access to the bus back 
to a VM I could just run XP under KVM, but that's not exactly supported, 
either.

I was hoping someone would pop up with a solution like a dual mode 
HDhomerun or slingshot, too much to hope.

> Might also be nice what your large collection is composed of, since we
> might be able to get some of them to work.
>   

Nothing with a driver, unfortunately, and much of it obsolete by this 
time, ie. driver now but out of production. When the FCC stopped 
approving non-digital cards a lot of stuff went off the market. I'd go 
with a mix of analog card and HDhomerun if I had to.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
