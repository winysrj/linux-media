Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TFPdkc012742
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 10:25:39 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1TFP8om030515
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 10:25:09 -0500
Received: by qb-out-0506.google.com with SMTP id o12so5691855qba.17
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 07:25:06 -0800 (PST)
Message-ID: <f17812d70802290725o77db19daic50aee0380a1dc59@mail.gmail.com>
Date: Fri, 29 Feb 2008 23:25:05 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>
In-Reply-To: <fq8v17$bm9$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
	<fq8v17$bm9$1@ger.gmane.org>
Cc: video4linux-list@redhat.com
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

On Fri, Feb 29, 2008 at 8:49 PM, Paulius Zaleckas
<paulius.zaleckas@teltonika.lt> wrote:
> Hi,
>
>  Take a look at my comments bellow. These are just my thoughts. Maybe I
>  am not right...
>
>  Best regards,
>  Paulius Zaleckas
>
>
>  eric miao wrote:
>  > I know some one has different opinion, but since the sensor control logic is
>  > getting more and more complicated, and provided that differences between
>  > sensors and vendors are already too many. Is it better to move sensor
>  > control out of kernel.
>
>  I agree that sensor control drivers are very different and most of them
>  work only with specific data bus driver. That is really big problem.
>  "soc-camera" framework developed by Guennadi Liakhovetski IMO is the
>  right solution.
>
>
>  > Most sensors come with a serial control channel, I2C as can be seen
>  > most commonly. Access to the control information can be done by
>  > i2c-dev interface if possible, thus the driver can be freed as an I2C
>  > stub only. So technically, this is practical.
>
>  Keep in mind that i2c is used not only for camera sensor control, but
>  for other devices also.
>
>
>  > The benefits I can think of now are:
>  >
>  > 1. simplified sensor driver design
>
>  It is pretty simple with soc-camera framework also. And the best thing
>  is that it is unified. If you implement sensor driver in userspace then
>  what kind of interface should V4L data bus driver expose.
>

The soc-camera is pretty good. Yet it doesn't solve the issue of
complicated sensor control. mt9m001.c and mt9v022.c are two
good examples, but are all too simple. I have a sensor driver here
with more than 4000 lines of code.

>
>  > 2. sensor control related debugging can be moved to user space thus
>  >     reducing the debugging effort
>  >
>  > 3. accessing registers in user space can be done by many other ways
>  >     say, UART. E.g.
>  >     ADCM2650 and ADCM2670 differs in the control channel connection,
>  >     one by I2C and the other by UART, the user space control logic has
>  >     only to decide which device node to open: /dev/i2c/xxx or /dev/ttyXX
>
>  I think it is the same for kernel also... Think about serial, PS/2 and
>  USB mouse.
>

For kernel, that means you have to provide each bus a driver for the specific
connection type, though the kernel has organized things quite well.

>
>  > Another biggest concern to the V4L2 API itself, sensor nowadays has
>  > more control ability than it used to be, some smart sensor provides
>  > even more like auto focus control, lens control, flash mode, and many
>  > other features that current V4L2 API cannot cover.
>
>  Implement these controls. Make a patch and send it here. If everything
>  is OK it should be merged and V4L will be capable to handle these controls.
>

Mmm...then do you expect an API growing into a monster in the kernel space?

>
>  > Besides, along with the complicated image processing chain, it might
>  > be better described by kinds of pipeline, like what gstreamer is doing
>  > now. Moving some or most of the logic to user space will also significantly
>  > reduce the effort of kernel development.
>
>  Yes. It will also dramatically increase development efforts in userspace
>  applications. And there will be a lot of different implementations in
>  these applications. Actually a lot more than it is in the kernel now.
>

Development in user space is always cheaper than in kernel.

>
>  > Now the problem is: we don't have a standard in user space :(
>  >
>  > Just a topic, any comments. Thanks
>  >
>
>  My conclusion: your idea just moves problem from kernel to userspace,
>  but doesn't solve it...
>

I'm not trying to solve how to control the sensor but how to simplify
the kernel effort and maybe with small reward of stability and ease
of development.

>  --
>  video4linux-list mailing list
>  Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>  https://www.redhat.com/mailman/listinfo/video4linux-list
>

-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
