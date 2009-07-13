Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55078 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbZGMV5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 17:57:54 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 13 Jul 2009 16:57:48 -0500
Subject: RE: Control IOCTLs handling
Message-ID: <A69FA2915331DC488A831521EAE36FE40144E4B8E8@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
 <200907132334.14309.hverkuil@xs4all.nl>
In-Reply-To: <200907132334.14309.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

<snip>

>> #define VIDIOC_S_EXT_CTRLS	_IOWR('V', 72, struct v4l2_ext_controls)
>> #define VIDIOC_TRY_EXT_CTRLS	_IOWR('V', 73, struct
>v4l2_ext_controls)
>>
>> Currently they are implemented using proprietary ioctls.
>
>Do you mean proprietary ioctls or proprietary controls? Here you talk about
>ioctls where below you suddenly refer to 'control IDs'.
>

I am referring to the proprietary ioctl (experimental) that we added in vpfe capture patch.

Murali

