Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LFCYA-0001dQ-PH
	for linux-dvb@linuxtv.org; Tue, 23 Dec 2008 20:04:15 +0100
Received: by bwz11 with SMTP id 11so5746336bwz.17
	for <linux-dvb@linuxtv.org>; Tue, 23 Dec 2008 11:03:39 -0800 (PST)
Message-ID: <cae4ceb0812231102i4dac3a44gde4d807ac9d2a03a@mail.gmail.com>
Date: Tue, 23 Dec 2008 11:02:11 -0800
From: "Tu-Tu Yu" <tutuyu@usc.edu>
To: "Matyas Sustik" <linux-dvb.list@sustik.com>
In-Reply-To: <494E56EA.7080604@sustik.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <494D4A00.6020305@sustik.com>
	<1229809078.4702.34.camel@pc10.localdom.local>
	<494E56EA.7080604@sustik.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV7 again
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi
I had this same problem, but after i update the v4l-dvb code, the
problem is solved.
But when i do "modprobe cx23885", it shows that "FATAL: Module cx23885
not found."
Can anyone tell me what should I do with this problem?
Thank you so much
Audrey


On Sun, Dec 21, 2008 at 6:47 AM, Matyas Sustik
<linux-dvb.list@sustik.com> wrote:
> hermann pitton wrote:
>> Hi Matyas,
>> In this case the old compat-ioctl32 is not replaced by the new
>> v4l2-compat-ioctl32 module.
>>
>> If you do on top of the modules of your kernel version
>> "less modules.symbols |grep ioctl32",
>> you likely will see this.
>> alias symbol:v4l_compat_ioctl32 compat_ioctl32
>> alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32
>>
>> But it should be only that.
>> less modules.symbols |grep ioctl32
>> alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32
>>
>> On top of the mercurial v4l-dvb do
>> "make rmmod", since some complaints are visible do it again.
>>
>> Then "make rminstall" should remove all old modules,
>> but renamed ones or such in distribution specific wrong locations
>> remain.
>>
>> Check with "ls -R |grep .ko" on top of your kernel's media modules
>> folder.
>>
>> Delete the media folder or the modules.
>
> I edited modules.symbols to comply to your suggestion.  I made sure that
> the old modules are gone.  After a recompile, install and reboot the driver
> started to work again!
>
> Thanks a lot.
> Matyas
> -
> Every hardware eventually breaks.  Every software eventually works.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
