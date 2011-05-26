Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46642 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1EZPS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 11:18:58 -0400
Received: by qyk7 with SMTP id 7so2772917qyk.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 08:18:58 -0700 (PDT)
References: <4DDE5168.1090805@MessageNetSystems.com> <89C9F515-ECF8-48DD-8DB9-EEA58A78CAD3@wilsonet.com> <4DDE62BD.9010208@MessageNetSystems.com>
In-Reply-To: <4DDE62BD.9010208@MessageNetSystems.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <738A926F-0D1F-4108-B26D-3652CFC4A2DF@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: use compile uvc_video
Date: Thu, 26 May 2011 11:19:04 -0400
To: Jerry Geis <geisj@MessageNetSystems.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 26, 2011, at 10:25 AM, Jerry Geis wrote:
...
>>> Is there a way I can just compile the linux/drivers/media/video/uvc ?
>>>    
>> 
>> Edit the .config file, disable anything you don't want to build.
>> 
>>  
>>> thats all I need. How do I do that?
>>>    
>> 
>> Another option you can try is something along the lines of this:
>> 
>> cd linux/drivers/media/video/uvc
>> make -C /lib/modules/2.6.18-194.32.1.el5/build M=$PWD modules
>> 
>> No guarantees that won't fail miserably though.
>> 
>> Backporting newer drivers to older kernels often takes a fair bit of
>> effort and subject matter expertise -- especially when the kernel base
>> is as ancient as the one you're targeting. There's a reason media_build
>> doesn't support anything that old. :)
>> 
>>  
> I am trying your suggestion. with the "make -C" when I do this I get errors about
> include files not found. I was trying to specify "-I path/v4l -I path/linux/include" on the make line
> but it still does not find the compat.h and linux/usb.video.h

Those probably need to be made relative to linux/drivers/media/video/uvc/.


> Your correct, my machines 5.6 and I was compiling on 5.5 machine.

Yeah, I'm quite familiar with the EL5 kernel. Just take a look at the
kernel rpm changelog entries. :)


-- 
Jarod Wilson
jarod@wilsonet.com



