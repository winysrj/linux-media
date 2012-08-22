Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758810Ab2HVJqn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 05:46:43 -0400
Message-ID: <5034AAC5.4050306@redhat.com>
Date: Wed, 22 Aug 2012 11:47:49 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: Core + Radio profile
References: <201208221140.25656.hverkuil@xs4all.nl>
In-Reply-To: <201208221140.25656.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/22/2012 11:40 AM, Hans Verkuil wrote:
> Hi all!
>

<Snip>

> While writing down these profiles I noticed one thing that was very much
> missing for radio devices: there is no capability bit to tell the application
> whether there is an associated ALSA device or whether the audio goes through
> a line-in/out. Personally I think that this should be fixed.

The question with generic tuner drivers like the tea57XX series is do we always
know this ?

One could argue to proper way to find this out for applications is by looking
at the device topology, either through the media controller framework, or
through sysfs. This is for example what xawtv currently does. We need a better
library to handle this, which also hides from the user whether the media controller
or sysfs is used.

 > Comments are welcome!

Looks good!

Regards,

Hans
