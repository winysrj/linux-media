Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KfGxr-0001eC-US
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 18:30:19 +0200
Received: by rn-out-0910.google.com with SMTP id m36so1283329rnd.2
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 09:30:11 -0700 (PDT)
Message-ID: <37219a840809150930x914be0ckc2eebfd73d87fced@mail.gmail.com>
Date: Mon, 15 Sep 2008 12:30:10 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Patrick Boisvenue" <patrbois@magma.ca>
In-Reply-To: <48CABF2A.9090407@magma.ca>
MIME-Version: 1.0
Content-Disposition: inline
References: <48C659C5.8000902@magma.ca> <48C68DC5.1050400@linuxtv.org>
	<48C73161.7090405@magma.ca> <48C732DE.2030902@linuxtv.org>
	<1221087304.2648.7.camel@morgan.walls.org> <48C86857.70603@magma.ca>
	<1221095447.2648.69.camel@morgan.walls.org>
	<48CAB3EA.5050600@magma.ca>
	<37219a840809121141j2b2cedf9mf5b0edd005a9daba@mail.gmail.com>
	<48CABF2A.9090407@magma.ca>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

On Fri, Sep 12, 2008 at 3:12 PM, Patrick Boisvenue <patrbois@magma.ca> wrote:
> Michael Krufky wrote:
>>
>> On Fri, Sep 12, 2008 at 2:24 PM, Patrick Boisvenue <patrbois@magma.ca>
>> wrote:
>>>
>>> Andy Walls wrote:
>>>>
>>>> On Wed, 2008-09-10 at 20:37 -0400, Patrick Boisvenue wrote:
>>>>>
>>>>> Andy Walls wrote:
>>>>>>
>>>>>> On Tue, 2008-09-09 at 22:37 -0400, Steven Toth wrote:
>>>>>>>
>>>>>>> Patrick Boisvenue wrote:
>>>>>>>>
>>>>>>>> Steven Toth wrote:
>>>>>>>>>
>>>>>>>>> Patrick Boisvenue wrote:
>>>>>>>>
>>>>>>>> When launching dvbscan I get the following in dmesg:
>>>>>>>>
>>>>>>>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
>>>>>>>> firmware: requesting dvb-fe-xc5000-1.1.fw
>>>>>>>> kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
>>>>>>>> register things with the same name in the same directory.
>>>>>>>> Pid: 8059, comm: kdvb-fe-0 Tainted: P          2.6.26-gentoo #11
>>>>>>>>
>>>>>>>> Call Trace:
>>>>>>>>  [<ffffffff8036abb5>] kobject_add_internal+0x13f/0x17e
>>>>>>>>  [<ffffffff8036aff2>] kobject_add+0x74/0x7c
>>>>>>>>  [<ffffffff80230b02>] printk+0x4e/0x56
>>>>>>>>  [<ffffffff803eb84a>] device_add+0x9b/0x483
>>>>>>>>  [<ffffffff8036a876>] kobject_init+0x41/0x69
>>>>>>>>  [<ffffffff803f059d>] _request_firmware+0x169/0x324
>>>>>>>>  [<ffffffffa00e9a7e>] :xc5000:xc_load_fw_and_init_tuner+0x64/0x293
>>>>>>>>  [<ffffffff804a7222>] i2c_transfer+0x75/0x7f
>>>>>>>>  [<ffffffffa00e53ad>] :s5h1409:s5h1409_writereg+0x51/0x83
>>>>>>>>  [<ffffffffa00e9cea>] :xc5000:xc5000_init+0x3d/0x6f
>>>>>>>>  [<ffffffffa0091b0c>] :dvb_core:dvb_frontend_init+0x49/0x63
>>>>>>>>  [<ffffffffa0092e2c>] :dvb_core:dvb_frontend_thread+0x78/0x2f0
>>>>>>>>  [<ffffffffa0092db4>] :dvb_core:dvb_frontend_thread+0x0/0x2f0
>>>>>>>>  [<ffffffff80240eaf>] kthread+0x47/0x74
>>>>>>>>  [<ffffffff8022bc41>] schedule_tail+0x27/0x5b
>>>>>>>>  [<ffffffff8020be18>] child_rip+0xa/0x12
>>>>>>>>  [<ffffffff80240e68>] kthread+0x0/0x74
>>>>>>>>  [<ffffffff8020be0e>] child_rip+0x0/0x12
>>>>>>>>
>>>>>>>> fw_register_device: device_register failed
>>>>>>>> xc5000: Upload failed. (file not found?)
>>>>>>>> xc5000: Unable to initialise tuner
>>>>>>>>
>>>>>>>>
>>>>>>>> I have the firmware file located here:
>>>>>>>>
>>>>>>>> # ls -l /lib/firmware/dvb-fe-xc5000-1.1.fw
>>>>>>>> -rw-r--r-- 1 root root 12332 Aug 31 12:56
>>>>>>>> /lib/firmware/dvb-fe-xc5000-1.1.fw
>>>>>>>>
>>>>>>>> If there is anything else I can provide (or try) to help debug, let
>>>>>>>> me
>>>>>>>> know,
>>>>>>>> ...Patrick
>>>>>>>
>>>>>>>  > kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
>>>>>>>  > register things with the same name in the same directory.
>>>>>>>
>>>>>>> Ooh, that's nasty problem, this is new - and looks like it's i2c
>>>>>>> related.
>>>>>>>
>>>>>>> Why does this sound familiar? Anyone?
>>>>>>
>>>>>> A cx18 user had a similar problem on one distro.  I remeber running it
>>>>>> down to a race condition in creating device nodes in one of the
>>>>>> "virtual" filesystems (/proc or /sys) the device was looking for a
>>>>>> paretn PCI device entry to hook onto, but it wasn't created at the
>>>>>> time
>>>>>> so it tries to create it itself.  In the meantime some other part of
>>>>>> the
>>>>>> kernel subsystem did actually finish creating the entry - so it exists
>>>>>> by the time the firmware load tries to make it.
>>>>>>
>>>>>> As far as I could tell, it should be non-fatal (not an Oops or panic),
>>>>>> but if the driver gives up on -EEXIST then things won't work
>>>>>> obviously.
>>>>>>
>>>>>> I never resolved the problem for the user.  I think some kernel change
>>>>>> outside of cx18 resolved it.  That's all the details I have.
>>>>>>
>>>>>> Regards,
>>>>>> Andy
>>>>>>
>>>>> So what are my options?
>>>>
>>>> Good question.  I don't know.  Working with kobjects is way out of my
>>>> knowledge base.
>>>>
>>>> I looked at the kernel code long enough to decide that without being
>>>> able to reproduce the problem myself, I won't be able to spot the root
>>>> cause.  Part of the reason is that this problem is about looking for and
>>>> creating sysfs objects as it relates to driver probing and firmware
>>>> loading.  I couldn't quite sort out what had to happen in series and
>>>> what the kernel could be executing in parallel.
>>>>
>>>> I think your best option would be to post to the LKML or wherever else
>>>> the sysfs and kobject experts hang out.
>>>>
>>>> Another option could be to modify the driver code that gives up when the
>>>> firmware operation returns an error code because a sysfs device node
>>>> already exists (-EEXIST).  That's no big deal, and a driver should be
>>>> able to merrily go forward, if it can easily detect the condition.
>>>>
>>>>
>>> More observations before I go bother people LKML.  This is the error
>>> with an older 2.6.25 kernel.  The dmesg output is more interesting.
>>>
>>>
>>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
>>>
>>>
>>> sysfs: duplicate filename 'i2c-1' can not be created
>>>
>>>
>>
>> Patrick,
>>
>> This particular issue may have been fixed by my recent xc5000 patches
>> that were merged into the master branch a few days ago...
>>
>> Try pulling the v4l-dvb master branch -- that might help.
>>
>> HTH,
>>
>> Mike
>
> No change.  Same error.  Just to confirm I'm up to date, this is an output
> of "hg heads" for what I pulled in.
>
> changeset:   8964:e5ca4534b543
> tag:         tip
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Tue Sep 09 08:29:56 2008 -0700
> summary:     s2255drv field count fix
>
> changeset:   8924:c793bb42e052
> user:        Steven Toth <stoth@linuxtv.org>
> date:        Tue Sep 09 10:52:06 2008 -0400
> summary:     cx23885: Fix for HVR1500Q eeprom offset decoding


Patrick -- DO NOT TOP-POST.  Replies shall appear below the quoted
text -- that is the policy on this mailing list.

You are not actually running the code that I suggested you try.  If
you have two heads, then only one of them is active.  Do:

hg merge

make commit

(enter some bogus commit message, like "merge from master" or
something, then save the file and exit)

do hg heads again and see your single commit, then rebuild your tree
and try again.

Just to clarify:  I only *suspect* that my recent changes may help to
avoid the issue that you see -- those changes address an unrelated
issue, but this fix is a possible side-effect.

Good Luck.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
