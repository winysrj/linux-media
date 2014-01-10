Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s9.blu0.hotmail.com ([65.55.111.84]:35456 "EHLO
	blu0-omc2-s9.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaAJJPs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 04:15:48 -0500
Message-ID: <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl>
Date: Fri, 10 Jan 2014 17:15:47 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>, kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com> <52CD725E.5060903@hotmail.com>
In-Reply-To: <52CD725E.5060903@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

于 2014年01月08日 23:44, randy 写道:
> 于 2014年01月08日 22:42, Kamil Debski 写道:
>> Hi Randy,
> 
>> Please have a look at the V4L2_CID_MPEG_VIDEO_HEADER_MODE
>> control.
>>> From your description it seems that it is in its default state
>>> -
>>> 
>> V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE. This means that the header 
>> for a newly encoded stream is returned after init. Then in
>> another buffer you will find the encoded picture.
> 
> There is the lastest my step 1.request buffer. 2.mmap input buffer
> with OUTPUT 3.output buffer with CAPTURE. 4.filled input buffer
> with the first frame. 5.enqueue the first frame in the input buffer
> in OUTPUT side 6.enqueue the all output buffers in CAPTURE side 
> 7.start stream 8.poll blocking to wait OUTPUT or CAPTURE can be
> dequeue 9-1.if dequeued a CAPTURE buffer and get index from index
> from buffer which has been mapped with a output buffer. 9-2.get
> output data from output buffer and re-enqueue it. 9-3.got back to
> step 4 but filled the next frame. 10. if dequeued a OUTPUT buffer,
> then enqueue it and return to step 8 The first frame is 22 bytes
> but the second is the big size, the third is the same to the first
> and the forth is the same size to the second, but the others are
> all big sizes(about 140000 to 16000)
>> You can also try to set the V4L2_CID_MPEG_VIDEO_HEADER_MODE
>> control to V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME and
>> see if it works. (instead of enqueueing the CAPTURE buffer again
>> after receiving the header).
> 
> It won't work, if I do that, after step 7, neither OUPUT nor
> CAPTURE will poll return in my program. but ./mfc-encode -m
> /dev/video1 -c h264,header_mode=1 work normally,
I am sorry, I didn't well test it, if I use ./mfc-encode -m
/dev/video1 -c h264,header_mode=1 -d 1
then the size of demo.out is zero,
but ./mfc-encode -d 1 -m /dev/video1 -c h264 will out a 158 bytes files.
When duration is 2, with header_mode=1, the output file size is 228
bytes.Without it, the size is 228 too.
I wonder whether it is the driver's problem, as I see this in dmesg
[    0.210000] Failed to declare coherent memory for MFC device (0
bytes at 0x43000000)
As the driver is not ready to use in 3.13-rc6 as I reported before, I
still use the 3.5 from manufacturer.
> I think it is the progblem of my code. As I follow your code, the
> poll doesn't have timeout. int mfc_enc_output_available(struct
> mfc_enc_context *ctx) { int pollret; struct pollfd fds[2]; 
> fds[0].fd = ctx->fd; fds[0].events = POLLOUT | POLLERR; fds[1].fd =
> ctx->fd; fds[1].events = POLLIN | POLLPRI;
> 
> pollret = poll(&fds, 2, -1); if (pollret < 0) { PDEBUG("%s: Poll
> returned error: %d\n", __func__, errno); return -1; } if (pollret
> == 0) { PDEBUG("%s: timed out\n", __func__); return -2; } for (int
> i = 0; i < 2; i++) { if (fds[i].revents & POLLOUT){ /* the
> OUTPUT(input) is ready */ PDEBUG("input can be dequeue\n"); return
> 0; } if (fds[i].revents & POLLIN){ /* the CAPTURE(output) is ready
> */ PDEBUG("output can be dequeue\n"); return 1; } }
> 
> PDEBUG("unknown event\n"); return -1; }
>> In addition I would recommend you to use more than one buffer
>> per queue.
> 
> Yes, I have, I have read your slide show(Video4Linux2: Path to a 
> Standardized Video Codec API in pdf format) and your source code,
> I create 16 in OUTPUT and 4 for CAPTURE. For the step 6, I mistaked
> before, I have enqueued all the buffers in CAPTURE this time. Here
> is my poll code.
> 
>>> 
>>> And the thing in the next is like this I think 11.filled input 
>>> buffer with the next frame 12.enqueue the next frame in the
>>> input buffer in OUTPUT side 13.dequeue CAPTURE buffer and make
>>> output buffer pointer to data of it. 14.dequeue OUTPUT goto 11
>>> Is it correct
>>> 
>>> I doubt the REAME 5. Request CAPTURE and OUTPUT buffers. Due
>>> to hardware limitations of MFC on some platforms it is
>>> recommended to use V4L2_MEMORY_MMAP buffers. 6. Enqueue CAPTURE
>>> buffers. 7. Enqueue OUTPUT buffer with first frame. 8. Start
>>> streaming (VIDIOC_STREAMON) on both ends. 9. Simultaneously: I
>>> don't need to dequeue the OUTPUT buffer which is with first
>>> frame? - enqueue buffers with next frames, - dequeue used
>>> OUTPUT buffers (blocking operation), - dequeue buffers with
>>> encoded stream (blocking operation), - enqueue free CAPTURE
>>> buffers.
>>> 
>>> 
>>> Thank you.
> 
>> Best wishes, Kamil
> 
> 
> 
> 
> Thank you very much
> 
> ayaka
Thank you
ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSz7pDAAoJEPb4VsMIzTziS/QIAJL1sd+2XNy4d/wzCYOL5mLv
xny5/7zWTtiW1Ti7s6pnxyed2RvhzQlSAWHM2nsk9AzCTdUVNmXCq3b4CF3aKSP3
7OhpqlFWCEb+uxW98FuH9PPvlR8PAnhhWTkdxtW6Xe3CpSZ7rVYaxrs36LWX3K1S
ntW3nfMwoecmtd45NUTtfajvwR3+kmS5IFzM7zdbIykzhf7aOvxQ9JdSqNBT97O3
/xk8XCFGAg9kDGcR9g95mZCEEDVgVBHNAM2WLtihV7kEcpOxe0q4FccXxngCWvQd
vYDYjpFYLjAYJzXM9P5BPCg7drDndCLof6fGeIG783J+OruOfTSrwuxVa7hsEzw=
=Uq4w
-----END PGP SIGNATURE-----
