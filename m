Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0CLJMZK025957
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 16:19:22 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0CLJFHx025734
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 16:19:16 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3993227fga.7
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 13:19:15 -0800 (PST)
Message-ID: <a21d779b0901121319t15cb30d6g7d2db78ebff9ee34@mail.gmail.com>
Date: Mon, 12 Jan 2009 23:19:14 +0200
From: "=?ISO-8859-2?Q?Andr=E1s_L=F5rincz?=" <andras.lorincz@gmail.com>
To: "matthieu castet" <castet.matthieu@free.fr>
In-Reply-To: <496B90FD.7000005@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <a21d779b0901120550j35dfbdc2l402be4664d89e4da@mail.gmail.com>
	<496B90FD.7000005@free.fr>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, DVB list <linux-dvb@linuxtv.org>
Subject: Re: Hauppauge HVR 900H with ID 2040:6600
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

On Mon, Jan 12, 2009 at 8:50 PM, matthieu castet
<castet.matthieu@free.fr> wrote:
> András Lõrincz wrote:
>>
>> Hello,
>>
>> I've just bought the device mentioned in the title with the hope that
>> it will work under linux but just found out that actually there are
>> different variations of it :(. As I saw it on linuxtv.org it is not
>> supported. Is there any hope that this device will ever work under
>> linux? Thanks.
>
> There was some work done on http://linuxtv.org/hg/~mchehab/tm6010/ , but the
> code is far from being complete.
>
> I also tried to trace what the windows driver is doing (the zl10353 fe
> attach fails for me), but I didn't manage to make work usbsnoop [1]...
>
>
> Matthieu
>
>
> [1] it works fine with mass storage, but not with the HVR...
>

Well, I can wait for the driver and I'm ready to help also by testing
or getting information, even from windows... hope it will work some
day because I tested it on windows and it works fine and I wouldn't
give it away if there is some hope for it to work on linux as well :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
