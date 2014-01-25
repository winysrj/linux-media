Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1663 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaAYIum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 03:50:42 -0500
Message-ID: <52E37ACA.1050802@xs4all.nl>
Date: Sat, 25 Jan 2014 09:50:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 06/21] v4l2-ctrls: add support for complex types.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-7-git-send-email-hverkuil@xs4all.nl> <20140124154431.GD13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140124154431.GD13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/24/2014 04:44 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 20, 2014 at 01:45:59PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch implements initial support for complex types.
>>
>> For the most part the changes are fairly obvious (basic support for is_ptr
>> types, the type_is_int function is replaced by a is_int bitfield, and
>> v4l2_query_ext_ctrl is added), but one change needs more explanation:
>>
>> The v4l2_ctrl struct adds a 'new' field and a 'stores' array at the end
>> of the struct. This is in preparation for future patches where each control
>> can have multiple configuration stores. The idea is that stores[0] is the current
>> control value, stores[1] etc. are the control values for each configuration store
>> and the 'new' value can be accessed through 'stores[-1]', i.e. the 'new' field.
>> However, for now only stores[-1] and stores[0] is used.
> 
> Could we use zero or positive indices only, e.g. the new being zero and
> current 1, or the other way? Or make the "new" value special, i.e. using a
> different field name.
> 
> I think accessing the previous struct member by index -1 looks a little bit
> hackish.

I should document this better. Drivers are not expected to use the stores array,
it is for internal use in the control framework only as it allows me to refer to
either the new or the current value by just an array index and later also
configuration stores which will start at index 1 and up, which is where this really
becomes important.

I am not yet adding configuration stores to the control framework as there is not
yet a driver that needs it, and it is for the most part a separate issue anyway.
But this generalization of how values can be accessed makes it much easier to
later add support for configuration stores.

>> These new fields use the v4l2_ctrl_ptr union, which is a pointer to a control
>> value.
>>
>> Note that these two new fields are not yet actually used.
> 
> Should they be then added yet in the first place? :-)

Well, they are used a few patches later, but I will see if it makes sense to only
introduce them when they are actually needed.

Regards,

	Hans
