Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA391UjV014832
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 04:01:30 -0500
Received: from eu1sys200aog106.obsmtp.com (eu1sys200aog106.obsmtp.com
	[207.126.144.121])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA391DEd030479
	for <video4linux-list@redhat.com>; Tue, 3 Nov 2009 04:01:15 -0500
Message-ID: <4AEFF179.4010900@st.com>
Date: Tue, 03 Nov 2009 10:01:45 +0100
From: Raffaele BELARDI <raffaele.belardi@st.com>
MIME-Version: 1.0
To: Nick Morrott <knowledgejunkie@gmail.com>
References: <4AEE9AAA.80104@st.com>
	<5387cd30911021223u2c1349b8gd7baca736f8fbae6@mail.gmail.com>
In-Reply-To: <5387cd30911021223u2c1349b8gd7baca736f8fbae6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: hvr1300 DVB regression
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

Nick Morrott wrote:
> 2009/11/2 Raffaele BELARDI <raffaele.belardi@st.com>:
>> I'm no longer able with recent kernels to tune DVB channels with my
>> HVR1300. This is a mythtv box but I replicated the problem using
>> www.linuxtv.org utilities to exclude mythtv issues.
>>
>> Using kernel 2.6.26-r4 and 2.6.27-r8 I am able to tune both analog and
>> DVB channels.
>> Using kernel 2.6.30-r6 I can only tune to analog channels. 'dvbscan'
>> returns no channel info.
>>
>> I suspect a tuner problem.
> 
> Have you read https://bugs.launchpad.net/mythtv/+bug/439163 and
> comments (esp. https://bugs.launchpad.net/mythtv/+bug/439163/comments/50)?
> 

No, I had not seen those. Looks like a bad patch
(https://bugs.launchpad.net/mythtv/+bug/439163/comments/36). I'll give
it a try.

thanks,

raffaele

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
