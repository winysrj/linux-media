Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36224 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbaIPAXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 20:23:37 -0400
Message-ID: <54178306.2010203@osg.samsung.com>
Date: Mon, 15 Sep 2014 18:23:34 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: v4l2 ioctls
References: <54124BDC.3000306@osg.samsung.com> <5412A9DB.8080701@xs4all.nl> <20140912121950.7edfee4e.m.chehab@samsung.com> <541391B9.4070708@osg.samsung.com> <20140915085458.1faea714.m.chehab@samsung.com> <54177328.1050007@osg.samsung.com> <20140915205324.1eb58ca8.m.chehab@samsung.com>
In-Reply-To: <20140915205324.1eb58ca8.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2014 05:53 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 15 Sep 2014 17:15:52 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 09/15/2014 05:54 AM, Mauro Carvalho Chehab wrote:
>>> Hi Shuah,
>>>
>>> Em Fri, 12 Sep 2014 18:37:13 -0600
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>
>>>> Mauro/Hans,
>>>>
>>>> Thanks for both for your replies. I finally have it working with
>>>> the following:
>>>
>>> One additional info: While in DVB mode, opening the device in
>>> readonly mode should not take the tuner locking.
>>
>> That's what the code does for dvb. It gets the tuner lock in
>> dvb_frontend_start() which is called from dvb_frontend_open()
>> when dvb is opened in R/W mode.
> 
> Yeah, I think that the FE kthread is only started in R/W mode, 
> but it doesn't hurt to double-check it and to do some tests to
> avoid regressions.

Here is the code snippet:

       if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
                /* normal tune mode when opened R/W */
                fepriv->tune_mode_flags &= ~FE_TUNE_MODE_ONESHOT;
                fepriv->tone = -1;
                fepriv->voltage = -1;

                ret = dvb_frontend_start (fe);
                if (ret)
                        goto err2;

                /*  empty event queue */
                fepriv->events.eventr = fepriv->events.eventw = 0;
        }


I can do some testing to make sure

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
