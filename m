Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59796 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2EIKLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 06:11:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3R004MV2Z6SE40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 May 2012 11:11:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3R000442YQSU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 May 2012 11:11:15 +0100 (BST)
Date: Wed, 09 May 2012 12:11:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v4 12/12] V4L: Add camera auto focus controls
In-reply-to: <4FA6C6ED.7020406@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4FAA42C4.9050301@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
 <1336156337-10935-13-git-send-email-s.nawrocki@samsung.com>
 <4FA6C6ED.7020406@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thank you for the comments.

On 05/06/2012 08:46 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the patch,
> 
> Sylwester Nawrocki wrote:
>> Add following auto focus controls:
>>
>>  - V4L2_CID_AUTO_FOCUS_START - single-shot auto focus start
>>  - V4L2_CID_AUTO_FOCUS_STOP -  single-shot auto focus stop
>>  - V4L2_CID_AUTO_FOCUS_STATUS - automatic focus status
>>  - V4L2_CID_AUTO_FOCUS_AREA - automatic focus area selection
>>  - V4L2_CID_AUTO_FOCUS_DISTANCE - automatic focus scan range selection
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml |  147 +++++++++++++++++++++++++-
>>  drivers/media/video/v4l2-ctrls.c             |   31 +++++-
>>  include/linux/videodev2.h                    |   25 +++++
>>  3 files changed, 200 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 4a463d3..d8ef71e 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -2902,13 +2902,156 @@ negative values towards infinity. This is a write-only control.</entry>
>>  	  <row>
>>  	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry>
>>  	    <entry>boolean</entry>
>> -	  </row><row><entry spanname="descr">Enables automatic focus
>> -adjustments. The effect of manual focus adjustments while this feature
>> +	  </row><row><entry spanname="descr">Enables continuous automatic
>> +focus adjustments. The effect of manual focus adjustments while this feature
>>  is enabled is undefined, drivers should ignore such requests.</entry>
>>  	  </row>
>>  	  <row><entry></entry></row>
>>  
>>  	  <row>
>> +	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_START</constant>&nbsp;</entry>
>> +	    <entry>button</entry>
>> +	  </row><row><entry spanname="descr">Starts single auto focus process.
>> +The effect of setting this control when <constant>V4L2_CID_FOCUS_AUTO</constant>
>> +is set to <constant>TRUE</constant> (1) is undefined, drivers should ignore
>> +such requests.</entry>
>> +	  </row>
>> +	  <row><entry></entry></row>
>> +
>> +	  <row>
>> +	    <entry spanname="id"><constant>V4L2_CID_AUTO_FOCUS_STOP</constant>&nbsp;</entry>
>> +	    <entry>button</entry>
>> +	  </row><row><entry spanname="descr">Aborts automatic focusing
>> +started with <constant>V4L2_CID_AUTO_FOCUS_START</constant> control. It is
>> +effective only when the continuous autofocus is disabled, that is when
>> +<constant>V4L2_CID_FOCUS_AUTO</constant> control is set to <constant>FALSE
>> +</constant> (0).</entry>
>> +	  </row>
>> +	  <row><entry></entry></row>
>> +
>> +	  <row id="v4l2-auto-focus-status">
>> +	    <entry spanname="id">
>> +	      <constant>V4L2_CID_AUTO_FOCUS_STATUS</constant>&nbsp;</entry>
>> +	    <entry>bitmask</entry>
>> +	  </row>
>> +	  <row><entry spanname="descr">The automatic focus status. This is a read-only
>> +	  control.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_IDLE</constant>&nbsp;</entry>
>> +		  <entry>Automatic focus is not active.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_BUSY</constant>&nbsp;</entry>
>> +		  <entry>Automatic focusing is in progress.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_REACHED</constant>&nbsp;</entry>
>> +		  <entry>Focus has been reached.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_LOST</constant>&nbsp;</entry>
>> +		  <entry>Focus has been lost.</entry>
> 
> When does this happen?

Hmm, good question. I intended this one for continuous auto focus, for the moments
when the focus  is lost. I felt the control is incomplete without such status bit.

Thinking about it a bit more, it is just a negation of V4L2_AUTO_FOCUS_STATUS_FOCUSED.
The focus lost notifications could be well provided to user space be clearing this bit.

So I would just get rid of V4L2_AUTO_FOCUS_STATUS_LOST, I don't really use it in any 
driver, it was supposed to be just for completeness. 

What do you think ? 

>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_STATUS_FAILED</constant>&nbsp;</entry>
>> +		  <entry>Automatic focus has failed, the driver will not
>> +		  transition from this state until another action is
>> +		  performed by an  application.</entry>
> 
> Which of these are valid for regular autofocus and which ones for
> continuous autofocus? I'm a little bit confused with the above descriptions.

All, except V4L2_AUTO_FOCUS_STATUS_LOST are valid for both auto focus modes.
But I'm going to remove V4L2_AUTO_FOCUS_STATUS_LOST bit, as indicated above.

