Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:39655 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZK2Rhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 12:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <20091129171437.GA4993@kroah.com>
References: <20091127013217.7671.32355.stgit@terra>
	 <20091127013423.7671.36546.stgit@terra>
	 <20091129171437.GA4993@kroah.com>
Date: Sun, 29 Nov 2009 12:37:36 -0500
Message-ID: <9e4733910911290937v7795da49q613c172b2cc9d13c@mail.gmail.com>
Subject: Re: [IR-RFC PATCH v4 2/6] Core IR module
From: Jon Smirl <jonsmirl@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 12:14 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 26, 2009 at 08:34:23PM -0500, Jon Smirl wrote:
>> Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.
>>
>> Received IR messages generate event in the input queue.
>> IR messages are sent using an input IOCTL.
>
> As you are creating new sysfs files here, please document them in
> Documentation/ABI/

This code is not going to get merged as is. It's just a starting point
to get a discussion started about designing an IR subsystem. I expect
the final design will look a lot different.

I'm trying to demonstrate that IR is an input device and that it can
be supported by the Linux input subsystem without the need to create a
special IR device.

-- 
Jon Smirl
jonsmirl@gmail.com
