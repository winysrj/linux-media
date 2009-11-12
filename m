Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nACGZsUF017750
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 11:35:54 -0500
Received: from mail-iw0-f194.google.com (mail-iw0-f194.google.com
	[209.85.223.194])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nACGZrBY019035
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 11:35:53 -0500
Received: by iwn32 with SMTP id 32so1824568iwn.23
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 08:35:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFC31DE.6060708@gmail.com>
References: <e858e0620911120339t68172862i7f6ec38e88bcf426@mail.gmail.com>
	<4AFC127F.4070300@gmail.com>
	<e858e0620911120754q597b95aah7cb3a0e997a71f02@mail.gmail.com>
	<4AFC31DE.6060708@gmail.com>
From: Shun-Yu Chang <shunyu.chang@gmail.com>
Date: Fri, 13 Nov 2009 00:35:33 +0800
Message-ID: <e858e0620911120835j5a746a89iec9bb754d46e85c3@mail.gmail.com>
To: Ryan Raasch <ryan.raasch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Camera preview, thin lines in the frames
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

On Fri, Nov 13, 2009 at 12:03 AM, Ryan Raasch <ryan.raasch@gmail.com> wrote:

>
>
> Shun-Yu Chang wrote:
>
>>
>>
>> On Thu, Nov 12, 2009 at 9:49 PM, Ryan Raasch <ryan.raasch@gmail.com<mailto:
>> ryan.raasch@gmail.com>> wrote:
>>
>>
>>
>>    Shun-Yu Chang wrote:
>>
>>        Hello, list:
>>           I am new to v4l2.  I am working on integrating a usb camera
>>        device on
>>        the beagleboard(Omap3530 dev board).
>>           Now I met a camera preview issue that is there are thin lines
>>        coming out
>>        in the frames.
>>           I still have no idea how to describe this exactly. It's like
>>        the images
>>        shows here,
>>           http://0xlab.org/~jeremy/camera_preview.html<http://0xlab.org/%7Ejeremy/camera_preview.html>
>>        <http://0xlab.org/%7Ejeremy/camera_preview.html>
>>
>>
>>
>>    I have two guesses. One is the jpeg compression ,or is it jpeg? Try
>>    saving in raw RGB or Ycbcr format and viewing with imagemagick.
>>
>>
>>    The raw data I got is yuyv422. I used the mmap way. I tried to convert
>> raw data to yuv420 and jpg files both.  I used ffmpeg to convert yuv420
>> files to jpg files and I can still see the lines.
>>    I don't know how to use imagemagick to see yuv files...
>>
>>
>>
>>    Does this happen in live preview? Maybe write data from camera
>>    directly to screen to see if happening there.
>>
>>
>>    It happens in live preview.  So I save the frames directly into files
>> to verify.
>>
>>
> But if you save the files, you don't know if the compression is the
> problem. You need to visually look on the screen with a magnifying glass or
> something...


       Got your point, I will try to output to the screen without any
compression later.


>
>
>
>>
>>    The second would be the FIFO (hadn't worked with omap before) levels
>>    of the data lines to the processor in the kernel.
>>
>>    Look at the system processor (top) usage to see how much cpu% is
>>    being used. USB has high overhead.
>>
>>      the top command shows
>>    PID CPU% S  #THR     VSS     RSS UID      Name
>>  1012  56% R     1  55000K  54468K root     capture_test
>>  241  40% R     1      0K      0K root     pdflush
>>    [....Omit, others are 0%. .....]
>>    After grabing the first 100 frames to files, capture_test exits.
>>
>>
> Looks pretty busy to me. Maybe you could kill the pdflush, don't save to
> files, and look at the display with a magnifying glass.
>
>
>     I don't quite understand about FIFO levels of the data lines part.
>>    Could give an instruction where I can start to look into?
>>
>>
> It probrably has dma priorities. So if other drivers in the system
> (network, usb, display, etc.) use a lot of cpu time, the camera dma might be
> delayed.
>
>
> Are you saving the files over network (nfs)?


    No, they are saved to files on the target, then transferred back to my
laptop.



>
>     Thanks for your reply..
>>
>>    Regards,
>>    -Jeremy
>>
>>
>>
>>
>>    Regards,
>>    Ryan
>>
>>
>>           I modified capture.c sample to save the frames to picture
>>        files.  So in
>>        my guess,  the problem is not in userspace. And this is not
>>        happen on my
>>        laptop with the usb camera.
>>           Could anybody give me a clue ?  Any one would be thankful.
>>
>>
>>
>>
>>
>>


-- 
Regards,
-Jeremy
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
