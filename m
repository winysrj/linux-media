Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33551 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2AAQtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 11:49:17 -0500
Received: by eekc4 with SMTP id c4so14775601eek.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jan 2012 08:49:16 -0800 (PST)
Message-ID: <4F008E87.1070706@gmail.com>
Date: Sun, 01 Jan 2012 17:49:11 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-2-git-send-email-snjw23@gmail.com> <20111210103344.GF1967@valkosipuli.localdomain> <4EE36FE1.1080601@gmail.com> <20111231120025.GD3677@valkosipuli.localdomain>
In-Reply-To: <20111231120025.GD3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/31/2011 01:00 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Apologies for my late answer.

No problem, thanks for your comments!

> On Sat, Dec 10, 2011 at 03:42:41PM +0100, Sylwester Nawrocki wrote:
>> Hi Sakari,
>>
>> On 12/10/2011 11:33 AM, Sakari Ailus wrote:
>>> On Sun, Dec 04, 2011 at 04:16:12PM +0100, Sylwester Nawrocki wrote:
>>>> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
>>>> type. In case of boolean control we had values 0 and 1 corresponding
>>>> to manual and automatic focus respectively.
>>>>
>>>> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>>>>   0 - V4L2_FOCUS_MANUAL,
>>>>   1 - V4L2_FOCUS_AUTO,
>>>>   2 - V4L2_FOCUS_AUTO_MACRO,
>>>>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
>>>
>>> I would put the macro mode to a separate menu since it's configuration for
>>> how the regular AF works rather than really different mode.
>>
>> Yes, makes sense. Most likely there could be also continuous macro auto focus..
>> I don't have yet an idea what could be a name for that new menu though.
> 
> V4L2_CID_FOCUS_AUTO_DISTANCE? It could then have choices FULL or MACRO.

How about V4L2_CID_FOCUS_AUTO_SCAN_RANGE ? Which would then have choices:
	NORMAL,
	MACRO,
	INFINITY
?

>> Many Samsung devices have also something like guided auto focus, where the
>> application can specify location in the frame for focusing on. IIRC this could
>> be also single-shot or continuous. So it could make sense to group MACRO and
>> "guided" auto focus in one menu, what do you think ?
> 
> I think it could be a separate menu. It's not connected to the distance

OK, let me summarize

* controls for starting/stopping auto focusing (V4L2_CID_FOCUS_AUTO == false)

  V4L2_CID_START_AUTO_FOCUS (button) - start auto focusing,
  V4L2_CID_STOP_AUTO_FOCUS  (button) - stop auto focusing (might be also
                                       useful in V4L2_FOCUS_AUTO == true),
* auto focus status

  V4L2_CID_AUTO_FOCUS_STATUS (menu, read-only) - whether focusing is in
                                                 progress or not,
  possible entries:

  - V4L2_AUTO_FOCUS_STATUS_IDLE,    // auto focusing not enabled or force stopped
  - V4L2_AUTO_FOCUS_STATUS_BUSY,    // focusing in progress
  - V4L2_AUTO_FOCUS_STATUS_SUCCESS, // single-shot auto focusing succeed
                                    // or continuous AF in progress
  - V4L2_AUTO_FOCUS_STATUS_FAIL,    // auto focusing failed


* V4L2_CID_FOCUS_AUTO would retain its current semantics:

  V4L2_CID_FOCUS_AUTO (boolean) - selects auto/manual focus
      false - manual
      true  - auto continuous

* AF algorithm scan range, V4L2_CID_FOCUS_AUTO_SCAN_RANGE with choices:

  - V4L2_AUTO_FOCUS_SCAN_RANGE_NORMAL,
  - V4L2_AUTO_FOCUS_SCAN_RANGE_MACRO,
  - V4L2_AUTO_FOCUS_SCAN_RANGE_INFINITY


New menu control to choose behaviour of auto focus (either single-shot
or continuous):

* select auto focus mode

V4L2_CID_AUTO_FOCUS_MODE
        V4L2_AUTO_FOCUS_MODE_NORMAL     - "normal" auto focus (whole frame?)
        V4L2_AUTO_FOCUS_MODE_SPOT       - spot location passed with other
                                          controls or selection API
        V4L2_AUTO_FOCUS_MODE_RECTANGLE  - rectangle passed with other
                                          controls or selection API


> parameter. We also need to discuss how the af statistics window
> configuration is done. I'm not certain there could even be a standardised

Do we need multiple windows for AF statistics ?

If not, I'm inclined to use four separate controls for window configuration.
(X, Y, WIDTH, HEIGHT). This was Hans' preference in previous discussions [1].

> interface which could be used to control it all.


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg25647.html

-- 
Regards,
Sylwester
