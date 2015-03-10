Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55912 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbbCJOuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 10:50:05 -0400
Message-ID: <54FF0494.9060703@xs4all.nl>
Date: Tue, 10 Mar 2015 15:49:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/18] marvell-ccic + ov7670 fixes
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl> <20150310103000.7d79bb7f@lwn.net>
In-Reply-To: <20150310103000.7d79bb7f@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2015 03:30 PM, Jonathan Corbet wrote:
> On Mon,  9 Mar 2015 22:22:05 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> This patch series makes loads of fixes and improvements to the marvell-ccic
>> and ov7670 drivers. This has been tested on an OLPC XO-1 laptop.
> 
> So I'm traveling and even shorter on time than usual.  I've had a quick
> look over these patches, and they generally seem OK.  Just don't ding me
> for not using a bunch of infrastructure that wasn't there when I wrote
> this thing! :)
> 
> Ideally it would be nice to see patch 9 split - locking changes separate
> from use of helpers - but that's a quibble.
> 
> Out of curiosity, is there a use driving this work, or are you just
> making things cleaner?

I needed to test my earlier subdev patch series, and since I finally had the
OLPC in a testable state again I thought that was a good opportunity to run
the v4l2-compliance test suite over it. That always generates a lot of failures
when it is run for the first time on a driver. I'm biased since I wrote that
tool, but v4l2-compliance is awesome :-)

As an added bonus this driver is now also converted to the new frameworks.
Eventually all drivers will be converted and we can drop legacy support in the
v4l2 core.

And as a second bonus this was a good reason for me to add support for the
4:2:0 planar formats to the vivid driver, which helped me test the marvell driver.

I've tested all the supported formats and I can confirm that they all work
after this patch series is applied.

> Regardless, it clearly improves the drivers; thanks for doing this.
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> 
>> I do need to check the last patch with Libin Yang since his patch from mid-2013
>> broke the driver for the OLPC laptop. Nobody noticed since the latest released
>> kernel from the OLPC project for that laptop is 3.3, which didn't have his patch.
> 
> Libin seems to have vanished, and I think that whatever interest Marvell
> had in supporting this driver has vanished with him, unfortunately.  I'm
> still tempted to revert much of that work, since I'm not sure it has ever
> worked on a real system...

OK, good to know. I'll try to contact him and if I haven't heard from him by
Monday (or if the email is no longer valid), then I'll make a pull request for
this series to get it in 4.1.

Regards,

	Hans
