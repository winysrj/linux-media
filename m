Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HAMn6Q018470
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 06:22:49 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5HAMQbh008765
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 06:22:26 -0400
Received: by fg-out-1718.google.com with SMTP id e21so4047319fga.7
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 03:22:25 -0700 (PDT)
Message-ID: <a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
Date: Tue, 17 Jun 2008 15:52:25 +0530
From: "Veda N" <veda74@gmail.com>
To: "Veda N" <veda74@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080617094510.GA726@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
	<20080617094510.GA726@daniel.bse>
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

I think you got confused by RGB and YUV.

The device is capable of giving RGB and YUV data. This is done by a
setting in the sensor register.

Once i set the value, For every pixel clock a pixel is fetched from
the device and is
placed in memory  Once a entire frame is captured. it is returned to
the application.
>From the application   i can write this data into LCD or a file to be
viewed by a YUV/RGB
viewer like YUVTOOLS.


Now, i know what i should set the pix->pixelformat, but what about
other members of the
v4l2_pix_format structure.



Regards,
vedan

On Tue, Jun 17, 2008 at 3:15 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Jun 17, 2008 at 03:09:04PM +0530, Veda N wrote:
>>   As i understand, my camera has a image processor inside it. what i
>> want to say is it is
>>   not a plain raw sensor.
>
> So this image processor converts RGB to YUV?
>
>>   For every pixel clock a pixel is fetched from the device and is
>> placed in memory
>>   Once a entire frame is captured. it is returned to the application.
>
> And if you look at this data in memory, what does it look like?
>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
