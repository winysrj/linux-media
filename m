Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3HIXDhC013240
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 14:33:14 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3HIWv4K006965
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 14:32:58 -0400
Received: by yw-out-2324.google.com with SMTP id 3so613609ywj.81
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 11:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <edc06e0a0904171128x3296dee0wcd7a23fde352930d@mail.gmail.com>
References: <edc06e0a0904171128x3296dee0wcd7a23fde352930d@mail.gmail.com>
Date: Fri, 17 Apr 2009 14:32:57 -0400
Message-ID: <412bdbff0904171132hb17758dr9a4b30e68e77fe45@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Justin Smith <justinsmith2009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: au0828/au8522 v4l
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

On Fri, Apr 17, 2009 at 2:28 PM, Justin Smith <justinsmith2009@gmail.com> wrote:
> Hi,
>
> I have a Hauppauge card which uses the au0828 and au8522 kernel
> modules. Whenever I load them, it also loads videodev, v4l1_compat,
> etc.
>
> However it appears that the original videodev kernel module is
> replaced by the videodev module that comes with v4l-dvb.
>
> I have another v4l driver in my system which cannot be loaded because
> of this. The error message that I get is, "disagrees about version of
> symbol video_devdata"
>
> Can anyone tell me what might be causing this. I tried make
> kernel-links but that does not seem to help
>
> Thanks,
> Justin

Have you tried rebooting since you did the "make install" of v4l-dvb?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
