Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TDZgP5024744
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 08:35:42 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1TDZAcN006589
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 08:35:10 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JV5OB-0005pL-9c
	for video4linux-list@redhat.com; Fri, 29 Feb 2008 13:35:03 +0000
Received: from 212.47.100.92 ([212.47.100.92])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 13:35:03 +0000
Received: from paulius.zaleckas by 212.47.100.92 with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 13:35:03 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Fri, 29 Feb 2008 14:49:22 +0200
Message-ID: <fq8v17$bm9$1@ger.gmane.org>
References: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
Subject: Re: [RFC] move sensor control out of kernel
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

Take a look at my comments bellow. These are just my thoughts. Maybe I 
am not right...

Best regards,
Paulius Zaleckas

eric miao wrote:
> I know some one has different opinion, but since the sensor control logic is
> getting more and more complicated, and provided that differences between
> sensors and vendors are already too many. Is it better to move sensor
> control out of kernel.

I agree that sensor control drivers are very different and most of them 
work only with specific data bus driver. That is really big problem.
"soc-camera" framework developed by Guennadi Liakhovetski IMO is the 
right solution.

> Most sensors come with a serial control channel, I2C as can be seen
> most commonly. Access to the control information can be done by
> i2c-dev interface if possible, thus the driver can be freed as an I2C
> stub only. So technically, this is practical.

Keep in mind that i2c is used not only for camera sensor control, but 
for other devices also.

> The benefits I can think of now are:
> 
> 1. simplified sensor driver design

It is pretty simple with soc-camera framework also. And the best thing 
is that it is unified. If you implement sensor driver in userspace then 
what kind of interface should V4L data bus driver expose.

> 2. sensor control related debugging can be moved to user space thus
>     reducing the debugging effort
> 
> 3. accessing registers in user space can be done by many other ways
>     say, UART. E.g.
>     ADCM2650 and ADCM2670 differs in the control channel connection,
>     one by I2C and the other by UART, the user space control logic has
>     only to decide which device node to open: /dev/i2c/xxx or /dev/ttyXX

I think it is the same for kernel also... Think about serial, PS/2 and 
USB mouse.

> Another biggest concern to the V4L2 API itself, sensor nowadays has
> more control ability than it used to be, some smart sensor provides
> even more like auto focus control, lens control, flash mode, and many
> other features that current V4L2 API cannot cover.

Implement these controls. Make a patch and send it here. If everything 
is OK it should be merged and V4L will be capable to handle these controls.

> Besides, along with the complicated image processing chain, it might
> be better described by kinds of pipeline, like what gstreamer is doing
> now. Moving some or most of the logic to user space will also significantly
> reduce the effort of kernel development.

Yes. It will also dramatically increase development efforts in userspace 
applications. And there will be a lot of different implementations in 
these applications. Actually a lot more than it is in the kernel now.

> Now the problem is: we don't have a standard in user space :(
> 
> Just a topic, any comments. Thanks
> 

My conclusion: your idea just moves problem from kernel to userspace, 
but doesn't solve it...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
