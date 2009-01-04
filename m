Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n046jVmR008644
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 01:45:31 -0500
Received: from smtp106.rog.mail.re2.yahoo.com (smtp106.rog.mail.re2.yahoo.com
	[68.142.225.204])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n046jFAX022375
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 01:45:15 -0500
Message-ID: <49605AFA.3000208@rogers.com>
Date: Sun, 04 Jan 2009 01:45:14 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
	<412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
In-Reply-To: <412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: KWorld 330U Employs Samsung S5H1409X01 Demodulator
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
> On Sat, Jan 3, 2009 at 11:21 PM, Robert Krakora
> <rob.krakora@messagenetsystems.com> wrote:
>   
>> Mauro:
>>
>> The KWorld 330U employs the Samsung S5H1409X01 demodulator, not the
>> LGDT330X.  Hence the error initializing the LGDT330X in the current source
>> in em28xx-dvb.c.
>>
>> Best Regards,
>>     
>
> Hello Robert,
>
> Well, that's good to know.  I don't think anyone has done any work on
> that device recently, so I don't know why the code has it as an
> lgdt3303.

I believe Douglas submitted this patch
(http://linuxtv.org/hg/v4l-dvb/rev/77f789d59de8) that got committed. 

I've been meaning to get back to this because the "A316" part of the
name caught my attention -- I do not recall having seen such a reference
made by KWorld, nor is it typical of their nomenclature style, rather,
it is entirely consistent with that used by AVerMedia



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
