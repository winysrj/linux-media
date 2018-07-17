Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47959 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731117AbeGQMan (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 08:30:43 -0400
Subject: Re: [PATCHv6 02/12] media-ioc-g-topology.rst: document new 'index'
 field
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
 <20180710084512.99238-3-hverkuil@xs4all.nl>
 <20180713122334.68661b55@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a0f914f6-d165-f63b-1e0c-2bc107c3bf17@xs4all.nl>
Date: Tue, 17 Jul 2018 13:58:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180713122334.68661b55@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/07/18 17:23, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Jul 2018 10:45:02 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Document the new struct media_v2_pad 'index' field.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  .../media/uapi/mediactl/media-ioc-g-topology.rst     | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> index a3f259f83b25..bae2b4db89cc 100644
>> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>> @@ -176,7 +176,7 @@ desired arrays with the media graph elements.
>>      *  -  struct media_v2_intf_devnode
>>         -  ``devnode``
>>         -  Used only for device node interfaces. See
>> -	  :c:type:`media_v2_intf_devnode` for details..
>> +	  :c:type:`media_v2_intf_devnode` for details.
>>  
>>  
>>  .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
>> @@ -218,7 +218,15 @@ desired arrays with the media graph elements.
>>         -  Pad flags, see :ref:`media-pad-flag` for more details.
>>  
>>      *  -  __u32
>> -       -  ``reserved``\ [5]
>> +       -  ``index``
>> +       -  Pad index, starts at 0. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
>> +	  returns true. The ``media_version`` is defined in struct
>> +	  :c:type:`media_device_info` and can be retrieved using
>> +	  :ref:`MEDIA_IOC_DEVICE_INFO`. Pad indices are stable. If new pads are added
>> +	  for an entity in the future, then those will be added at the end.
> 
> Hmm... Pad indexes may not be stable. That's by the way why we
> need a better way to enum it, and the Properties API was thinking
> to solve (and why we didn't add PAD index to this ioctl at the
> first place). 
> 
> The problem happens for example on TV demods and tuners:
> different models may have different kinds of output PADs:
> 
> 	- analog luminance carrier samples;
> 	- analog chrominance sub-carrier samples;
> 	- sliced VBI data;
> 	- audio RF sub-carrier samples;
> 	- audio mono data;
> 	- audio stereo data.
> 
> The same bridge chip can live with different demods, but need to
> setup the pipelines according with the type of the PAD. As right now
> we don't have any way to associate a PAD with an specific type of
> output, what happens is that the V4L2 core associates a pad number
> with an specific type of output. So, drivers may be exposing
> PADs that don't exist, in practice, just to make them compatible
> with similar subdevs.
> 
> Once we add a properties API (or something equivalent), the
> PAD numbers will change and subdevs will only expose the ones
> that really exists.

So what do you suggest I do? There are two things here: you need the
pad index in order to use the SETUP_LINK ioctl, so adding this to
G_TOPOLOGY makes sense. The second is whether or not pad numbers
are stable. Currently they are, since there is no other way to
associate a pad with the type of signal it can carry.

Note that the index is already exposed with the older API, so changing
the pad index in the future will already potentially cause problems.

I am inclined to just remove the last two sentences of the description
above, so this becomes:

+       -  Pad index, starts at 0. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
+	  returns true. The ``media_version`` is defined in struct
+	  :c:type:`media_device_info` and can be retrieved using
+	  :ref:`MEDIA_IOC_DEVICE_INFO`.

And we'll figure out what to do with this once we finally get properties.

That's something I might actually work on myself, but not before we get
the current API consistent.

Regards,

	Hans
