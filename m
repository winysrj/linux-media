Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab0FIOvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jun 2010 10:51:08 -0400
Message-ID: <4C0FAA73.8030203@redhat.com>
Date: Wed, 09 Jun 2010 16:51:31 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 16050] New: The ibmcam driver is not working
References: <bug-16050-10286@https.bugzilla.kernel.org/> <20100528154635.129b621b.akpm@linux-foundation.org> <4C04C942.6000900@redhat.com> <4C054105.6020806@tmr.com> <4C07B3BC.3050209@redhat.com> <4C07C316.2090903@tmr.com> <4C07C711.5040900@redhat.com> <4C07D5AC.2000404@tmr.com>
In-Reply-To: <4C07D5AC.2000404@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/03/2010 06:17 PM, Bill Davidsen wrote:
>> So would you be willing to test the new driver (when it is finished) ?
>>
> Sure, just let me know what kernel the patch is against. As you say, my
> cams are Model2 in the old nomenclature.
>
> Interesting that the size is set to 352x240 rather than CIF 352x288. And
> while xawtv sort of works with the latest 2.6.33.5-112.fc13.x86_64 koji
> kernel, cheese doesn't, not that I need it, but it worked on the early
> kernels.
>

Ok, I've a version of the new driver ready for testing.


To test you need the latest libv4l, and my gspca tree:

First update libv4l, do:
git clone git://linuxtv.org/v4l-utils.git
cd v4l-utils/lib
And then follow the instructions here:
http://hansdegoede.livejournal.com/7622.html

Then get my gspca tree, and compile and install it, note
that this is based on the special hg v4l-dvb tree, which
is meant as an overlay to your running kernel, so doing this
will replace the v4l and dvb subsystems of your kernel
while leaving the rest as is:
hg clone http://linuxtv.org/hg/~hgoede/ibmcam
cd ibmcam
make menuconfig
<deselect the ibmcam driver and make any other changes you wish>
make
sudo make install
<reboot, yes really>

Now after the reboot do the following as root:
echo 63 > /sys/module/gspca_main/parameters/debug

And then try using your camera with a v4l app such
as cheese, camorama or some such.

Please collect the output of dmesg and mail it to me.

Also please try running at a resolution of 176x144.

If things don't work (chances are they won't) please try
to describe what exactly is the problem. ie is the
image shifted left / right / up / down with some garbage
or black area being shown on the other side, is there no
image at all is it to dark / light, are the colors wrong etc.

Thanks & Regards,

Hans
