Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35312 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2EHKqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 06:46:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3P00EQU9XJ7E40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 May 2012 11:46:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3P00M889X7W4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 May 2012 11:46:19 +0100 (BST)
Date: Tue, 08 May 2012 12:46:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v4 10/12] V4L: Add auto focus targets to the selections
 API
In-reply-to: <4FA6C155.6030100@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4FA8F977.8020707@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
 <1336156337-10935-11-git-send-email-s.nawrocki@samsung.com>
 <4FA6C155.6030100@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari!

On 05/06/2012 08:22 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the patch.
> 
> Sylwester Nawrocki wrote:
>> The camera automatic focus algorithms may require setting up
>> a spot or rectangle coordinates or multiple such parameters.
>>
>> The automatic focus selection targets are introduced in order
>> to allow applications to query and set such coordinates. Those
>> selections are intended to be used together with the automatic
>> focus controls available in the camera control class.
> 
> Have you thought about multiple autofocus windows, and how could they be
> implemented on top of this patch?
> 
> I'm not saying that we should implement them now, but at least we should
> think how we _would_ implement them when needed. They aren't that exotic
> functionality these days after all.
> 
> I'd guess this would involve an additional bitmask control and defining
> a set of new targets. A comment in the source might help here ---
> perhaps a good rule is to start new ranges at 0x1000 as you're doing
> already.

There was also an idea to convert part of the reserved[] field to a window
index IIRC. Not sure which approach is better. I didn't want to make any
assumptions about features I don't have exact knowledge about, neither that
I currently need. The large offset in the auto focus target is to better
indicate they are really different than current selection targets we have,
I also had in mind reserving a target pool for AF targets as you are
pointing out.
That said I'm not really sure right now what additional exact comments
would need to be added.
Hopefully there isn't anything blocking further expansion in this patches.

I didn't decided yet if I want to send this selection/auto focus patches
out for v3.5. I'm also considering dropping just the V4L2_AUTO_FOCUS_AREA
control from "12/12 V4L: Add camera auto focus controls" patch this time.

The bitmask control for multiple windows selection makes a lot of sense
to me. I suppose it would be better to use an additional 'index' field
in the selection data structures for AF window selection.

>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
>>  .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
>>  include/linux/videodev2.h                          |    5 +++
>>  3 files changed, 48 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
>> index b299e47..490d29a 100644
>> --- a/Documentation/DocBook/media/v4l/selection-api.xml
>> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
>> @@ -1,6 +1,6 @@
>>  <section id="selection-api">
>>  
>> -  <title>Experimental API for cropping, composing and scaling</title>
>> +  <title>Experimental selections API</title>
>>  
>>        <note>
>>  	<title>Experimental</title>
>> @@ -9,6 +9,10 @@
>>  interface and may change in the future.</para>
>>        </note>
>>  
>> + <section>
>> +
>> + <title>Image cropping, composing and scaling</title>
>> +
>>    <section>
>>      <title>Introduction</title>
>>  
>> @@ -321,5 +325,32 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
>>        </example>
>>  
>>     </section>
>> + </section>
>> +
>> +   <section>
>> +     <title>Automatic focus regions of interest</title>
>> +
>> +<para> The camera automatic focus algorithms may require configuration of
>> +regions of interest in form of rectangle or spot coordinates. The automatic
>> +focus selection targets allow applications to query and set such coordinates.
>> +Those selections are intended to be used together with the
>> +<constant>V4L2_CID_AUTO_FOCUS_AREA</constant> <link linkend="camera-controls">
>> +camera class</link> control. The <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL
>> +</constant> target is used for querying or setting actual spot or rectangle
>> +coordinates, while <constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant> target
>> +determines bounds for a single spot or rectangle.
>> +These selections are only effective when the <constant>V4L2_CID_AUTO_FOCUS_AREA
>> +</constant>control is set to <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> or
>> +<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
>> +be accepted and applied to hardware when the focus area control value is
>> +changed and also during a &VIDIOC-S-SELECTION; ioctl call, only when the focus
>> +area control is already set to required value.</para>
>> +
>> +<para> For the <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> case, the selection
>> +rectangle <structfield> width</structfield> and <structfield>height</structfield>
>> +are not used, i.e. shall be set to 0 by applications and ignored by drivers for
>> +the &VIDIOC-S-SELECTION; ioctl and shall be ignored by applications for the
>> +&VIDIOC-G-SELECTION; ioctl.</para>
>> +   </section>
>>  
>>  </section>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>> index bb04eff..87df4da 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>> @@ -195,6 +195,17 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
>>              <entry>0x0103</entry>
>>              <entry>The active area and all padding pixels that are inserted or modified by hardware.</entry>
>>  	  </row>
>> +	  <row>
>> +            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant></entry>
>> +            <entry>0x1000</entry>
>> +	    <entry>Actual automatic focus rectangle or spot coordinates.</entry>
>> +	  </row>
>> +	  <row>
>> +            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
>> +            <entry>0x1002</entry>
> 
> This should be 0x1001, I believe.

Yeah, thanks for spotting it, I'll fix this.

--

Regards,
Sylwester
