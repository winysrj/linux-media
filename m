Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1077 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaCMMTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 08:19:47 -0400
Message-ID: <5321A22D.3030505@xs4all.nl>
Date: Thu, 13 Mar 2014 13:18:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 20/35] DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-21-git-send-email-hverkuil@xs4all.nl> <20140312112000.54ffb496@samsung.com>
In-Reply-To: <20140312112000.54ffb496@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/14 15:20, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Feb 2014 10:57:35 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Document the support for the new complex type controls.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 43 ++++++++++++++++++----
>>  1 file changed, 35 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> index b3bb957..d946d6b 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> @@ -72,23 +72,30 @@ initialize the <structfield>id</structfield>,
>>  <structfield>size</structfield> and <structfield>reserved2</structfield> fields
>>  of each &v4l2-ext-control; and call the
>>  <constant>VIDIOC_G_EXT_CTRLS</constant> ioctl. String controls controls
>> -must also set the <structfield>string</structfield> field.</para>
>> +must also set the <structfield>string</structfield> field. Controls
>> +of complex types (<constant>V4L2_CTRL_FLAG_IS_PTR</constant> is set)
>> +must set the <structfield>p</structfield> field.</para>
> 
> Same notes I did to the other patches apply here:
> 	- s/complex/compound/
> 	- Let's not mix strings with compound types
> 	- etc
> 
>>      <para>If the <structfield>size</structfield> is too small to
>>  receive the control result (only relevant for pointer-type controls
>>  like strings), then the driver will set <structfield>size</structfield>
>>  to a valid value and return an &ENOSPC;. You should re-allocate the
>> -string memory to this new size and try again. It is possible that the
>> -same issue occurs again if the string has grown in the meantime. It is
>> +memory to this new size and try again. For the string type it is possible that
>> +the same issue occurs again if the string has grown in the meantime. It is
>>  recommended to call &VIDIOC-QUERYCTRL; first and use
>>  <structfield>maximum</structfield>+1 as the new <structfield>size</structfield>
>>  value. It is guaranteed that that is sufficient memory.
>>  </para>
>>  
>> +    <para>Matrices are set and retrieved row-by-row. You cannot set a partial
>> +matrix, all elements have to be set or retrieved. The total size is calculated
>> +as <structfield>rows</structfield> * <structfield>cols</structfield> * <structfield>elem_size</structfield>.
>> +These values can be obtained by calling &VIDIOC-QUERY-EXT-CTRL;.</para>
>> +
>>      <para>To change the value of a set of controls applications
>>  initialize the <structfield>id</structfield>, <structfield>size</structfield>,
>>  <structfield>reserved2</structfield> and
>> -<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
>> +<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
>>  call the <constant>VIDIOC_S_EXT_CTRLS</constant> ioctl. The controls
>>  will only be set if <emphasis>all</emphasis> control values are
>>  valid.</para>
>> @@ -96,11 +103,17 @@ valid.</para>
>>      <para>To check if a set of controls have correct values applications
>>  initialize the <structfield>id</structfield>, <structfield>size</structfield>,
>>  <structfield>reserved2</structfield> and
>> -<structfield>value/string</structfield> fields of each &v4l2-ext-control; and
>> +<structfield>value/value64/string/p</structfield> fields of each &v4l2-ext-control; and
>>  call the <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctl. It is up to
>>  the driver whether wrong values are automatically adjusted to a valid
>>  value or if an error is returned.</para>
>>  
>> +    <para>For matrices it is possible to only set or check only the first
>> +<constant>X</constant> elements by setting size to <constant>X * elem_size</constant>,
>> +where <structfield>elem_size</structfield> is obtained by calling &VIDIOC-QUERY-EXT-CTRL;.
>> +Matrix elements are set row-by-row. Matrix elements that are not explicitly
>> +set will be initialized to their default value.</para>
>> +
> 
> That sounds confusing: what are the defaults?
> 
> Also, what happens if the size is set to, let's say, 1,5 * elem_size?
> 
> Will it fill one element, will it return an error (what error?) or will it
> fill two elements, the second one with some wrong value?

I would have to double-check but I think this may be a left-over from an earlier
version. I think the text is wrong and that you always have to set the full
matrix, for pretty much the reasons you mentioned as well. I've played around
with it, originally even being able to set a sub-matrix within the full matrix,
but you run into all sorts of complexities. For now the requirement is that
you set all values at once, later this might be relaxed but we need to have
a much better understanding of such use-cases.

Regards,

	Hans
