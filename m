Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GAdEuj009226
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 06:39:15 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GAWJLA024496
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 06:39:04 -0400
Received: by ti-out-0910.google.com with SMTP id 24so425020tim.7
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 03:32:19 -0700 (PDT)
Message-ID: <998e4a820805160332x727bf6adkcedac4934dea2414@mail.gmail.com>
Date: Fri, 16 May 2008 18:32:18 +0800
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
> 2008/5/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> What is your <struct pxacamera_platform_data>.mclk_10khz set to? What
> kernel version are you using? I do not know what you do in your FPGA, are
> you sure it doesn't modify your camera bus timing (pixel clock, VSYNC,
> HSYNC, master clock)?

mclk_10khz=1000,and I try 800,500. And the number of dropped frames do
not decrease with lower frequencies. kernel I used is linux-2.6.24.
And I sure FPGA doesn't modify my camera bus timing.

> Do you mean camera FIFO overruns occur, but fraims do not get dropped? The
> reason, why with NOR you have more problems might be, that you produce
> extra load on the memory bus? I don't remember id you already told us,
> What's your frame format? 640x480x8bit?

If camera FIFO overruns occur,frames will be dropped.Now my frame
format is 752x480x8bit.

> what type of LCD you have on your system and what other bus masters you
> have?

I only use a thread to capure frame and do not display it.I have no
other bus master.the following is my capture thread:
static int dhpa_capture_thread(void)
{
      struct v4l2_buffer buf;
      int frame_cnt;
      static time_t init, end;

      while(1)
      {
              /*read frame*/
              memset(&buf, 0, sizeof(buf));
              buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
              buf.memory = V4L2_MEMORY_MMAP;

              /*get the captured buffer*/
              if(-1 == ioctl(fd, VIDIOC_DQBUF, &buf))
              {
                      printf( "VIDIOC_DQBUF failed\n ");
                      return -1;
              }

              if(-1 == ioctl(fd, VIDIOC_QBUF, &buf))
              {
                      printf("VIDIOC_QBUF failed\n");
                      return -1;
              }
      }
}

> More importantly, what do you do while waiting for jffs2 write to finish?

I do nothing while waiting for jffs2 write to finish.but I do not stop
grabber thread.

> I assume, you write to the filesystem from another thread, right? And the
> writer thread just blocks on write(). What does your grabber thread do at
> this time? Can it continue processing video buffers and queuing new ones
> or it waits for the writer thread?

yes, I use another thread to write a file.when I write a file to
Norflash,overrun will occur until writting is over.My grabber thread
waits for the writer thread at this time.

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
