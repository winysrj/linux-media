Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4J1xJUW018753
	for <video4linux-list@redhat.com>; Sun, 18 May 2008 21:59:19 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4J1x9kR004193
	for <video4linux-list@redhat.com>; Sun, 18 May 2008 21:59:10 -0400
Received: by ti-out-0910.google.com with SMTP id 24so763864tim.7
	for <video4linux-list@redhat.com>; Sun, 18 May 2008 18:59:09 -0700 (PDT)
Message-ID: <998e4a820805181859l505c95daw81ca89fd8142d2e3@mail.gmail.com>
Date: Mon, 19 May 2008 09:59:08 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0805161245230.3714@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
	<998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
	<Pine.LNX.4.64.0804221618510.8132@axis700.grange>
	<998e4a820805150152p51f8f9fek5462aee7a6d3ba06@mail.gmail.com>
	<Pine.LNX.4.64.0805151105290.14292@axis700.grange>
	<998e4a820805150523v4af2a62am8f9b169bd4c368d@mail.gmail.com>
	<Pine.LNX.4.64.0805151432110.14292@axis700.grange>
	<998e4a820805160332x727bf6adkcedac4934dea2414@mail.gmail.com>
	<Pine.LNX.4.64.0805161245230.3714@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

2008/5/16 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > 2008/5/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > What is your <struct pxacamera_platform_data>.mclk_10khz set to? What
>> > kernel version are you using? I do not know what you do in your FPGA, are
>> > you sure it doesn't modify your camera bus timing (pixel clock, VSYNC,
>> > HSYNC, master clock)?
>>
>> mclk_10khz=1000,and I try 800,500. And the number of dropped frames do
>> not decrease with lower frequencies. kernel I used is linux-2.6.24.
>> And I sure FPGA doesn't modify my camera bus timing.
>
> Strange, that dropped frames do not decrease. But you do see, that frames
> are generated at a lower rate? You can also try 2000 for comparison.

I try 2000,But have no evident changes.

>> > I assume, you write to the filesystem from another thread, right? And the
>> > writer thread just blocks on write(). What does your grabber thread do at
>> > this time? Can it continue processing video buffers and queuing new ones
>> > or it waits for the writer thread?
>>
>> yes, I use another thread to write a file.when I write a file to
>> Norflash,overrun will occur until writting is over.My grabber thread
>> waits for the writer thread at this time.
>
> This is certainly wrong. Your grabber thread must continue collecting
> completed and supplying new video buffers to the driver.

I feel strange.Why does grabber thread wait for the writer thread.But
if I write to Nandflash,grabber thread continues.In these case overrun
will occur.
Last two days I try montavista driver for linux-2.6.20.When I write a
file to JFFS2 Norflash or delete a file from Norflash,overrun will
occur,but grabber thread continues.When I write a file to YAFFS
Nandflash,overrun will not occur.It's so strange,why?

> If your writer thread is not fast enough, you should drop frames
> between your two threads.

Do you mean writer thread is so slow that FIFO overrun occur.So frames
are dropped.Why?

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
