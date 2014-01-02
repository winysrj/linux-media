Return-path: <linux-media-owner@vger.kernel.org>
Received: from [65.55.111.84] ([65.55.111.84]:27833 "EHLO
	blu0-omc2-s9.blu0.hotmail.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750748AbaABOEF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jan 2014 09:04:05 -0500
Message-ID: <BLU0-SMTP2007388F400541ADE209A5AADCB0@phx.gbl>
Date: Thu, 2 Jan 2014 22:03:33 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
In-Reply-To: <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

于 2014年01月02日 20:59, Kamil Debski 写道:
> Hi,
> 
>> From: lxr1234 [mailto:lxr1234@hotmail.com] Sent: Thursday,
>> January 02, 2014 1:57 PM To: Kamil Debski Subject: RE: using MFC
>> memory to memery encoder, start stream and queue order problem
>> 
>> 
>> 
>> Kamil Debski <k.debski@samsung.com>写到：
>>> Hi Randy,
>>> 
>>>> From: randy [mailto:lxr1234@hotmail.com] Sent: Thursday,
>>>> January 02, 2014 12:35 PM Hello
>>>> 
>>>> I have follow the README of the v4l2-mfc-encoder from the 
>>>> http://git.infradead.org/users/kmpark/public-apps it seems
>>>> that I can use the mfc encoder in exynos4412(using 3.5
>>> kernel
>>>> from manufacturer).
>>> 
>>> So it is not the mainline kernel. Could you give a link to
>>> this
>> kernel?
>>> I have doubts that this kernel is using the open source driver.
>>> The driver present in that kernel could be a significantly
>>> modified
>> driver.
>>> 
The kernel souce code can be found here
https://github.com/hizukiayaka/linux-tiny4412-origin
I am pushing.
>> Sorry, It doesn't in a git repo I will update,it later, the
>> kernel is from friendlyarm, I see driver source in kernel.
>>>> But I have a problem with the contain of the README and I
>>>> can't get
>>> the
>>>> key frame(the I-frame in H.264). It said that "6. Enqueue
>>>> CAPTURE buffers. 7. Enqueue OUTPUT buffer with first frame. 
>>>> 8. Start streaming (VIDIOC_STREAMON) on both ends." so I
>>>> shall enqueue buffer before start stream, to enqueue a
>>>> buffer,
>> I
>>>> need to dequeue first, but without start stream, it will
>>>> failed in
>>> both
>>>> side.
>>> 
>>> I think I don't understand this. You should enqueue the buffers
>>> and then start streaming. I think dequeueing is not mentioned
>>> here. First enqueue then dequeue.
>> Without dequeue, hwo to get a buffer to fill data(first raw
>> video)? And what shall enqueue in CAPTURE. Is there a guide fo
>> usibg memory to memory driver?
> 
> After doing a VIDIOC_REQBUFS you should do a VIDIOC_QUERYBUF call 
> to get the buffers. After that you can enqueue them.
> 
> I suggest that you first run decoding. v4l2-mfc-example from
> public-apps. This way you could see how the V4L2 framework works.
> 
I see thank you
the v4l2-mfc-encoder is so difficult that I failed to understand.
My code is modified from gst's mfc decoder, I ignored that ioctl in
source ;)
>>>> In this way I start OUTPUT(input raw video) stream first
>>>> then
>> dequeue
>>>> and enqueue the first frame, then I start the CAPTURE(output
>>>> encoded video) frame, dequeue CAPTURE to get a buffer, get
>>>> the data from
>>> buffer
>>>> then enqueue the buffer. The first frame of CAPTURE is always
>>>> a 22 bytes frame(I don't know whether they are the same data
>>>> all the time, but size is the same from
>>>> m.planes[0].bytesused), but it seems not a key frame.
>>>> 
>>>> What is the problem, and how to solve it.
>>>> 
>>>> P.S I don't test the Linux 3.13-rc4, as the driver is not
>>>> ready for encoder before.
>>>> 
>>>> Thank you
>>> 
>>> Best wishes,
>> Thank you -- lxr1234
> 
> Best wishes, Kamil
> 
> 


I forget to mail to the list, I just repeated to you directly as I
shall CC you.

				Thank you very much

				ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSxXGxAAoJEPb4VsMIzTziHVQH+wXTpbhxjGme1sn8f1gbPNzZ
a3FDBjiVC/WiK0TW0kp1IIlV5X93vMhE/VagXIxgxv7FuNcTRYe3EKxXg96Thk4T
1svg7Cnny0FbZoCbm+2pzg5itvqowZfnQhBI71vnVWVlxHm2ub2tVha/JCtCLoW2
sXDoqg72tcdmxoAl8HqPmokGMkn5aLdVfPnOpLHfPJvNoIWCyOvpc5REutlF4uzT
NjgAZMqBwjARjd0nJiLaxsuQQ3EK8d8MCZkkZTCTQLiH+SKfu/Js3nTK1CCkWhSv
z82WDw5qmE3573+2+xxgACal0jPJaDynXBMd/wvBWzpLvSF/Jcg49RDS8exVQfs=
=q5zX
-----END PGP SIGNATURE-----
