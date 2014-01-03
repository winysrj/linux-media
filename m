Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:30726 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbaACIP7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jan 2014 03:15:59 -0500
Message-ID: <BLU0-SMTP23799FFE988CC8375457926ADCA0@phx.gbl>
Date: Fri, 3 Jan 2014 16:15:53 +0800
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
I have another problem with this, if I only request one buffer from
driver(index=0 in v4l2_buffer and only call VIDIOC_QUERYBUF) in both
side(OUTPUT and CAPTURE).
then
"5. Request CAPTURE and OUTPUT buffers. Due to hardware limitations of
MFC on
   some platforms it is recommended to use V4L2_MEMORY_MMAP buffers.
6. Enqueue CAPTURE buffers.
7. Enqueue OUTPUT buffer with first frame.
8. Start streaming (VIDIOC_STREAMON) on both ends.
9. Simultaneously:
   - enqueue buffers with next frames,"

I only have one buffer in OUTPUT, shall I do the next step first?
"
   - dequeue used OUTPUT buffers (blocking operation),
   - dequeue buffers with encoded stream (blocking operation),
   - enqueue free CAPTURE buffers.
"
I have used do the thing below after VIDIOC_QUERYBUF in both sides,
input_buffer.plane[0].data = mmap(NULL, buffer.m.planes[0].length,
PROT_READ | PROT_WRITE,MAP_SHARED, ctx->fd,
buffer.m.planes[0].m.mem_offset);
input_buffer.plane[1].data = mmap(NULL, buffer.m.planes[1].length,
PROT_READ | PROT_WRITE,MAP_SHARED, ctx->fd,
buffer.m.planes[1].m.mem_offset);
so for the the OUTPUT, I shall copy the raw video into the the
input_buffer.plane[0].data and input_buffer.plane[1].data
for different planes and then enqueue it?

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
> 

Thank you
						ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSxnG5AAoJEPb4VsMIzTzidYAIAIaB9iAKZKmpYPXtd5WPgbW6
wi+pOaj3I76me9ssPc2o2E+NOC6glByntsSdDDE0sq3kUMFFX8P+/82Qs1j/N5tt
+nWaOON8dg+TpzGBR2kyNl8juVNUpziw4HjdygI65g+Q6XomkX/Dgongplq8IL4a
hCFLcdIEPTpJJ+jhXd2qgUMEt6+Iz07qhZL8H7XvvP2cBCCrbg4tWNRenFasNm2m
1SsAS6T0lxwFwFwSzPIun9hOh1StbTNSvA0E/1Kt4jhTGCLynnror7FFxAVgrHyk
y8h8ptUSFnxQVCSWFxKwCw/CTDHpASZU0IuAP2Qw1mC5zCjiijgDa35OnUoj380=
=Xyj9
-----END PGP SIGNATURE-----
