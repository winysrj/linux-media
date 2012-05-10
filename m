Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2EJOUq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 10:20:46 -0400
Message-ID: <4FABCEBA.7080609@redhat.com>
Date: Thu, 10 May 2012 16:20:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Atsuo Kuwahara <kuwahara@ti.com>
Subject: Re: Advice on extending libv4l for media controller support
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com> <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com>
In-Reply-To: <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I somehow missed the original mail. This is in essence the same problem
as with the omap3 and Laurent and Sakari and I did a design for that
in Brussels in the last quarter of 2011, Laurent and Sakari would work
on fleshing that out, so it is probably best to talk to them about this.

Regards,

Hans


On 05/10/2012 03:54 PM, Sergio Aguirre wrote:
> +Atsuo
>
> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
> <sergio.a.aguirre@gmail.com>  wrote:
>> Hi Hans,
>>
>> I'm interested in using libv4l along with my omap4 camera project to
>> adapt it more easily
>> to Android CameraHAL, and other applications, to reduce complexity of
>> them mostly...
>>
>> So, but the difference is that, this is a media controller device I'm
>> trying to add support for,
>> in which I want to create some sort of plugin with specific media
>> controller configurations,
>> to avoid userspace to worry about component names and specific
>> usecases (use sensor resizer, or SoC ISP resizer, etc.).
>>
>> So, I just wanted to know your advice on some things before I start
>> hacking your library:
>>
>> 1. Should it be the right thing to add a new subfolder under "lib/",
>> named like "libomap4iss-mediactl" or something like that ?
>> 2. Do you know if anyone is working on something similar for any other
>> Media Controller device ?
>>
>> Thanks in advance for your inputs.
>>
>> Regards,
>> Sergio
