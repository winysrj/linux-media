Return-path: <linux-media-owner@vger.kernel.org>
Received: from zero.voxel.net ([69.9.191.6]:58568 "EHLO zero.voxel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbZFHXJ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 19:09:26 -0400
In-Reply-To: <829197380906071921g54469ee7uac77c10d380a7e0a@mail.gmail.com>
References: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net> <829197380906071921g54469ee7uac77c10d380a7e0a@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <625E57E0-150D-40A1-AF90-7B0112D16931@flyn.org>
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "W. Michael Petullo" <mike@flyn.org>
Subject: Re: funny colors from XC5000 on big endian systems
Date: Mon, 8 Jun 2009 19:09:21 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>> You indicated that you had reason to believe it's a PowerPC  
>>> issue.  Is
>>> there any reason that you came to that conclusion other than that  
>>> you're
>>> running on ppc?  I'm not discounting the possibility, but it  
>>> would be
>>> good to know if you have other information that supports your  
>>> theory.
>>
>> It was a hypothesis, but based on experience in "seeing" endian  
>> bugs in
>> video code and "hearing" endian bugs in audio code. After using  
>> PowerPC
>> long enough, you learn to jump to the endian conclusion pretty  
>> quickly. I
>> was wrong!
>
> Ok, well that's good to know.  I did look at the code and couldn't see
> how it could possibly be an endianness bug.
>
> Bear in mind that the analog support for the 950q is still relatively
> new, and its entirely possible there are some application specific
> bugs to be worked out as there is more testing.
>
> Could you please describe in more detail the *exact* configuration you
> are attempting, including the versions of the applications you are
> using and command line arguments you are passing.  If I can reproduce
> the issue here then I can probably debug it much faster.

I have a VCR connected to my 950Q using the coaxial interface.

Kernel is 2.6.29.4.

I am using streamer from Fedora's xawtv-3.95-11.fc11.ppc:

v4lctl setchannel 3
streamer -r 30 -s 640x480 -f jpeg -i Television -n NTSC-M -c /dev/ 
video0 -o ~/Desktop/foo.avi -t 00:60:00

I am using gstreamer-plugins-good-0.10.14-2.fc11.ppc:

gst-launch v4l2src ! ffmpegcolorspace ! ximagesink

Mike
