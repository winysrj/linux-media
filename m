Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7PIp6D6029602
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 14:51:07 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7PIotpH007675
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 14:50:55 -0400
Received: by py-out-1112.google.com with SMTP id a29so1151955pyi.0
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 11:50:55 -0700 (PDT)
Message-ID: <d9def9db0808251150g2db42d2q224db787d03306b9@mail.gmail.com>
Date: Mon, 25 Aug 2008 20:50:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Stefan Lange" <sailer22@web.de>
In-Reply-To: <48B2F7E0.8010006@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <751285356@web.de>
	<d9def9db0808130339t588c6bf9y3f68bf1005212d6b@mail.gmail.com>
	<2f11466b0808250651n58f192b9o8859732b684292ed@mail.gmail.com>
	<48B2F7E0.8010006@web.de>
Cc: video4linux-list@redhat.com,
	Marco Crociani - Tyrael <marco.crociani@gmail.com>, em28xx@mcentral.de
Subject: Re: [Em28xx] Terratec Cinergy XS unsupported Device
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

On Mon, Aug 25, 2008 at 8:20 PM, Stefan Lange <sailer22@web.de> wrote:
> Hi Marco,
>
> i cant move the changes from v4l to the em28xx-new. I am just a newbie and
> an End User.
>
> So i am just waiting if some would implement the Cinergy XS in the
> em28xx-new.
>
> Sorry.
>

we can check this week, the current priority is to get rid of the alsa
driver since too many different problems came up with alsa now...

Markus

> Stefan
>
> Marco Crociani - Tyrael wrote:
>>
>> On Wed, Aug 13, 2008 at 12:39 PM, Markus Rechberger <mrechberger@gmail.com
>> <mailto:mrechberger@gmail.com>> wrote:
>>
>>    On Wed, Aug 13, 2008 at 12:36 PM, Stefan Lange <sailer22@web.de
>>    <mailto:sailer22@web.de>> wrote:
>>    > So i have to wait for your next release right ? Or can i do it
>>    by myself ?
>>    >
>>
>>    yes you have to wait a bit for it... you can try to move the changes
>>    from v4l-dvb-experimental to em28xx-new on mcentral.de
>>    <http://mcentral.de>, there are
>>    still a few things missing in the latest repository; although I'm
>>    trying to take care that no other drivers will break with any updates.
>>
>>    Markus
>>
>>  Hi Stefan,
>> have you tried to move the changes from v4l-dvb-experimental to
>> em28xx-new?
>>
>> --
>> Marco Lorenzo Crociani,
>> marco.crociani@gmail.com <mailto:marco.crociani@gmail.com>
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
