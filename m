Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f200.google.com ([209.85.216.200]:60520 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbZFHLqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 07:46:47 -0400
Received: by pxi38 with SMTP id 38so3887pxi.33
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 04:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244448176.15110.0.camel@xie>
References: <1244426759.6740.31.camel@xie>
	 <5e9665e10906072356l686f4301v2546460c86bdf721@mail.gmail.com>
	 <1244448176.15110.0.camel@xie>
Date: Mon, 8 Jun 2009 20:40:40 +0900
Message-ID: <5e9665e10906080440p446e1044sf869e73ae1f6c1a8@mail.gmail.com>
Subject: Re: About the VIDIOC_DQBUF
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: xie <yili.xie@gmail.com>
Cc: v4l2_linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry I'm not an expert, you can expect expertise from maintainers not from me.
But before answering your question about capturing, I'm not sure about
what the "full frame" means. I just assume that you meant to say the
biggest resolution of image frame, right?

So, when you are to capture a full resolution data while preview is
working, you need to stop preview with streamoff, re-configure
resolution with s_fmt to external camera module and  start capturing
issuing streamon with re-configured resolution. I think you are
well-aware with this, aren't you? And in my opinion, memcpy may be
cool for that. What else are you expecting to use? and for what?
Anyway, I wish you luck.
Cheers,

Nate


On Mon, Jun 8, 2009 at 5:02 PM, xie<yili.xie@gmail.com> wrote:
> Hi Dongsoo, Nathaniel ~
> You must be expert on V4l2 ~ Thanks very much for your help and advice
> ~!~
> I used the MXC camera interface driver from Fressscale ,I readed the
> driver interface just now ,and have fouded that the driver not modified
> the buf.lenth but buf.byteused . You are very right , I will use the
> buf.byteused instead of buf.length ~
>
> There is also a problem I want to consult to you ~ Can i get a full
> frame with the below method if the driver have no problem ?
>
> memcpy((mCameraProwave->getPreviewHeap())->base(),
> v4l2Buffer[buf.index].start, buf.byteused) ;
>
> Because I just need to implement a hal for getting the frame data and
> post it to top layer , so I used the memcpy simply . Am I right ~ ? Or
> what about your advice ?
>
> Thanks a lot ~~
>
>
>
> 在 2009-06-08一的 15:56 +0900，Dongsoo, Nathaniel Kim写道：
>> Hello Xie,
>>
>> I'm not sure which camera interface driver you are using, but it seems
>> to be camera interface driver's problem. Let me guess, are you using
>> pxa camera interface driver from Marvell?(proprietary but not in up
>> stream kernel)
>> It just looks like that camera interface driver is not returning
>> proper data in dqbuf.
>>
>> And one more thing. I prefer to use byteused rather than length in
>> buf. because as far as I know the size of preview data from camera is
>> in byte unit which we need to copy to memory. But it should be
>> possible to use length, I guess..
>> Cheers,
>>
>> Nate
>>
>> On Mon, Jun 8, 2009 at 11:05 AM, xie<yili.xie@gmail.com> wrote:
>> > Dear all ~~
>> >
>> > I have met a issue when I used the mmap method for previewing . I just
>> > used the standard code as spec to get the image data :
>> > status_t CameraHardwareProwave::V4l2Camera::v4l2CaptureMainloop()
>> > {
>> >        LOG_FUNCTION_NAME
>> >        int rt  ;
>> >        unsigned int i ;
>> >        fd_set fds ;
>> >        struct timeval tv ;
>> >        struct v4l2_buffer buf ;
>> >
>> >        for(;;){
>> >                FD_ZERO(&fds) ;
>> >                FD_SET(v4l2Fd, &fds) ;
>> >                //now the time is long ,just for debug
>> >                tv.tv_sec = 2 ;
>> >                tv.tv_usec = 0 ;
>> >
>> >                rt = select(v4l2Fd + 1, &fds, NULL, NULL, &tv) ;
>> >                LOGD("The value of select return : %d\n", rt) ;
>> >
>> >                /********** for debug
>> >                if(V4L2_NOERROR != v4l2ReadFrame()){
>> >                        LOGE("READ ERROR") ;
>> >                }
>> >                ***********/
>> >
>> >                if(-1 == rt){
>> >                        LOGE("there is something wrong in select function(select)") ;
>> >                        //no defined error manage
>> >                        return V4L2_IOCTL_ERROR ;
>> >                }
>> >                if(0 == rt){
>> >                        LOGE("wait for data timeout in select") ;
>> >                        return V4L2_TIMEOUT ;
>> >                }
>> >
>> >                memset(&buf, 0, sizeof(buf)) ;
>> >                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE ;
>> >                buf.memory = V4L2_MEMORY_MMAP ;
>> >                if(-1 == ioctl(v4l2Fd, VIDIOC_DQBUF, &buf)){
>> >                    LOGE("there is something wrong in dequeue buffer(VIDIOC_DQBUF)") ;
>> >                        return V4L2_IOCTL_ERROR ;
>> >                }
>> >
>> >                assert(i < n_buf) ;
>> >                LOGE("buf.index  0buf.length = %d %d \n", buf.index , buf.length) ;
>> >        memcpy((mCameraProwave->getPreviewHeap())->base(),
>> > v4l2Buffer[buf.index].start, buf.length) ;
>> >                if(-1 == ioctl(v4l2Fd, VIDIOC_QBUF, &buf)){
>> >                    LOGE("there is something wrong in enqueue buffer(VIDIOC_QBUF)") ;
>> >                        return V4L2_IOCTL_ERROR ;
>> >                }
>> >                //break ;   //i don't know whether the break is needed ;
>> >
>> >        }
>> >        return V4L2_NOERROR ;
>> > }
>> >
>> > when executed the VIDIOC_DQBUF IOCTL,the return value was right, but the
>> > value of buf.length would always  be zero. Then I used the read()
>> > function to read raw data in the file handle for debug, and I can get
>> > the raw data. Anybody have met this issue before ? Who can give me some
>> > advices or tell me what is wrong , thanks a lot ~
>> >
>> >
>>
>>
>>
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
