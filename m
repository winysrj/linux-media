Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2OCWQjG010440
	for <video4linux-list@redhat.com>; Mon, 24 Mar 2008 08:32:26 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2OCVoFa003329
	for <video4linux-list@redhat.com>; Mon, 24 Mar 2008 08:31:51 -0400
Received: by ug-out-1314.google.com with SMTP id t39so1909372ugd.6
	for <video4linux-list@redhat.com>; Mon, 24 Mar 2008 05:31:50 -0700 (PDT)
Message-ID: <226dee610803240531g2c27e1s7a475309c9709e48@mail.gmail.com>
Date: Mon, 24 Mar 2008 18:01:49 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: Ram <vshrirama@gmail.com>
In-Reply-To: <8bf247760803240521mfde8dd0l9ee16106c88f2283@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bf247760803240521mfde8dd0l9ee16106c88f2283@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: firmware update camera doubts
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

On Mon, Mar 24, 2008 at 5:51 PM, Ram <vshrirama@gmail.com> wrote:
> Hi,
>    Im writing a camera sensor driver for omap - which needs to update
>  a firmware to the camera.
>   The firmware size is around 50K bytes.
>
>    Which is the best place to update firmware in the sensor driver in
>  the latest V4L2 for linux-2.6.23?
>
>    Should it be done in XXX_configure function or after power_on ( );
>
>   Some drivers do common initializations in the XXX_configure function.
>   But am not really sure if XXX_configure is the right place since updating
>   firmware takes time (approx 5/10 seconds)
>
>
>   Please advice,
>
>
>  Regards,
>  sriram

after its initialized, update the firmware & reset the camera/device

-JoJo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