> I might as well say that temporary conditions such as failed and reached
> would return to idle after being read from user space. This is how the
> flash faults behave, too.

I'm not sure if it would be possible to fulfil such assumption in drivers
in all cases. The status often comes from hardware and the driver might
not be able to change it at will. I'm not sure if it is safe to change 
state just by reading it from user-space. This probably wouldn't work well
with multiple processes accessing the camera. 

For instance, from state V4L2_AUTO_FOCUS_STATUS_FAILED a driver would have 
transitioned to something else after user-space sets V4L2_CID_AUTO_FOCUS_START
control. Also I would prefer having V4L2_AUTO_FOCUS_STATUS_REACHED bit set
as long as the camera stays in this state, regardless of how many status 
readers there are. 

> 
> How does this interact with the 3A lock control?

Setting V4L2_LOCK_FOCUS lock would just stop updates to the status control
value. The 3A lock control is just another one that influences the auto 
focus status, among V4L2_CID_AUTO_FOCUS_START and V4L2_CID_AUTO_FOCUS_STOP.

Nevertheless, I see your point, that it's not clear from the Spec.
How about adding something like this to the AF status control description:

"Setting V4L2_LOCK_FOCUS lock may stop updates of the V4L2_CID_AUTO_FOCUS_STOP
control value."

?

I'm not sure how much detailed the documentation should be, I wouldn't like
to add something that would be hard to implement in drivers, for sake of
the applications' simplicity... :)

>> +		</row>
>> +	      </tbody>
>> +	    </entrytbl>
>> +	  </row>
>> +	  <row><entry></entry></row>
>> +
>> +	  <row id="v4l2-auto-focus-range">
>> +	    <entry spanname="id">
>> +	      <constant>V4L2_CID_AUTO_FOCUS_RANGE</constant>&nbsp;</entry>
>> +	    <entry>enum&nbsp;v4l2_auto_focus_range</entry>
>> +	  </row>
>> +	  <row><entry spanname="descr">Determines auto focus distance range
>> +for which lens may be adjusted. </entry>
>> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_AUTO</constant>&nbsp;</entry>
>> +		  <entry>The camera automatically selects the focus range.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_NORMAL</constant>&nbsp;</entry>
>> +		  <entry>The auto focus normal distance range. It is limited
>> +for best auto focus algorithm performance.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_MACRO</constant>&nbsp;</entry>
>> +		  <entry>Macro (close-up) auto focus. The camera will
>> +use minimum possible distance that it is capable of for auto focus.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_RANGE_INFINITY</constant>&nbsp;</entry>
>> +		  <entry>The focus at an object at infinite distance.</entry>
>> +		</row>
>> +	      </tbody>
>> +	    </entrytbl>
>> +	  </row>
>> +	  <row><entry></entry></row>
>> +
>> +	  <row id="v4l2-auto-focus-area">
>> +	    <entry spanname="id">
>> +	      <constant>V4L2_CID_AUTO_FOCUS_AREA</constant>&nbsp;</entry>
>> +	    <entry>enum&nbsp;v4l2_auto_focus_area</entry>
>> +	  </row>
>> +	  <row><entry spanname="descr">Determines the area of the frame that
>> +the camera uses for automatic focus. The corresponding coordinates of the
>> +focusing spot or rectangle can be specified and queried using the selection API.
>> +To change the auto focus region of interest applications first select required
>> +mode of this control and then set the rectangle or spot coordinates by means
>> +of the &VIDIOC-SUBDEV-S-SELECTION; or &VIDIOC-S-SELECTION; ioctl. In order to
>> +trigger again an auto focus process with same coordinates applications should
>> +use the <constant>V4L2_CID_AUTO_FOCUS_START </constant> control. Or alternatively
>> +invoke a &VIDIOC-SUBDEV-S-SELECTION; or a &VIDIOC-S-SELECTION; ioctl again.
>> +In the latter case the new pixel coordinates are applied to hardware only when
>> +the focus area control is set to a value other than
>> +<constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_ALL</constant>&nbsp;</entry>
>> +		  <entry>Normal auto focus, the focusing area extends over the
>> +entire frame.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant>&nbsp;</entry>
>> +		  <entry>Automatic focus on a spot within the frame at position
>> +specified by the <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or
>> +<constant>V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection. When these
>> +selections are not supported by driver the default spot's position is center of
>> +the frame.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>&nbsp;</entry>
>> +		  <entry>The auto focus area is determined by the <constant>
>> +V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> or <constant>
>> +V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant> selection rectangle.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_AUTO_FOCUS_AREA_FACE_DETECTION</constant>&nbsp;</entry>
>> +		  <entry>The camera automatically focuses on a detected face
>> +area.</entry>
> 
> I assume there could be one or more faces to focus to, right?

Indeed, I presume we're going to need another set of controls for Face Detection 
features.
 
That's true, there can be more faces. I wasn't good enough at expressing this
here :(

Maybe something like:

"The camera automatically focuses on the face detection regions."

would be better ?


-- 
Regards,
Sylwester Nawrocki
