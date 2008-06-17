Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HFFWaF019850
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 11:15:32 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5HFFLJv025849
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 11:15:22 -0400
Received: by fg-out-1718.google.com with SMTP id e21so4124405fga.7
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 08:15:21 -0700 (PDT)
Message-ID: <a5eaedfa0806170815m2911f480lbed9b4fc18622b09@mail.gmail.com>
Date: Tue, 17 Jun 2008 20:45:21 +0530
From: "Veda N" <veda74@gmail.com>
To: "Veda N" <veda74@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080617104614.GA781@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
	<20080617094510.GA726@daniel.bse>
	<a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
	<20080617104614.GA781@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: v4l2_pix_format doubts
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

Hi Daniel,

Thanks for your quick response.

 1) I am having a pixel format (UYVY)
 2) RGB565

Thank you.

Regards,
sriram

On Tue, Jun 17, 2008 at 4:16 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Jun 17, 2008 at 03:52:25PM +0530, Veda N wrote:
>> I think you got confused by RGB and YUV.
>
> I don't think so
>
>> The device is capable of giving RGB and YUV data. This is done by a
>> setting in the sensor register.
>
> That's what I wanted to know
>
>> Now, i know what i should set the pix->pixelformat, but what about
>> other members of the
>> v4l2_pix_format structure.
>
> for 640x480
> width = 640
> height = 480
>
> If you tell me pix->pixelformat, I can tell you the minimum bytesperline.
> It may be larger if your hardware requires padding of lines.
>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
