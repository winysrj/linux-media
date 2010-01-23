Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:35869 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab0AWJQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 04:16:22 -0500
Message-ID: <4B5ABE5F.50704@skynet.be>
Date: Sat, 23 Jan 2010 10:16:15 +0100
From: xof <xof@skynet.be>
MIME-Version: 1.0
To: LiM <lim@brdo.cz>
CC: linux-media@vger.kernel.org
Subject: Re: bt878 card: no sound and only xvideo support in 2.6.31 bttv 0.9.18
References: <4B580AB2.6030005@brdo.cz> <20100121094943.GA2332@localhost.lan> <4B595C40.2070001@brdo.cz>
In-Reply-To: <4B595C40.2070001@brdo.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LiM a écrit :
> Leopold Gouverneur napsal(a):
>   
>> On Thu, Jan 21, 2010 at 09:05:06AM +0100, LiM wrote:
>>   
>>     
>>> Hello,
>>>
>>> i have the same problem as http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11441 also with Hercules Smart TV Stereo ..
>>> works OK audio+video on ..2.6.29-gentoo-r5 + bttv 0.9.17
>>> but NO AUDIO on linux-2.6.31-gentoo-r6 + bttv 0.9.18
>>>
>>>       
>
> Hi,
>
> and is any chance it will be working with new version?
>
> Michal
>   
A temporary solution (if you can use a solder iron) is to get audio out
of the (tuner) metal box and inject it at the CD connector on the
motherboard.

    See : http://www.genicus.be/?p=592

(It works for me.  There is an audio out pin (AF) on the TDA9801T in the
metal box. lip-sync is not perfect, but, at least, I hear something...)

But, of course, it would be better to make the driver work.

I had the same problem in 2008 when somebody changed tvaudio and I did
not realize I had to specify new options in my /etc/modprobe.d/bttv.conf
file.  I wonder why 'bttv card=100' is not enough to specify the
hardware and what to do with it.  There is an entry 'Hercules Smart TV
Stereo' in bttv-cards.c.  I am not sure what can be done with
autodetecting chips on an unknown board.  I agree, this is probably
complex matter but this mix of specification and autodetection is suspect.

My card is 1540:952b - Hercules Smart TV 2 Stereo.
    there is a TDA9801T in the metal box labelled TVF-8533-B/DF
    a Conexant Fusion 878A (~compatible Bt878)
    a TDA9874AH on the (audio) piggy back
and two other chips (?pic16c54 (a dip-18 labeled 'B05')? and ? a dip-8
with Label 'GI0')

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=commitdiff;h=859f0277a6c3ba59b0a5a1eb183f8f6ce661a95d
is difficult to follow as there are changes in i2c handling,
autodetection, v4l and v4l2 architectures,...  I don't know if there is
some documentation about the (reverse engineered) wiring of the board
themselves or is the code 'is/was' the documentation.

The 'Hercules Smart TV' is probably not the only card with a sound
problem after those reorganisations.  I also hope that it is not a 'big
bug' and that it will be back one of these days but (I feel) it is
nearly impossible to help from outside.


xof
