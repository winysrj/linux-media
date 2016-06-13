Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:54646 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbcFMQlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 12:41:09 -0400
Subject: Re: [PATCH v3 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1464799192-28034-1-git-send-email-nick.dyer@itdev.co.uk>
 <20160601181700.GD4114@dtor-ws>
 <d8c40054-359c-5e21-6c1f-be38fd2368db@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <65c7873a-439d-fc84-50b4-f63a7934e9db@itdev.co.uk>
Date: Mon, 13 Jun 2016 17:40:52 +0100
MIME-Version: 1.0
In-Reply-To: <d8c40054-359c-5e21-6c1f-be38fd2368db@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2016 16:14, Nick Dyer wrote:
> On 01/06/2016 19:17, Dmitry Torokhov wrote:
>> On Wed, Jun 01, 2016 at 05:39:44PM +0100, Nick Dyer wrote:
>>> This is a series of patches to add diagnostic data support to the Atmel
>>> maXTouch driver. It's a rewrite of the previous implementation which output via
>>> debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.
>>
>> I do not have any objections other than some nits form the input side;
>> majority of the review should come from V4L2 side here...
> 
> Thanks for the review. I've hopefully fixed the issues you raised and
> pushed it to
>     https://github.com/ndyer/linux/commits/diagnostic-v4l-20160602
> 
> I will wait for the V4L2 folks to comment before posting a [PATCH v4]

Hi Hans-

I've done a bit of further work on this now, so unless you have any
conerns, I'm going to post an update to the patch set in the next couple of
days.

cheers

Nick
