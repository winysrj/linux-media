Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1MIXKT028401
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:18:33 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com
	(mk-filter-1-a-1.mail.uk.tiscali.com [212.74.100.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1MIJBA020237
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 17:18:20 -0500
From: "Chris Grove" <dj_gerbil@tiscali.co.uk>
To: "'Thierry Merle'" <thierry.merle@free.fr>
References: <002901c95150$44c16b90$ce4442b0$@co.uk>
	<4931ADCD.2000407@free.fr>	<011901c952f4$a02d9710$e088c530$@co.uk>
	<4932ACE9.7030309@free.fr> <012301c95302$6eed5f60$4cc81e20$@co.uk>
	<013f01c9532a$8dcbdf10$a9639d30$@co.uk> <493301D5.5050001@free.fr>
	<000301c95341$504c5810$f0e50830$@co.uk> <493451C5.9010406@free.fr>
In-Reply-To: <493451C5.9010406@free.fr>
Date: Mon, 1 Dec 2008 22:18:02 -0000
Message-ID: <00bf01c95402$ae3c6070$0ab52150$@co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Cc: video4linux-list@redhat.com
Subject: RE: Hauppauge WinTV USB Model 566 PAL-I
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

-----Original Message-----
From: Thierry Merle [mailto:thierry.merle@free.fr] 
Sent: 01 December 2008 21:06
To: Chris Grove
Subject: Re: Hauppauge WinTV USB Model 566 PAL-I

Chris Grove wrote:
> -----Original Message-----
> From: Thierry Merle [mailto:thierry.merle@free.fr]
> Sent: 30 November 2008 21:13
> To: Chris Grove
> Cc: video4linux-list@redhat.com
> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
> 
> Chris Grove wrote:
>> A further, slightly interesting development is that the s-video input 
>> works fine with no interference at all, also the TV picture in fine 
>> in
> windows.
>> Just thought that might help with a solution.
>>
> Right, this helps. We can deduce this does not come from the 
> decompression algorithm since it is the same whether the TV input or 
> the s-video input is selected.
> I suspect a tda9887/saa7113 interface problem but just my intuition.
> As it works under windows, can you do an usbsnoop
> (http://www.linuxtv.org/v4lwiki/index.php/Usbsnoop)
> Just open the TV application, let it tune the channel and stop the 
> application immediately in order to have a minimal capture file.
> 
> For the audio over USB, in the ancient times I developed a audio 
> extension for usbvision. I don't even know what I did from it. I can 
> look for it if you want. I will need to sweep the dust (compilation 
> errors and so on) but should work.
> 
> P.S.: this thread is really hard to follow now... please reply under 
> my answer so that we will be able to read that again :)
> 
> Hi, yea sorry about that, Outlook always starts at the top of the message.
> Anyway, I've used USB Snoop and ended up with a 45Mb file. Now I'm 
> guessing you don't need all of it so there is a portion of it below my 
> answer. As for the audio-over-usb, yes please, I wouldn't mind a look 
> at the code if you can find it. Anyway here's that sample, Thanks for the
help.
I found the audio-over-usb code (see attached). The code may need some
cleanups and can cause kernel oops.
The USB snoops need to be analyzed. Can you put it on a site so that I can
download it?
Nevertheless you can read what I wrote when I was programming the
audio-over-usb driver here:
http://thierry.merle.free.fr/articles.php?lng=en&pg=82
The page was translated to English using google translate so there may be
some problems of understanding :) For some more information about the
usbvision chip, I wrote a page here:
http://thierry.merle.free.fr/articles.php?lng=en&pg=68

As a first step, I will look at the register accesses. They begin with a
line like this:
00000000: 00000000: 42 33 00 00
With the datasheet I can understand what the windows driver is setting.

[SNIP]

> -- URB_FUNCTION_CONTROL_TRANSFER:
>   PipeHandle           = 8ac23cfc [endpoint 0x00000001]
>   TransferFlags        = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
> ~USBD_SHORT_TRANSFER_OK)
>   TransferBufferLength = 00000001
>   TransferBuffer       = a1745938
>   TransferBufferMDL    = 00000000
>     00000000: 30
>   UrbLink              = 00000000
>   SetupPacket          =
>     00000000: 42 33 00 00 07 00 01 00
For example here you have a register programming #07 (SER_MODE from the
NT1004 datasheet).
Value is 0x30 (TransferBufferMDL line). Means MODE=3.
This is just for the example, this one is not interesting.
There are other registers more interesting but I should have the complete
log to find out.

You may have sent me the sufficient data to investigate but in doubt give me
the complete logs.
Of course you can look at the problem if you are interested.

Thanks
Thierry

Hi Thierry, Thanks for the links to you code, I'll download it and have a
look. Here's hoping I can work out what's going on in it. I've uploaded the
whole of the log to my skydrive, the link is below. 
http://cid-19380f9184511dde.skydrive.live.com/browse.aspx/Public
To be honest I'm only a learner when it comes to linux and c++ programming,
I'm more of a basic programmer so I need all the help I can get my hands on.
Thanks in advance for all your help. Chris. 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
