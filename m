Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2IEQEpr005543
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 10:26:14 -0400
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2IEQ31s009092
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 10:26:03 -0400
Received: by bwz9 with SMTP id 9so210120bwz.11
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 07:26:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1268917774.3616.61.camel@chimpin>
References: <4B9FA07B.3000206@bysky.nl>
	<829197381003160834k7e82cd6am5cf8153e3e5625b2@mail.gmail.com>
	<4BA2197E.4000305@saturnus.nl> <4BA21C12.6090609@bysky.nl>
	<1268917774.3616.61.camel@chimpin>
Date: Thu, 18 Mar 2010 10:26:02 -0400
Message-ID: <829197381003180726l5a24bfdes5db9ced083453d0c@mail.gmail.com>
Subject: Re: Any update on em28xx on igevp2 ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John Banks <john.banks@noonanmedia.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Mar 18, 2010 at 9:09 AM, John Banks <john.banks@noonanmedia.com> wr=
ote:
> On Thu, 2010-03-18 at 13:26 +0100, Gert-Jan de Jonge wrote:
>> Hi Devin,
>>
>> just some extra info:
>>
>> I have tested the difference on the arm board compared to the pc:
>> =A0 int =A0height=3D576;
>> =A0 height >>=3D 576;
>> =A0 printf("%d\n", height);
>>
>> on arm it gives a 0, on the pc it gives 576.
>> on both i get a warning from the compiler, as in my test code the 576 is
>> hardcoded in stead of a variable
>> warning: right shift count >=3D width of type ( which is logical ;) )

Well, rotating an 8-bit unsigned integer 576 places to the right would
definitely not be a good thing.  :-)

Devin

-- =

Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
