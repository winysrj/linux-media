Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:28790 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbaAHPog convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jan 2014 10:44:36 -0500
Message-ID: <BLU0-SMTP285645C604792269BF67172ADB10@phx.gbl>
Date: Wed, 8 Jan 2014 23:44:30 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
In-Reply-To: <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

于 2014年01月08日 22:42, Kamil Debski 写道:
> Hi Randy,
> 
>> From: randy [mailto:lxr1234@hotmail.com] Sent: Friday, January
>> 03, 2014 4:17 PM
>> 
>> I rewrite my program, it takes the order as below 1.request
>> buffer. 2.mmap input buffer with OUTPUT 3.output buffer with
>> CAPTURE. 4.filled input buffer with the first frame. 5.enqueue
>> the first frame in the input buffer in OUTPUT side 6.enqueue the
>> output buffer in CAPTURE side 7.start stream 8.dequeue CAPTURE 
>> buffer and make output buffer pointer to data of it. 9.get output
>> data from output buffer /* the buffer get size is 22 below */ 
>> 10.dequeue OUTPUT /* timed out, it will never end */ Is there any
>> problem with the order? I don't do any thing simultaneously
>> below, it seems to difficult to me to understand and not easy to
>> debug. I am not sure whether the mmap is correct, but I think it
>> it as I don't get segment fault.
> 
> Please have a look at the V4L2_CID_MPEG_VIDEO_HEADER_MODE control.
>> From your description it seems that it is in its default state -
>> 
> V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE. This means that the header
> for a newly encoded stream is returned after init. Then in another
> buffer you will find the encoded picture.
> 
> So after point 9 please enqueue the CAPTURE buffer again and see
> what happens. I think that you should get the first frame encoded.
> 
There is the lastest my step
1.request buffer.
2.mmap input buffer with OUTPUT
3.output buffer with CAPTURE.
4.filled input buffer with the first frame.
5.enqueue the first frame in the input buffer in OUTPUT side
6.enqueue the all output buffers in CAPTURE side
7.start stream
8.poll blocking to wait OUTPUT or CAPTURE can be dequeue
9-1.if dequeued a CAPTURE buffer and get index from index from buffer
which has been mapped with a output buffer.
9-2.get output data from output buffer and re-enqueue it.
9-3.got back to step 4 but filled the next frame.
10. if dequeued a OUTPUT buffer, then enqueue it and return to step 8
The first frame is 22 bytes but the second is the big size, the third
is the same to the first and the forth is the same size to the second,
but the others are all big sizes(about 140000 to 16000)
> You can also try to set the V4L2_CID_MPEG_VIDEO_HEADER_MODE control
> to V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME and see if it
> works. (instead of enqueueing the CAPTURE buffer again after
> receiving the header).
> 
It won't work, if I do that, after step 7, neither OUPUT nor CAPTURE
will poll return in my program.
but ./mfc-encode -m /dev/video1 -c h264,header_mode=1 work normally,
I think it is the progblem of my code. As I follow your code, the poll
doesn't have timeout.
int mfc_enc_output_available(struct mfc_enc_context *ctx)
{
        int pollret;
        struct pollfd fds[2];
        fds[0].fd = ctx->fd;
        fds[0].events = POLLOUT | POLLERR;
        fds[1].fd = ctx->fd;
        fds[1].events = POLLIN | POLLPRI;

        pollret = poll(&fds, 2, -1);
        if (pollret < 0) {
                PDEBUG("%s: Poll returned error: %d\n", __func__, errno);
                return -1;
        }
        if (pollret == 0) {
                PDEBUG("%s: timed out\n", __func__);
                return -2;
        }
        for (int i = 0; i < 2; i++) {
                if (fds[i].revents & POLLOUT){
                        /* the OUTPUT(input) is ready */
                        PDEBUG("input can be dequeue\n");
                        return 0;
                }
                if (fds[i].revents & POLLIN){
                        /* the CAPTURE(output) is ready */
                        PDEBUG("output can be dequeue\n");
                        return 1;
                }
        }

        PDEBUG("unknown event\n");
        return -1;
}
> In addition I would recommend you to use more than one buffer per
> queue.
> 
Yes, I have, I have read your slide show(Video4Linux2: Path to a
Standardized Video Codec API in pdf format) and your source code, I
create 16 in OUTPUT and 4 for CAPTURE.
For the step 6, I mistaked before, I have enqueued all the buffers in
CAPTURE this time. Here is my poll code.

>> 
>> And the thing in the next is like this I think 11.filled input
>> buffer with the next frame 12.enqueue the next frame in the input
>> buffer in OUTPUT side 13.dequeue CAPTURE buffer and make output
>> buffer pointer to data of it. 14.dequeue OUTPUT goto 11 Is it
>> correct
>> 
>> I doubt the REAME 5. Request CAPTURE and OUTPUT buffers. Due to
>> hardware limitations of MFC on some platforms it is recommended
>> to use V4L2_MEMORY_MMAP buffers. 6. Enqueue CAPTURE buffers. 7.
>> Enqueue OUTPUT buffer with first frame. 8. Start streaming
>> (VIDIOC_STREAMON) on both ends. 9. Simultaneously: I don't need
>> to dequeue the OUTPUT buffer which is with first frame? - enqueue
>> buffers with next frames, - dequeue used OUTPUT buffers (blocking
>> operation), - dequeue buffers with encoded stream (blocking
>> operation), - enqueue free CAPTURE buffers.
>> 
>> 
>> Thank you.
> 
> Best wishes, Kamil
> 
> 
> 

Thank you very much

ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSzXJdAAoJEPb4VsMIzTzipRsIAKc/D42jZzhOXX+7DawAU4o2
9VW4fTPMFV0J2CYcfhRKUdk7s1SLlfoSjqU5FpqopLpL4wGnfDQ4CnMp1VTlLrWy
qItNHRvhQfyd9GZXOAMQ9m5GnEh/TYPNvWB9v9jtwb4kv5FY5fOdW0e2yyCLmZCU
re808QxLhds4y4AViebF/YtRpfOTbSVcW8w6Z5YGEXJSZtu1M6ScQ/owxNjVPMPV
Eb6yrMheGwboY0Jo/7uofl/K15SFHH7FcBS7I2g7kLv0d8Uw3ZSDG4Tke6tSWtLj
gcS6gwhpprpxu1vgtYiUwwdMOKRk0LQiAQC2aIq/IKMdzvP/MjGhbIenq4LKg0c=
=y+7G
-----END PGP SIGNATURE-----
