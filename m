Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58798 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbbJLLwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 07:52:43 -0400
Message-ID: <561B9E97.4050909@xs4all.nl>
Date: Mon, 12 Oct 2015 13:50:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Hans Verkuil <hansverk@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 06/15] rc: Add HDMI CEC protocol handling
References: <cover.1441633456.git.hansverk@cisco.com> <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com> <20151006180540.GR21513@n2100.arm.linux.org.uk>
In-Reply-To: <20151006180540.GR21513@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2015 08:05 PM, Russell King - ARM Linux wrote:
> On Mon, Sep 07, 2015 at 03:44:35PM +0200, Hans Verkuil wrote:
>> From: Kamil Debski <kamil@wypas.org>
>>
>> Add handling of remote control events coming from the HDMI CEC bus.
>> This patch includes a new keymap that maps values found in the CEC
>> messages to the keys pressed and released. Also, a new protocol has
>> been added to the core.
>>
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> (Added Mauro)
> 
> Hmm, how is rc-cec supposed to be loaded?

Is CONFIG_RC_MAP enabled in your config? Ran 'depmod -a'? (Sorry, I'm sure you've done
that, just checking...)

It's optional as I understand it, since you could configure the keytable from
userspace instead of using this module.

For the record (just tried it), it does load fine on my setup.

BTW, I am still on the fence whether using the kernel RC subsystem is the
right thing to do. There are a number of CEC RC commands that use extra parameters
that cannot be mapped to the RC API, so you still need to handle those manually.

I know Mauro would like to see this integration, but I am wondering whether it
really makes sense.

What is your opinion on this?

Perhaps I should split it off into a separate patch and keep it out from the initial
pull request once we're ready for that.

Regards,

	Hans

> 
> At boot, I see:
> 
> [   16.577704] IR keymap rc-cec not found
> [   16.586675] Registered IR keymap rc-empty
> [   16.591668] input: RC for dw_hdmi as /devices/soc0/soc/120000.hdmi/rc/rc1/input3
> [   16.597769] rc1: RC for dw_hdmi as /devices/soc0/soc/120000.hdmi/rc/rc1
> 
> Yet the rc-cec is a module in the filesystem, but it doesn't seem to
> be loaded automatically - even after the system has booted, the module
> hasn't been loaded.
> 
> It looks like it _should_ be loaded, but this plainly isn't working:
> 
>         map = seek_rc_map(name);
> #ifdef MODULE
>         if (!map) {
>                 int rc = request_module("%s", name);
>                 if (rc < 0) {
>                         printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
>                         return NULL;
>                 }
>                 msleep(20);     /* Give some time for IR to register */
> 
>                 map = seek_rc_map(name);
>         }
> #endif
>         if (!map) {
>                 printk(KERN_ERR "IR keymap %s not found\n", name);
>                 return NULL;
>         }
> 
> Any ideas?
> 

