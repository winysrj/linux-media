Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G36Hdw029263
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 23:06:17 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4G361fH003781
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 23:06:01 -0400
Received: by ti-out-0910.google.com with SMTP id 24so360161tim.7
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 20:06:00 -0700 (PDT)
Message-ID: <998e4a820805152006j65975708n71a4b2bb566e81da@mail.gmail.com>
Date: Fri, 16 May 2008 11:06:00 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0805151432110.14292@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
	<998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
	<Pine.LNX.4.64.0804221618510.8132@axis700.grange>
	<998e4a820805150152p51f8f9fek5462aee7a6d3ba06@mail.gmail.com>
	<Pine.LNX.4.64.0805151105290.14292@axis700.grange>
	<998e4a820805150523v4af2a62am8f9b169bd4c368d@mail.gmail.com>
	<Pine.LNX.4.64.0805151432110.14292@axis700.grange>
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

2008/5/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > Do you mean camera FIFO overruns occur, but fraims do not get dropped? The
>> > reason, why with NOR you have more problems might be, that you produce
>> > extra load on the memory bus? I don't remember id you already told us,
>> > what type of LCD you have on your system and what other bus masters you
>> > have? What's your frame format? 640x480x8bit?
>>
>> My frame format is 752x480x8bit.Now I only capure frame.And I do not
>> display. the following is my capture thread:
>> static int dhpa_capture_thread(void)
>> {
>>       struct v4l2_buffer buf;
>>       int frame_cnt;
>>       static time_t init, end;
>>
>>       while(1)
>>       {
>>               /*read frame*/
>>               memset(&buf, 0, sizeof(buf));
>>               buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>               buf.memory = V4L2_MEMORY_MMAP;
>>
>>               /*get the captured buffer*/
>>               if(-1 == ioctl(fd, VIDIOC_DQBUF, &buf))
>>               {
>>                       printf( "VIDIOC_DQBUF failed\n ");
>>                       return -1;
>>               }
>>
>>               if(-1 == ioctl(fd, VIDIOC_QBUF, &buf))
>>               {
>>                       printf("VIDIOC_QBUF failed\n");
>>                       return -1;
>>               }
>>       }
>> }
>> Now if I write a file to jffs2 norflash,FIFO overrun will
>> occur.Certainly frame is dropped.I only hope you give me some
>> advice.why do overrun occur when writting norflash.Because I feel
>> capture frame only use DMA now,I think that write norflash will not
>> affect DMA.

> DMA uses the same memory bus as NOR flash. Also, if the NOR driver blocks
> interrupts, it will delay processing of DMA interrupts, but that is
> unlikely to cause you problems, provided you use enough (4 should be good)
> video buffers.

Do you mean DMA use the same memory bus as Nor flash,so when I write a
file to Norflash,overrun will occur?Now I find that I write a file to
yaffs Nandflash or /tmp/,overrun will occur too.do Nandflash use the
same memory bus as DMA? Now I use 4 viedo buffers.

> More importantly, what do you do while waiting for jffs2 write to finish?
> I assume, you write to the filesystem from another thread, right? And the
> writer thread just blocks on write(). What does your grabber thread do at
> this time? Can it continue processing video buffers and queuing new ones
> or it waits for the writer thread?

Yes,I write a file from another thread.And my graber thread contiune
processing video buffers and queuning new ones.

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
