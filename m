Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1F2MX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:23:59 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5TCNxJx029886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 08:23:59 -0400
Message-ID: <4E0B199B.4010008@redhat.com>
Date: Wed, 29 Jun 2011 14:24:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:xawtv3/master] xawtv: reenable its usage with webcam's
References: <E1Qbdw6-0007wL-E8@www.linuxtv.org> <4E0B05F5.1000704@redhat.com> <4E0B1407.8000907@redhat.com>
In-Reply-To: <4E0B1407.8000907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/29/2011 02:01 PM, Mauro Carvalho Chehab wrote:
> Em 29-06-2011 08:01, Hans de Goede escreveu:
>> Hi,
>>
>> On 06/28/2011 07:32 PM, Mauro Carvalho Chehab wrote:
>>> This is an automatic generated email to let you know that the following patch were queued at the
>>> http://git.linuxtv.org/xawtv3.git tree:
>>>
>>> Subject: xawtv: reenable its usage with webcam's
>>> Author:  Mauro Carvalho Chehab<mchehab@redhat.com>
>>> Date:    Tue Jun 28 14:22:55 2011 -0300
>>>
>>> git changeset c28978f3693bc0f40607d0b3e589774b9452608d was requiring that
>>> tuner would be available, in order to allow it to run. Relax the restriction,
>>> in order to allow using xawtv to test webcams, restoring the previous
>>> behavior.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>>
>>>    libng/grab-ng.c |    4 ++--
>>>    1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> ---
>>>
>>> http://git.linuxtv.org/xawtv3.git?a=commitdiff;h=2238f79d9fb2801a3acd114242b437686fa2f0c8
>>>
>>> diff --git a/libng/grab-ng.c b/libng/grab-ng.c
>>> index f5203cc..94f31e8 100644
>>> --- a/libng/grab-ng.c
>>> +++ b/libng/grab-ng.c
>>> @@ -563,9 +563,9 @@ static void *ng_vid_open_auto(struct ng_vid_driver *drv, char *devpath)
>>>            continue;
>>>        }
>>>
>>> -    /* Check caps return this device if it can capture and has a tuner */
>>> +    /* Check caps return this device if it can capture */
>>>        caps = drv->capabilities(handle);
>>> -    if ((caps&   CAN_CAPTURE)&&   (caps&   CAN_TUNE))
>>> +    if (caps&   CAN_CAPTURE)
>>>            break;
>>>
>>>        drv->close(handle);
>>>
>>
>> Hmm, this changes the behavior from what I intended, the idea was to select the
>> first *tv-card*, without checking for a tuner, there is little value in the auto
>> device feature. Granted it will still skip v4l2 output only devices but those are
>> very rare.
>
> Your patch broke support for vivi and for video grabber devices. Those devices don't
> have a tuner.
>

I did no such thing as "break support". The new xawtv will still work fine with
them with an explicit "-c /dev/video#" argument.

>> Note that only the xawtv binary is using a device value of "auto" by default,
>> the webcam tool still defaults to /dev/video0
>
> It is not "by default", as there's was way to override the CAN_TUNE check logic.
> calling xawtv without my changes with vivi or a webcam would simply return as if
> there's no supported V4L device.
>

One can override the CAN_TUNE logic quite simply, revert your patch and do:
xawtv -c /dev/video#

On a device without a tuner, and it will work fine, if you don't specify the
device and don't have a device with a tuner you will get the following error:
vid-open: could not find a suitable videodev

Which sounds like a sane error for a tv viewing app when it cannot find
a tv-card. Granted, maybe the error should be changed to:
vid-open: could not find a suitable tv-card

To make things even more clear.

This is only the default behavior, and in *no way* have I *broken* use
with a webcam, simply doing:
xawtv -c /dev/video#

Will work fine with any device which worked before as can been clearly
seen from the new code:

+#ifdef __linux__
+    if (!strcmp(*device, "auto")) {
+        char devpath[PATH_MAX];
+	*handle = ng_vid_open_auto(drv, devpath);
+	if (*handle == NULL) {
+	    fprintf(stderr, "vid-open: could not find a suitable videodev\n");
+	    return NULL;
+	}
+	*device = strdup(devpath);
+    } else
+#endif
+    {
+	if (ng_debug)
+	    fprintf(stderr,"vid-open: trying: %s... \n", drv->name);
+	if (!(*handle = (drv->open)(*device))) {
+	    fprintf(stderr,"vid-open: failed: %s\n", drv->name);
+	    return NULL;
+	}
+	if (ng_debug)
+	    fprintf(stderr,"vid-open: ok: %s\n", drv->name);
      }


Specify anything other then auto and the code you've changed simply does
not get called.

>> Given that xawtv is specifically meant for tv-cards (unlike the webcam tool)
>> failing if it cannot find a tv-card and no device is explicitly specified seems
>> reasonable.
>
> Well, xawtv ever worked also with webcams, and with the libv4l, it is now
> working even better. I don't see any reason why removing such support for it.
>

Again I did not remove support for that, you should have studied my patch /
the problem a bit better before making such claims.

> Btw, with the changes I've made, the TV-specific controls are now removed if
> the device is a grabber or a webcam.

Nice!

> There's currently just one detail to be
> fixed: the window title will be changed to "???" on those devices. This is an
> old bug, as changing from Television to S-Video or Composite, on a device that
> has both tuner and grabber capabilities, it will still keep the channel name
> there. It probably makes sense to print there the input name instead, if the
> input is not Television.

Agreed.

>> Alternatively we could make the desired caps a param too ng_vid_open_auto
>> and first try with (CAN_CAPTURE | CAN_TUNE) and then retry with only
>> CAN_CAPTURE.
>
> A logic like that would be better, although, IMO, we should print a message
> saying that we're not using video0. Also, if we're willing to do such logic,
> it makes sense to implement the auto mode also for "scantv".
>

Why should we print a message that we're not using video0? In the modern
dynamic device discovery world, the # in /dev/video# is as good as meaningless.

>> The above patch definitely is not what I had in mind. My system has a
>> bt878 tv card, and a varying number of webcams connected, thus constantly
>> changing the /dev/video# for the tv-card. The intent of my "auto" device
>> patches was to make xawtv automatically pick the tvcard.
>
> Well, a varying device for /dev/video is something that we need to fix at udev.
> There are some ways to create persistent rules for that.
>
> In a matter of fact, IMO, we should change the V4L2 device nodes reported via
> udev, to be more intuitive, e. g. instead of creating /dev/video for everything,
> create /dev/webcam? /dev/grabber? /dev/analog_tv? device nodes, while creating
> a symlink to /dev/video, in order to not break existing applications that have
> it hardcoded.

That sounds like a good idea, but first needs to be written and then make its
way into distributions, I wanted something which would improve the user experience
right now, rather then in 2 years.

>> I intented to mail you about my get_media_devices fixes as well as my
>> auto device patches, and suggest that we do a new release soon.
>
> Yes, I think we should make a release for it soon. There are enough features
> added on xawtv that justifies doing a new release.
>

Agreed,

Regards,

Hans
