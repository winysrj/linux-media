Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1JHIOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Oct 2011 04:14:25 -0400
Message-ID: <4E900660.7030606@redhat.com>
Date: Sat, 08 Oct 2011 10:14:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl> <4E8DE450.7030302@redhat.com> <4E8E5EEA.80906@redhat.com> <201110070805.31054.hverkuil@xs4all.nl> <4E8EF87E.5000601@infradead.org> <4E8EF91D.2080908@redhat.com> <4E8F029D.3020705@infradead.org>
In-Reply-To: <4E8F029D.3020705@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/07/2011 03:46 PM, Mauro Carvalho Chehab wrote:
> Em 07-10-2011 10:05, Hans de Goede escreveu:
>> Hi,
>>
>> On 10/07/2011 03:02 PM, Mauro Carvalho Chehab wrote:
>>> Em 07-10-2011 03:05, Hans Verkuil escreveu:
>>>> On Friday, October 07, 2011 04:07:38 Mauro Carvalho Chehab wrote:
>>>>> Em 06-10-2011 14:24, Mauro Carvalho Chehab escreveu:
>>>>>> Em 06-10-2011 10:27, Mauro Carvalho Chehab escreveu:
>>>>>>> Em 06-10-2011 09:23, Hans Verkuil escreveu:
>>>>>>>> Currently we have three repositories containing libraries and utilities that
>>>>>>>> are relevant to the media drivers:
>>>>>>>>
>>>>>>>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
>>>>>>>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
>>>>>>>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>>>>>>>>
>>>>>>>> It makes no sense to me to have three separate repositories, one still using
>>>>>>>> mercurial and one that isn't even on linuxtv.org.
>>>>>>>>
>>>>>>>> I propose to combine them all to one media-utils.git repository. I think it
>>>>>>>> makes a lot of sense to do this.
>>>>>>>>
>>>>>>>> After the switch the other repositories are frozen (with perhaps a README
>>>>>>>> pointing to the new media-utils.git).
>>>>>>>>
>>>>>>>> I'm not sure if there are plans to make new stable releases of either of these
>>>>>>>> repositories any time soon. If there are, then it might make sense to wait
>>>>>>>> until that new stable release before merging.
>>>>>>>>
>>>>>>>> Comments?
>>>>>>>
>>>>>>> I like that idea. It helps to have the basic tools into one single repository,
>>>>>>> and to properly distribute it.
>>>>>
>>>>> Ok, I found some time to do an experimental merge of the repositories. It is available
>>>>> at:
>>>>>
>>>>> http://git.linuxtv.org/mchehab/media-utils.git
>>>>>
>>>>> For now, all dvb-apps stuff is on a separate directory. It makes sense to latter
>>>>> re-organize the directories. Anyway, the configure script will allow disable
>>>>> dvb-apps, v4l-utils and/or libv4l. The default is to have all enabled.
>>>>>
>>>>> One problem I noticed is that the dvb-apps are at version 1.1. So, if we're
>>>>> releasing a new version, we'll need to jump from 0.9 to dvb-apps version + 1.
>>>>> So, IMO, the first version with the merge should be version 1.2.
>>>>>
>>>>> Comments?
>>>>
>>>> Strange:
>>>>
>>>> $ git clone git://git.linuxtv.org/mchehab/media-utils.git
>>>> Cloning into media-utils...
>>>> fatal: The remote end hung up unexpectedly
>>>>
>>>> I've no problem with other git trees.
>>>
>>> Hans,
>>>
>>> FYI, I'm getting this when compiling from the v4l-utils tree (even before the merge):
>>>
>>> g++ -o qv4l2 qv4l2.o general-tab.o ctrl-tab.o v4l2-api.o capture-win.o moc_qv4l2.o moc_general-tab.o moc_capture-win.o qrc_qv4l2.o -L/usr/lib -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util -ldl -ljpeg -lQtGui -lQtCore -lpthread
>>> qv4l2.o: In function `ApplicationWindow::setDevice(QString const&, bool)':
>>> /home/v4l/work_trees/media-utils/utils/qv4l2/qv4l2.cpp:149: undefined reference to `libv4l2_default_dev_ops'
>>> collect2: ld returned 1 exit status
>>>
>>
>> Yeah, that is because qmake is stupid and add /usr/lib[64] to the library path and adds it *before* the
>> paths we've specified in its template, so if you've an older libv4l2 installed in /usr/lib[64] when building
>> you get this.
>>
>> To fix it, first do a make; make install in the lib subdir, with LIBDIR setup up to overwrite the old version.
>
> Didn't work, as the Fedora package installed it at /usr/lib, while make install installed at /usr/local/lib.
>
> (ok, I forced it anyway, by renaming the old library, but this sucks)
>

Agreed (that it sucks).

> The right thing to do is to get rid of it from qv4l2.pro. I can see two possible solutions:
>
> 1) add a logic at the build target that would do something like "cat qv4l2.pro|sed s,"\-L/usr/lib",,";
>
> 2) Don't use -L for the libraries. In this case, we'll need to add some logic to include either the .so or the
> .a version of the library, depending on the type of the libraries that were generated.

We're not adding the -L/usr/lib, qmake is when it generates the Makefile, which is why I gave up after
a quick attempt to fix it. Patches welcome :)

Regards,

Hans
