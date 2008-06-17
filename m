Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H9dZbK027118
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:39:35 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5H9d5oA015969
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:39:06 -0400
Received: by fg-out-1718.google.com with SMTP id e21so4039120fga.7
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 02:39:05 -0700 (PDT)
Message-ID: <a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
Date: Tue, 17 Jun 2008 15:09:04 +0530
From: "Veda N" <veda74@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080617092439.GA631@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
Content-Transfer-Encoding: 8bit
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

  Thank you for your quick response.


On Tue, Jun 17, 2008 at 2:54 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Tue, Jun 17, 2008 at 02:35:04PM +0530, Veda N wrote:
>>  My datasheet says the size of each pixel is 12 bits per color channel.
>>
>>  Hence for RGB will be 36bits.
>>
>>  I wanted to know if the same hold true for YUV data.
>
> Can you tell us for which hardware you want to write a driver?
>
> The values to fill in depend on the final layout of the data in memory.
> As you should not convert to YUV in software, it depends solely on the
> hardware.


  As i understand, my camera has a image processor inside it. what i
want to say is it is
  not a plain raw sensor.

  For every pixel clock a pixel is fetched from the device and is
placed in memory
  Once a entire frame is captured. it is returned to the application.
>From the application
   i can write this data into LCD or a file to be viewed by a YUV/RGB
viewer like YUVTOOLS.

  This is same for both RGB and YUV data.


  my only concern is i should fill proper values to v4l2_pix_format structure.

  Thank you.

Regards,
vedan

>
>  Daniel
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
