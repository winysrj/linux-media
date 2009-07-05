Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n65Lg6WW000784
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 17:42:06 -0400
Received: from mail-bw0-f221.google.com (mail-bw0-f221.google.com
	[209.85.218.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n65LfmUG022882
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 17:41:48 -0400
Received: by bwz21 with SMTP id 21so3376945bwz.3
	for <video4linux-list@redhat.com>; Sun, 05 Jul 2009 14:41:47 -0700 (PDT)
Message-ID: <4A511E18.2010305@gmail.com>
Date: Mon, 06 Jul 2009 01:41:44 +0400
From: fsulima <fsulima@gmail.com>
MIME-Version: 1.0
To: Jackson Yee <jackson@gotpossum.com>
References: <4A5089CF.3070606@gmail.com>
	<26aa882f0907051330y6f092ca3x18e1f58e883352d4@mail.gmail.com>
In-Reply-To: <26aa882f0907051330y6f092ca3x18e1f58e883352d4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Please advise: 4channel capture device with HW compression for
 Linux based DVR
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

Hi Jackson.

Thanks for the answer.
The first thing I realized when I learned how to use search on the 
mailing list was that this question is very common so I was already 
preparing to shot myself expecting the hear the advice to learn to use 
search. :) It's a shame.
Ok, back to the point...

The problem here is that I have a little unconventional hardware: it is 
a small form factor Intel D945GCLF2D mini-ITX Motherboard + 
integrated Intel Atom 330 2core 1.6Ghz. I have doubts about it's ability 
to encode 4 channels of D1, besides Intel advertises Atom's performance 
as video encoder: 
http://www.intel.com/design/intarch/applnots/DSS_Appnote_r5.pdf.
I really don't want to setup another device specifically for DVR, 
especially with large form factor. Installing cheap capture device w/o 
h/w compression sounds like a great option, but I'd really like to be 
sure that Atom 330 is capable enough for this. Is there any expertise on 
this?

Regards,
F S

Jackson Yee wrote:
> If you're looking for a hardware card, the guys at bluecherry have
> upcoming cards which should fit your needs quite nicely:
>
> http://store.bluecherry.net/category_s/115.htm
>
> For a four camera solution though, you can do real-time x264 encode
> with a cheap dual-core processor. There's no need to buy the more
> expensive hardware encoding cards unless you go for a 8 or 16 channel
> solutions.
>
> Regards,
> Jackson Yee
> The Possum Company
> 540-818-4079
> me@gotpossum.com
>
> On Sun, Jul 5, 2009 at 7:09 AM, fsulima<fsulima@gmail.com> wrote:
>   
>> Hi all.
>>
>> I'm looking for components to build 4 channel Linux-based DVR solution
>> exploiting hardware compression.
>> Although I found some such boards, they do not appear to be supported under
>> Linux.
>>
>> Please advise.
>>
>> WBR,
>> F S.
>>     
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
