Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9K7ahvI008946
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 03:36:43 -0400
Received: from cicero2.cybercity.dk (cicero2.cybercity.dk [212.242.40.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9K7aV0X013725
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 03:36:31 -0400
Received: from jakob.b4net.dk (port157.ds1-taa.adsl.cybercity.dk
	[212.242.111.226])
	by cicero2.cybercity.dk (Postfix) with ESMTP id 551A919E07F
	for <video4linux-list@redhat.com>;
	Mon, 20 Oct 2008 09:36:30 +0200 (CEST)
Received: from [10.0.0.2] (ugle [10.0.0.2])
	by jakob.b4net.dk (Postfix) with ESMTP id 100A61318043
	for <video4linux-list@redhat.com>;
	Mon, 20 Oct 2008 09:36:26 +0200 (CEST)
Message-ID: <48FC34FA.20003@b4net.dk>
Date: Mon, 20 Oct 2008 09:36:26 +0200
From: Per Baekgaard <baekgaard@b4net.dk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48F90ED4.8030907@b4net.dk>	<alpine.DEB.1.10.0810181408370.18626@vegas>
	<48FA41C1.3030501@b4net.dk> <1224481594.4265.8.camel@skoll>
In-Reply-To: <1224481594.4265.8.camel@skoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Hauppauge PVR-150 MCE vs HVR-1300
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

Jonatan Åkerlind wrote:
> On lör, 2008-10-18 at 22:06 +0200, Per Baekgaard wrote:
>   
>> Is the HVR-1300 MPEG encoder HW support in place now? Do a lot/at least
>> some have it working well in their setup, using either Analog or DVB-T?
>>     
>
> Well, the HW encoder is sort of working. The problem is that I cannot
> change channel (tuning) when reading the mpeg stream. I also have a
> problem with the audio being interupted about every 5 seconds with a
> loud static noice and then resuming to normal. 
> ...
>   

Hm... sounds to me that a PVR-150 would be a less-hassle project then,
and I guess I can always add another grabber when/if I would need it.

Thanks for sharing your experience (or rather: "tack så mycket/mange
tak" ;-)


-- Per.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
