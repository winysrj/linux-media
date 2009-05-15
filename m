Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47193 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZEONFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:05:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1M4x5y-0005bV-BA
	for linux-media@vger.kernel.org; Fri, 15 May 2009 13:05:02 +0000
Received: from ANancy-155-1-46-215.w90-13.abo.wanadoo.fr ([90.13.197.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:05:02 +0000
Received: from Kowaio by ANancy-155-1-46-215.w90-13.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:05:02 +0000
To: linux-media@vger.kernel.org
From: Guillaume <Kowaio@gmail.com>
Subject: V4L2 - Capturing uncompressed data
Date: Fri, 15 May 2009 13:03:11 +0000 (UTC)
Message-ID: <loom.20090515T125828-924@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm a French student and I'm doing an intern ship in a 
French image processing software company, 
and I've got some questions about V4L2 and more precisely, 
the video formats.

In the application, I just need to capture frames 
of webcams and display the result. 
After research, I found the capture example on the
http://v4l2spec.bytesex.org/ website. 
So now, I capture correctly the frames.

During the initialisation of the device,
 I'm doing a VIDIOC_G_FMT in order to
get the format description of the webcam. 
Then, I tried to change the pixelformat.
Indeed, I wanted the YUYV FORMAT because I need to get the raw data
in order to get the best quality possible.

My problem is, after the VIDIOC_S_FMT, the pixelformat field 
is set back to JPEG FORMAT (and the colorspace too) and so,
I don't get raw data, but compressed jpeg data.

I know that the VIDIOC_S_FMT try to change these fields 
but if the driver don't authorise them, 
it will put the originals back. 

But, I really need to get the
uncompressed data of the captured picture,
so is there by any chance, another solution to 'force' 
and capture the images in an Uncompressed format ? 
Or is it really set by the driver and so, 
no chance to have the raw ?

So, in my InitDevice I'm doing that :

     //Get FMT
    Clear( &mFmt, sizeof( mFmt ) );
    mFmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

    if ( -1 == Xioctl ( mFd, VIDIOC_G_FMT, &mFmt ) )
        return false;

    //Set FMT A LA RESOLUTION CHOISIE
    :Clear( &mFmt, sizeof( mFmt ) );
    mFmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    mFmt.fmt.pix.width = iInfo.Width;
    mFmt.fmt.pix.height = iInfo.Height;

//I want to capture raw data
in YUYV, no JPEG compressed stuff
    mFmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;  

    mFmt.fmt.pix.field = V4L2_FIELD_INTERLACED;

    if ( -1 == Xioctl ( mFd, VIDIOC_S_FMT, &mFmt ) )
        return false;

       //JPEG - set yuyv failed
printf("%d\n",mFmt.fmt.pix.pixelformat);

 //JPEG - always jpeg, but i don't
want this
    printf("%d\n",mFmt.fmt.pix.colorspace);  


To be clear, I want the uncompressed pixels of the capture. 
I already succeeded in converting from JPEG to BGR, 
but the data are compressed.

So now, I don't want to do that conversion. 
Actually, I want to save the
uncompressed data for quality directly!

But I don't know if that is possible because 
the driver of the webcam (VF0420 Live! Cam Vista IM - ov519)
 specified only JPEG format when I'm doing a 'V4l-info'.

I really looked for answers everywhere on the web,
so I'm losing hope and that's why I'm asking you that today. 
I'm sorry if my comment is misplaced or if the
answer has already been posted.

Thank you all,
Regards.
Guillaume. 

