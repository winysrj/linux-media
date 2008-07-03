Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KEYY4-0004iB-P2
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 01:49:14 +0200
Received: by yw-out-2324.google.com with SMTP id 3so418686ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 03 Jul 2008 16:49:00 -0700 (PDT)
Message-ID: <37219a840807031649y2baccc6aja878f25d5628c919@mail.gmail.com>
Date: Thu, 3 Jul 2008 19:49:00 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Andrew McLean" <mcleanandrew@yahoo.com>
In-Reply-To: <37219a840807031624j67a284aeqfe3dbbce71155420@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <639576.43086.qm@web43136.mail.sp1.yahoo.com>
	<37219a840807031624j67a284aeqfe3dbbce71155420@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New Nova-TD-Stick (USB) with new IDs is making
	problems / is not running
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

On Thu, Jul 3, 2008 at 7:24 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On Thu, Jul 3, 2008 at 4:38 PM, Andrew McLean <mcleanandrew@yahoo.com> wrote:
>> Hi folks,
>>
>> I recently bought a "Hauppauge Nova-TD USB-Stick" for
>> DVB-T.
>> The stick was recommended by another linux-user, so I
>> thought, it would work.
>>
>> But now I figured out, that the stick has new
>> settings, I mean a new ID and it is not recognized by
>> the recent kernel-versions (2.6.24 and 2.6.25).
>>
>> The (new) stick comes up with this:
>> idVendor=2040, idProduct=5200
>> At the back of the stick, there is a label showing
>> this:
>> 52009 LF Rev B1F4, Assembled in Indonesia
>>
>> The old and working Nova-TD version comes up with
>> this:
>> idVendor=2040, idProduct=9580
>> (comes from Taiwan)
>>
>> I also installed the latest version of v4l to check,
>> if it is working, but it doesnt.
>>
>> In this kernel modules, the a.m. ID is not listet
>> here:
>> Kernel 2.6.24:
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=blob;f=drivers/media/dvb/dvb-usb/dvb-usb-ids.h;h=4fa3e895028a0596c7a792cb5e451aadceddc634;hb=HEAD
>>
>> Kernel 2.6.25:
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=blob;f=drivers/media/dvb/dvb-usb/dvb-usb-ids.h;h=49a44f249ab0e99f4fd96d0ec725d224420ab3fd;hb=HEAD
>>
>> This is the first time, I'm posting to a mailing list
>> like that, so please advise me, what more information
>> you need. Perhaps you can speed up the development
>> with this information.
>>
>> I have posted several log-files and tests with the
>> a.m. kernel versions on the german debian board here:
>> http://www.debianforum.de/forum/viewtopic.php?f=25&t=100676&start=15&st=0&sk=t&sd=a
>> (written in German)
>>
>> So, I would be really happy, if one of you guys up
>> here can tell me what I can try next to get the new
>> Nova-TD-stick working.
>
> Thanks for your email -- I just got this stick working -- I will post
> a URL in a few minutes.

Please try the following mercurial repository, which adds support for
the Hauppauge Nova-TD stick model 52009:

http://linuxtv.org/hg/~mkrufky/wembley

I have only tested this on a prototype -- I had a problem when tuning
the second tuner, but if you only use one tuner (auto-diversity mode)
it works fine.

I think this is actually a hardware problem, but I am having trouble
locating a production stick right now, so I can't tell if I am testing
on good hardware or not.

Please test this patch with your stick and let me know how it works.
If it works perfectly for you, I'll have it pushed into the master
repository.

Regards,

Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
