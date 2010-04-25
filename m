Return-path: <linux-media-owner@vger.kernel.org>
Received: from virgo.netpower.no ([212.33.133.51]:50840 "EHLO
	virgo.netpower.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0DYSqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 14:46:01 -0400
Message-ID: <20100425203918.6t1c16o0g84kwc40@webmail.robin.no>
Date: Sun, 25 Apr 2010 20:39:18 +0200
From: skjelnes@robin.no
To: linux-media@vger.kernel.org
Subject: faulty pac3711
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
I'd have an Exibel snakescope TF2808 which dont make any picure on  
Linux. It worked ok on windows, but I do not have windows installed  
any longer. I do not think there have happened something to the camera  
meanwhile, I'd think the camera is OK. The driver seems to be ok too:

(part of messages)
Apr 25 19:43:16 sigmund-laptop kernel: [   20.967903] gspca: main  
v2.6.0 registered
Apr 25 19:43:16 sigmund-laptop kernel: [   21.214190] gspca: probing 093a:2620
Apr 25 19:43:16 sigmund-laptop kernel: [   21.287398] gspca: probe ok
Apr 25 19:43:16 sigmund-laptop kernel: [   21.287416] gspca: probing 093a:2620
Apr 25 19:43:16 sigmund-laptop kernel: [   21.287431] gspca: probing 093a:2620
Apr 25 19:43:16 sigmund-laptop kernel: [   21.287457] usbcore:  
registered new interface driver pac7311
Apr 25 19:43:16 sigmund-laptop kernel: [   21.287462] pac7311: registered

I'd have tried tvtime and xawtv as viewing application, same result on  
both; blank screen and various error messages.

tvtime comes up with an blue screen "no signal","Frames too short from  
pac7311" and "cannot open capture device /dev/video0".

xawtv started from an terminal outputs this and hangs:
sigmund@sigmund-laptop:~$ xawtv -device /dev/video0
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.31-20-generic)
xinerama 0: 1400x1050+0+0
WARNING: No DGA direct video mode for this display.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Missing charsets in String to FontSet conversion
Warning: Cannot convert string  
"-*-lucidatypewriter-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,            
-*-courier-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,           
-gnu-unifont-bold-r-normal--16-*-*-*-c-*-*-*,         
-efont-biwidth-bold-r-normal--16-*-*-*-*-*-*-*,                  
-*-*-bold-r-normal-*-16-*-*-*-m-*-*-*,                  
-*-*-bold-r-normal-*-16-*-*-*-c-*-*-*,                          
-*-*-*-*-*-*-16-*-*-*-*-*-*-*,*" to type FontSet
Warning: Cannot convert string  
"-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
Warning: Missing charsets in String to FontSet conversion
Warning: Cannot convert string  
"-*-lucidatypewriter-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,            
-*-courier-bold-r-normal-*-14-*-*-*-m-*-iso8859-*,           
-gnu-unifont-bold-r-normal--16-*-*-*-c-*-*-*,         
-efont-biwidth-bold-r-normal--16-*-*-*-*-*-*-*,                  
-*-*-bold-r-normal-*-16-*-*-*-m-*-*-*,                  
-*-*-bold-r-normal-*-16-*-*-*-c-*-*-*,                          
-*-*-*-*-*-*-16-*-*-*-*-*-*-*, *" to type FontSet
ioctl: VIDIOC_G_STD(std=0xb789b1d000971326  
[PAL_B1,PAL_G,PAL_D,PAL_M,PAL_N,NTSC_M,SECAM_B,SECAM_D,SECAM_G,SECAM_K,?ATSC_8_VSB,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)]):
end of xawtv output
syslog also came up with two new lines:
Apr 25 20:30:22 sigmund-laptop kernel: [ 2848.327067] gspca:  
usb_submit_urb [0] err -28
Apr 25 20:30:23 sigmund-laptop kernel: [ 2848.607073] gspca:  
usb_submit_urb [0] err -28

Tried an Creative Live! cam on the same machine and it works ok.

sigmund@sigmund-laptop:~$ uname -a
Linux sigmund-laptop 2.6.31-20-generic #58-Ubuntu SMP Fri Mar 12  
05:23:09 UTC 2010 i686 GNU/Linux

I do not have any idea nor what to do now, nor how the error could be  
further traced down. Hopefully there's somebody on the list who can  
help me.

Cincerely,
Sigmund Skjelnes


