Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45083 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbbBMPqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 10:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOOAZEj_6uUVdbysHyp08CD96AAuzRxdVw9MVEmUfL=meg@mail.gmail.com>
References: <s5hvbjbtkp0.wl-tiwai@suse.de>
	<s5h7fvlaozh.wl-tiwai@suse.de>
	<20150213124125.67a67e04@recife.lan>
	<s5hzj8h976f.wl-tiwai@suse.de>
	<CAKocOOOAZEj_6uUVdbysHyp08CD96AAuzRxdVw9MVEmUfL=meg@mail.gmail.com>
Date: Fri, 13 Feb 2015 08:46:54 -0700
Message-ID: <CAKocOOOe9oym4S8Ga50eVbvwJ1R3E_jmGqimC=gR88WqKwVUGw@mail.gmail.com>
Subject: Re: DVB suspend/resume regression on 3.19
From: Shuah Khan <shuahkhan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 13, 2015 at 8:34 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Fri, Feb 13, 2015 at 8:12 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Fri, 13 Feb 2015 12:41:25 -0200,
>> Mauro Carvalho Chehab wrote:
>>>
>>> Em Fri, 13 Feb 2015 15:02:42 +0100
>>> Takashi Iwai <tiwai@suse.de> escreveu:
>>>
>>> > At Mon, 09 Feb 2015 11:59:07 +0100,
>>> > Takashi Iwai wrote:
>>> > >
>>> > > Hi,
>>> > >
>>> > > we've got a bug report about the suspend/resume regression of DVB
>>> > > device with 3.19.  The symptom is VLC doesn't work after S3 or S4
>>> > > resume.  strace shows that /dev/dvb/adaptor0/dvr returns -ENODEV.
>>> > >
>>> > > The reporter confirmed that 3.18 works fine, so the regression must be
>>> > > in 3.19.
>>> > >
>>> > > There is a relevant kernel warning while suspending:
>>> > >
>>> > >  WARNING: CPU: 1 PID: 3603 at ../kernel/module.c:1001 module_put+0xc7/0xd0()
>>> > >  Workqueue: events_unbound async_run_entry_fn
>>> > >   0000000000000000 ffffffff81a45779 ffffffff81664f12 0000000000000000
>>> > >   ffffffff81062381 0000000000000000 ffffffffa051eea0 ffff8800ca369278
>>> > >   ffffffffa051a068 ffff8800c0a18090 ffffffff810dfb47 0000000000000000
>>> > >  Call Trace:
>>> > >   [<ffffffff810055ac>] dump_trace+0x8c/0x340
>>> > >   [<ffffffff81005903>] show_stack_log_lvl+0xa3/0x190
>>> > >   [<ffffffff81007061>] show_stack+0x21/0x50
>>> > >   [<ffffffff81664f12>] dump_stack+0x47/0x67
>>> > >   [<ffffffff81062381>] warn_slowpath_common+0x81/0xb0
>>> > >   [<ffffffff810dfb47>] module_put+0xc7/0xd0
>>> > >   [<ffffffffa04d98d1>] dvb_usb_adapter_frontend_exit+0x41/0x60 [dvb_usb]
>>> > >   [<ffffffffa04d8451>] dvb_usb_exit+0x31/0xa0 [dvb_usb]
>>> > >   [<ffffffffa04d84fb>] dvb_usb_device_exit+0x3b/0x50 [dvb_usb]
>>> > >   [<ffffffff814cefad>] usb_unbind_interface+0x1ed/0x2c0
>>> > >   [<ffffffff8145ceae>] __device_release_driver+0x7e/0x100
>>> > >   [<ffffffff8145cf52>] device_release_driver+0x22/0x30
>>> > >   [<ffffffff814cf13d>] usb_forced_unbind_intf+0x2d/0x60
>>> > >   [<ffffffff814cf3c3>] usb_suspend+0x73/0x130
>>> > >   [<ffffffff814bd453>] usb_dev_freeze+0x13/0x20
>>> > >   [<ffffffff81468fca>] dpm_run_callback+0x4a/0x150
>>> > >   [<ffffffff81469c81>] __device_suspend+0x121/0x350
>>> > >   [<ffffffff81469ece>] async_suspend+0x1e/0xa0
>>> > >   [<ffffffff81081e63>] async_run_entry_fn+0x43/0x150
>>> > >   [<ffffffff81079e72>] process_one_work+0x142/0x3f0
>>> > >   [<ffffffff8107a234>] worker_thread+0x114/0x460
>>> > >   [<ffffffff8107f3b1>] kthread+0xc1/0xe0
>>> > >   [<ffffffff8166b77c>] ret_from_fork+0x7c/0xb0
>>> > >
>>> > > So something went wrong in module refcount, which likely leads to
>>> > > disabling the device and returning -ENODEV in the end.
>>> > >
>
> Hi Takashi and Mauro,
>
> Looking at the stack trace usb_forced_unbind_intf() gets called from
> usb_suspend(). Looks like the suspend path in  unbind_no_pm_drivers_interfaces()
> determines the driver doesn't have suspend/resume support and goes to
> usb_forced_unbind_intf().
>
> At this point forced unbinding results in release the driver via
> usb_driver_release_interface().
>
> It is worth looking into if the driver indeed has suspend/resume
> routines?
>

I am not sure if firmware loading is the issue here. It becomes an
issue in resume
path if firmware isn't cached. I had to fix xc5000 driver to cache the
firmware i.e
don't release it after loading so it remains in the firmware cache for
suspend/resume
to find it.

-- Shuah
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
