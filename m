Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BLmMZq003423
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 17:48:22 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7BLm8TD028078
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 17:48:08 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n7BLm7f5010693
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 17:48:07 -0400
Message-ID: <4A81E717.1040509@tmr.com>
Date: Tue, 11 Aug 2009 17:48:07 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
CC: video4linux M/L <video4linux-list@redhat.com>
References: <4A7B2BDB.5000906@tmr.com>	
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>	
	<4A7B37F9.8070905@tmr.com>	
	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>	
	<4A81AC59.5020306@tmr.com>
	<829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
In-Reply-To: <829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
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
> On Tue, Aug 11, 2009 at 1:37 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>   
>> Since you quoted the HVR-950Q as working, I tried one of those. Someone else
>> said the ATI HDTV-Wonder works. Neither do. I tried all of the programs
>> people swore work with these cards: tvtime, xawtv, cheese, and vlc. Mythtv
>> appears to need the whole system tuned to be a pvr, not the intent here,
>> users want to monitor CNN, MSNBC, and similar news or financial channels in
>> a window without needing to get a TV for each seat.
>>     
>
> Well since I did the support for the HVR-950Q, I'm pretty sure it
> works. :-)  With regards to the "ATI HDTV-Wonder" card you referred
> to, there are many cards with that name, so you would need to be more
> specific (providing a model number and bus type).  For example, I did
> the work for the "ATI TV Wonder HD 600 USB".  For analog support, both
> of the above cards work fine with tvtime.
>
>   
Do you have some particular application with which you think it "works?" 
If by works you mean a /dv/video0 and /dev/dvb/* ar created and the 
kernel log shows no errors, then it works. By works I mean there is some 
application (I listed several) which actually has audio and video, and 
the number of such I can identify is still zero. When analog cards were 
being made virtually every application worked fine,

> If you have a specific case that is causing you problems, please
> provide details as to exactly which card you are trying to use, which
> distro and application you are using, and what errors you are seeing
> and we will see if we can help you debug your problem.  But saying
> vague things like "nothing works" isn't really a constructive way to
> improve your situation.
>
>   
I went out and got the HVR-950Q because you said it worked, as noted 
above the kernel like it but nothing I can find will use it usefully, I 
posted the lspci -vvvv for the ATI HDTV-Wonder, what exactly more do you 
need to identify a specific card? This is the problem I've had for 
years, that cards with the same part number aren't the same part. :-(
>> And after all that I am still at ground zero, not only nothing I would date
>> try to give to an end user, but nothing I want to use myself, tuning by
>> frequencies in MHz, good grief! The kernel loads drivers and makes entries
>> in /dev/dvb and/or /dev/videoN, but none of the software people suggested
>> does anything useful.
>>     
>
> You only need to tune to something specifying MHz if you are using the
> command line tools.  The GUI applications have built in mechanisms to
> change channels.
>
> I agree that there is plenty of room for improvement in the
> application space.  Feel free to roll up your sleeves and help out
> (that's how I got involved in the project, after all).  Given the
> number of devices people are demanding support for, we are quite
> understaffed and could use all the help we could get.
>
> Devin
>
>   


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
