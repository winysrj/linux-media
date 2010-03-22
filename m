Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2MIa60o006413
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 14:36:06 -0400
Received: from mail-gy0-f174.google.com (mail-gy0-f174.google.com
	[209.85.160.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2MIZuAA012774
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 14:35:56 -0400
Received: by gyg8 with SMTP id 8so3342741gyg.33
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 11:35:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA7A993.2080008@pillar.it>
References: <4BA75D27.10807@pillar.it>
	<9c4b1d601003220735i5af4be8bo8dc64138bb359f9b@mail.gmail.com>
	<4BA7A993.2080008@pillar.it>
Date: Mon, 22 Mar 2010 15:35:55 -0300
Message-ID: <9c4b1d601003221135x461bae9w756b7c49c542b93d@mail.gmail.com>
Subject: Re: Set Frequency Problem
From: Adrian Pardini <pardo.bsso@gmail.com>
To: Sanfelici Claudio <sanfelici@pillar.it>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 22/03/2010, Sanfelici Claudio <sanfelici@pillar.it> wrote:
> Yes, I set the input during initialization time. The set frequency sometimes
> works correctly and I can see the images. Normally, the first set works and
> I can see the images; than i call the set frequency and (sometimes) the
> signal goes 0. In this moment to continue with other tests, I've put the set
> frequency ioctl in a do/while loop that continue to call the set frequency
> untill the signal goes >0
>
> Of course, with other programs the card works
>
> Thank you !


Well, thats a good sign. Could you share with us the relevant C code
and more info about the card?





> Adrian Pardini ha scritto:
>>
>> On 22/03/2010, Sanfelici Claudio <sanfelici@pillar.it> wrote:
>> [...]
>>
>>>
>>> When I call the VIDIOC_S_FREQUENCY the driver change the frequency, but
>>> the video signal is 0 (according to the VIDIOC_G_TUNER) and the image is
>>> black. I've to call some times the VIDIOC_S_FREQUENCY to get the signal
>>> on
>>>
>>>
>>
>> Hi, is the right input selected? Does the card work with other
>> programs, like xawtv?
>>
>> cheers
>>
>>


-- 
Adrian.
http://elesquinazotango.com.ar
http://www.noalcodigodescioli.blogspot.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
