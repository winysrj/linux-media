Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42ITZLZ005010
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 14:29:35 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42ITMxq009741
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 14:29:22 -0400
Received: by rv-out-0506.google.com with SMTP id f6so156955rvb.51
	for <video4linux-list@redhat.com>; Fri, 02 May 2008 11:29:22 -0700 (PDT)
Message-ID: <d9def9db0805021129k67530f0amdc46256d3e8424d1@mail.gmail.com>
Date: Fri, 2 May 2008 20:29:22 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Diogo Salazar" <diogosalazar@globo.com>, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: New device support go7007 [was in em28xx]
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

Hi,

On 5/2/08, Diogo Salazar <diogosalazar@globo.com> wrote:
> Hi, sorry to mail you directly. I think I already sent you an email (1 year
> ago) about a video capture device...
> This time I have a Pinnacle DVC 170. I know that em28xx supports the DVC
> 90 / 100, but it doesnt support the DVC 170.
> I'd like to get it supported so...if you can guide me to make this
> supported,
> I'd be very happy to open my device to look for the components, to try and
> do usb sniffing...
> Actually, I already opened it and identified a GO7007SB, an ADV7180 and a
> CY7C68013A...
>

this is a different device, there's a vendor specific driver available
for it I think.
You might have a look at:
http://gentoo-wiki.com/HARDWARE_go7007

I'l get my go7007 device next week so I can have a look at it again.

> Please help me to get it working...
>

i'm not sure if it's supported.. that go7007 driver might need some
changes in order to support your device.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
