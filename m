Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1LKQSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 11:18:13 -0500
Received: by bkcjm19 with SMTP id jm19so617024bkc.19
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 08:18:12 -0800 (PST)
Message-ID: <4EE4D7C0.6070903@gmail.com>
Date: Sun, 11 Dec 2011 17:18:08 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	laurent.pinchart@ideasonboard.com
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	riverful.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-2-git-send-email-snjw23@gmail.com> <20111210103344.GF1967@valkosipuli.localdomain>
In-Reply-To: <20111210103344.GF1967@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/2011 11:33 AM, Sakari Ailus wrote:
> On Sun, Dec 04, 2011 at 04:16:12PM +0100, Sylwester Nawrocki wrote:
>> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
>> type. In case of boolean control we had values 0 and 1 corresponding
>> to manual and automatic focus respectively.
>>
>> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>>   0 - V4L2_FOCUS_MANUAL,
>>   1 - V4L2_FOCUS_AUTO,
>>   2 - V4L2_FOCUS_AUTO_MACRO,
>>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
> 
> I would put the macro mode to a separate menu since it's configuration for
> how the regular AF works rather than really different mode.
> 
> ...
> 
>> @@ -567,6 +576,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>  	case V4L2_CID_PRIVACY:			return "Privacy";
>>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>> +	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
> 
> I'd perhaps use "begin" or "start". How does the user learn the autofocus
> has finished? I think this looks like quite similar problem than telling the
> flash strobe status to the user. The solution could also be similar to that.

Hi,

considering your previous comments, how about the below focusing control set ?

Controls for starting/stopping auto focusing (for V4L2_CID_FOCUS_AUTO ==
V4L2_FOCUS_MANUAL):

V4L2_CID_START_AUTO_FOCUS  - (button) - start auto focusing,
V4L2_CID_STOP_AUTO_FOCUS   - (button) - stop auto focusing (might be also
                                        useful in V4L2_FOCUS_AUTO_CONTINUOUS
                                        mode)
and auto focus status:

V4L2_CID_AUTO_FOCUS_STATUS - (boolean) - whether focusing is in progress or not
                             (when V4L2_CID_FOCUS_AUTO == V4L2_FOCUS_MANUAL)


V4L2_CID_FOCUS_AUTO would basically retain it's current semantics:

V4L2_CID_FOCUS_AUTO        - (boolean) - select focus type (manual/auto
                                         continuous)
        V4L2_FOCUS_MANUAL              - manual focus
        V4L2_FOCUS_AUTO_CONTINUOUS     - continuous auto focus
                                         (or V4L2_FOCUS_AUTO)

New menu control to choose behaviour of auto focus (either single-shot
or continuous):

V4L2_CID_AF_MODE                        - select auto focus mode
        V4L2_AF_MODE_NORMAL             - "normal" auto focus
        V4L2_AF_MODE_MACRO              - macro (close-up)
        V4L2_AF_MODE_SPOT               - spot location passed with
                                          selection API or other control
        V4L2_AF_MODE_FACE_DETECTION	- focus point indicated by internal
                                          face detector


I might try it out and implement in M-5MOLS driver, to see how it works
in practice.

Does it make sense for you ?

--

Regards,
Sylwester
