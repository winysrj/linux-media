Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8QKIKK4008402
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 16:18:21 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8QKI5Cw017692
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 16:18:06 -0400
Received: by fg-out-1718.google.com with SMTP id e21so786045fga.7
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 13:18:05 -0700 (PDT)
Message-ID: <d9def9db0809261318x49812ce2g38b6b8b74448afd3@mail.gmail.com>
Date: Fri, 26 Sep 2008 22:18:04 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "BABAK SEYEDI" <bab.sdn@gmail.com>, video4linux-list@redhat.com,
	em28xx@mcentral.de
In-Reply-To: <d9def9db0809261311g303979adkf2c44ce44c932e3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b6d682a0809251804j1277af44i80c53529a3c33d62@mail.gmail.com>
	<d9def9db0809251944g56462217sdc14a57c85db1b97@mail.gmail.com>
	<d9def9db0809260443w53d575b7s3857b424163ec1b@mail.gmail.com>
	<beb91d720809260508vc1e28d0m33daaa289c8cfe0b@mail.gmail.com>
	<d9def9db0809260517p3ddef5bby47eb52d6bb1fa948@mail.gmail.com>
	<d9def9db0809260537j2ff6fc98mc133ca37a06c1bc4@mail.gmail.com>
	<7b6d682a0809261234i71ea0fd5i6709fbc843f40768@mail.gmail.com>
	<d9def9db0809261239i45c7a9fbu8395a64b0c58bc73@mail.gmail.com>
	<2ee0f7430809261252v267626b4rc6269a6132cf88c0@mail.gmail.com>
	<d9def9db0809261311g303979adkf2c44ce44c932e3d@mail.gmail.com>
Cc: 
Subject: Re: Pinnacle PCTV HD Pro Stick
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

On Fri, Sep 26, 2008 at 10:11 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Fri, Sep 26, 2008 at 9:52 PM, BABAK SEYEDI <bab.sdn@gmail.com> wrote:
>> On 9/26/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>>> On Fri, Sep 26, 2008 at 9:34 PM, Eduardo Fontes
>>> <eduardo.fontes@gmail.com> wrote:
>>>> Dear Markus,
>>>>
>>>> This new em28xx driver works li
>>>
>>> great! good to know that PAL-M now works properly too.
>>
>>
>>
>> Excuseme are these drivers capabable with tt-budget -s2-3200 in
>> ubuntu?  And if i only install these that's enough?
>
> as long as you stick with the default ubuntu modules yes, this debian
> package just adds
> support for the em28xx modules while not upgrading any infrastructure
> so it has no influence
> on anything else.
>

one more thing, you can rather easy add those modules to Manu's multiproto tree
or to the v4l-dvb tree on linuxtv.org to extend the available drivers.
I'll try to publish a howto for that next week.

Markus

> Markus
>
>>>
>>> -Markus
>>>
>>>> Thanks a lot.
>>>>
>>>> Eduardo M. Fontes
>>>>
>>>> On Fri, Sep 26, 2008 at 9:37 AM, Markus Rechberger <mrechberger@gmail.com>
>>>> wrote:
>>>>>
>>>>> >>> Ok here's the updated i386 package:
>>>>> >>> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-8_i386.deb
>>>>> >>>
>>>>> >>> Markus
>>>>> >>>
>>>>> >>> --
>>>>> >>> video4linux-list mailing list
>>>>> >>> Unsubscribe
>>>>> >>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>>>> >>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>>>
>>>>> Just for the completion:
>>>>>
>>>>> amd64:
>>>>> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-9_amd64.deb
>>>>> i386:
>>>>> http://mcentral.de/empia/20080926/empia-2.6.24-19-generic-8_i386.deb
>>>>>
>>>>> the generic amd64 empia driver is also updated now (i386/amd64 have
>>>>> their own versioning so 8/9
>>>>> has no relation with each other).
>>>>>
>>>>> Markus
>>>>
>>>>
>>>>
>>>> --
>>>> Eduardo Mota Fontes
>>>> Analista de Suporte
>>>>
>>>
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>
>>
>> --
>> babakLINUX
>>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
