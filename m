Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f187.google.com ([209.85.216.187]:45865 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZFHCMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 22:12:43 -0400
Received: by pxi17 with SMTP id 17so112988pxi.33
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2009 19:12:45 -0700 (PDT)
Subject: About the VIDIOC_DQBUF
From: xie <yili.xie@gmail.com>
To: linux-media@vger.kernel.org
Cc: "Dongsoo, Nathaniel Kim(V4L2)" <dongsoo.kim@gmail.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 10:05:59 +0800
Message-Id: <1244426759.6740.31.camel@xie>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all ~~

I have met a issue when I used the mmap method for previewing . I just
used the standard code as spec to get the image data :
status_t CameraHardwareProwave::V4l2Camera::v4l2CaptureMainloop()
{
	LOG_FUNCTION_NAME
	int rt  ;
	unsigned int i ;
	fd_set fds ;
	struct timeval tv ;
	struct v4l2_buffer buf ;

	for(;;){
		FD_ZERO(&fds) ;
		FD_SET(v4l2Fd, &fds) ;
		//now the time is long ,just for debug
		tv.tv_sec = 2 ;
		tv.tv_usec = 0 ;

		rt = select(v4l2Fd + 1, &fds, NULL, NULL, &tv) ;
		LOGD("The value of select return : %d\n", rt) ;
		
		/********** for debug
		if(V4L2_NOERROR != v4l2ReadFrame()){
			LOGE("READ ERROR") ;
		}
                ***********/
		
		if(-1 == rt){
			LOGE("there is something wrong in select function(select)") ;
			//no defined error manage
			return V4L2_IOCTL_ERROR ;
		}
		if(0 == rt){
			LOGE("wait for data timeout in select") ;
			return V4L2_TIMEOUT ;
		}

		memset(&buf, 0, sizeof(buf)) ;
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE ;
		buf.memory = V4L2_MEMORY_MMAP ;
		if(-1 == ioctl(v4l2Fd, VIDIOC_DQBUF, &buf)){
		    LOGE("there is something wrong in dequeue buffer(VIDIOC_DQBUF)") ;
			return V4L2_IOCTL_ERROR ;
		}
		
		assert(i < n_buf) ;
		LOGE("buf.index  0buf.length = %d %d \n", buf.index , buf.length) ;
        memcpy((mCameraProwave->getPreviewHeap())->base(),
v4l2Buffer[buf.index].start, buf.length) ;
		if(-1 == ioctl(v4l2Fd, VIDIOC_QBUF, &buf)){
		    LOGE("there is something wrong in enqueue buffer(VIDIOC_QBUF)") ;
			return V4L2_IOCTL_ERROR ;
		}
		//break ;   //i don't know whether the break is needed ;
		 
	}
	return V4L2_NOERROR ;
}

when executed the VIDIOC_DQBUF IOCTL,the return value was right, but the
value of buf.length would always  be zero. Then I used the read()
function to read raw data in the file handle for debug, and I can get
the raw data. Anybody have met this issue before ? Who can give me some
advices or tell me what is wrong , thanks a lot ~

