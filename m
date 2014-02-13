Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4726 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaBMJv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 04:51:27 -0500
Message-ID: <52FC94C0.5000904@xs4all.nl>
Date: Thu, 13 Feb 2014 10:47:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 43/47] adv7604: Control hot-plug detect through a GPIO
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-44-git-send-email-laurent.pinchart@ideasonboard.com> <52F9F6DB.1080700@xs4all.nl> <1637754.DCKyOCpBtn@avalon>
In-Reply-To: <1637754.DCKyOCpBtn@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/14 13:03, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 11 February 2014 11:09:31 Hans Verkuil wrote:
>> On 02/05/14 17:42, Laurent Pinchart wrote:
>>> Replace the ADV7604-specific hotplug notifier with a GPIO to control the
>>> HPD pin directly instead of going through the bridge driver.
>>
>> Hmm, that's not going to work for me. I don't have a GPIO pin here, instead
>> it is a bit in a register that I have to set.
> 
> But that bit controls a GPIO, doesn't it ? In that case it should be exposed 
> as a GPIO controller.

I feel unhappy about losing this notifier for two reasons: first adding a GPIO
controller just to toggle a bit adds 40 lines to my driver, and that doesn't
sit well with me. It's basically completely unnecessary overhead.

The second reason is that in some cases you want to do something in addition
to just toggling the hotplug pin. In particular for CEC support this could be
quite useful.

In fact, if the adv7604 supports the ARC feature (Audio Return Channel), then
this is really needed because in that case the hotplug toggling would have
to be done via CEC CDC commands. However, while this webpage claims that the
ARC is supported, I can't find any other information about that.

http://www.analog.com/en/audiovideo-products/analoghdmidvi-interfaces/adv7604/products/product.html

Lars-Peter, do you know anything about ARC support in the adv7604?

Regards,

	Hans
