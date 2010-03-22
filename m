Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2MIU8Td004706
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 14:30:08 -0400
Received: from mail-yx0-f188.google.com (mail-yx0-f188.google.com
	[209.85.210.188])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2MITvDh026079
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 14:29:58 -0400
Received: by yxe26 with SMTP id 26so1866124yxe.23
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 11:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA7A993.2080008@pillar.it>
References: <4BA75D27.10807@pillar.it>
	<9c4b1d601003220735i5af4be8bo8dc64138bb359f9b@mail.gmail.com>
	<4BA7A993.2080008@pillar.it>
Date: Mon, 22 Mar 2010 15:29:56 -0300
Message-ID: <9c4b1d601003221129g123a3895h6acc8bda00f6de11@mail.gmail.com>
Subject: Re: Set Frequency Problem
From: Adrian Pardini <pardo.bsso@gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
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

(I forgot to cc' the list)

---------- Forwarded message ----------
From: Sanfelici Claudio <sanfelici@pillar.it>
Date: Mon, 22 Mar 2010 18:32:03 +0100
Subject: Re: Set Frequency Problem
To: Adrian Pardini <pardo.bsso@gmail.com>

Yes, I set the input during initialization time. The set frequency
sometimes works correctly and I can see the images. Normally, the
first set works and I can see the images; than i call the set
frequency and (sometimes) the signal goes 0. In this moment to
continue with other tests, I've put the set frequency ioctl in a
do/while loop that continue to call the set frequency untill the
signal goes >0

Of course, with other programs the card works

Thank you !

Pillar Engineering
di Sanfelici Claudio
Via Monza, 53
20063 Cernusco sul Naviglio - MI
P.Iva 05403820961
C.F. SNFCDP81D28C523E
Tel. 02.99.76.55.69
Fax. 02.99.76.55.70
Cell. +39 333.14.27.805
E-Mail info@pillar.it
Sito: www.pillar.it



Adrian Pardini ha scritto:
>
> On 22/03/2010, Sanfelici Claudio <sanfelici@pillar.it> wrote:
> [...]
>
>>
>> When I call the VIDIOC_S_FREQUENCY the driver change the frequency, but
>> the video signal is 0 (according to the VIDIOC_G_TUNER) and the image is
>> black. I've to call some times the VIDIOC_S_FREQUENCY to get the signal on
>>
>>
>
> Hi, is the right input selected? Does the card work with other
> programs, like xawtv?
>
> cheers
>
>


-- 
Adrian.
http://elesquinazotango.com.ar
http://www.noalcodigodescioli.blogspot.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
