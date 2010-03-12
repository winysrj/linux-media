Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab0CLPyk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 10:54:40 -0500
Message-ID: <4B9A63FA.80102@redhat.com>
Date: Fri, 12 Mar 2010 16:55:38 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
CC: hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l-utils: i2c-id.h and alevt
References: <201003090848.29301.hverkuil@xs4all.nl> <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>
In-Reply-To: <4B98FABB.1040605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/11/2010 03:14 PM, Douglas Schilling Landgraf wrote:
> On 03/10/2010 02:04 AM, hermann pitton wrote:
>> Hi Hans, both,
>>
>> Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
>>> It's nice to see this new tree, that should be make it easier to develop
>>> utilities!
>>>
>>> After a quick check I noticed that the i2c-id.h header was copied from the
>>> kernel. This is not necessary. The only utility that includes this is v4l2-dbg
>>> and that one no longer needs it. Hans, can you remove this?
>>>


I somehow missed the original mail from Hans Verkuil here, so I'm replying here,
sorry for messing up the threading.

Fixed!

Regards,

Hans
