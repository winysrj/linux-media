Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GAaOsi009904
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 06:36:24 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GAaDUx022275
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 06:36:14 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3130625wfc.6
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 03:36:13 -0700 (PDT)
Message-ID: <aec7e5c30810160336w4e040ce3hf586d58b0cd05a6a@mail.gmail.com>
Date: Thu, 16 Oct 2008 19:36:13 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: morimoto.kuninori@renesas.com
In-Reply-To: <u1vygamsl.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
	<20081016102701.1bcb2c59.ospite@studenti.unina.it>
	<u1vygamsl.wl%morimoto.kuninori@renesas.com>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
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

On Thu, Oct 16, 2008 at 6:53 PM,  <morimoto.kuninori@renesas.com> wrote:
>
> Hi Antonio Ospite
>
> # I'm sorry that I have only poor Enlish.
>
>> The question is: is there any mechanism to share sensor code between
>> usb and i2c drivers or we have to copy and paste?
>
> I think it can be possible to reuse.
> It's just a matter of glue code.

Right. If the usb driver would be a soc_camera host driver then it
could make use of the soc_camera camera/sensor drivers right out of
the box. I'm not sure if the soc_camera framework is the best option
for you though, but for us using the sh_mobile_ceu driver it's a good
choice. =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
