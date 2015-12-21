Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59778 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbbLUOhp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 09:37:45 -0500
Subject: Re: [PATCH 2/2] [media] media-device: split media initialization and
 registration
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
 <1441890195-11650-3-git-send-email-javier@osg.samsung.com>
 <55F1BA5C.50508@linux.intel.com> <20151215091342.2f825d91@recife.lan>
Cc: linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56780EAE.7090909@osg.samsung.com>
Date: Mon, 21 Dec 2015 11:37:34 -0300
MIME-Version: 1.0
In-Reply-To: <20151215091342.2f825d91@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/15/2015 08:13 AM, Mauro Carvalho Chehab wrote:

[snip]

>>>  
>>>  /**
>>> - * media_device_register - register a media device
>>> + * media_device_init() - initialize a media device
>>>   * @mdev:	The media device
>>>   *
>>>   * The caller is responsible for initializing the media device before
>>> @@ -534,12 +534,11 @@ static void media_device_release(struct media_devnode *mdev)
>>>   *
>>>   * - dev must point to the parent device
>>>   * - model must be filled with the device model name
>>> + *
>>> + * returns zero on success or a negative error code.
>>>   */
>>> -int __must_check __media_device_register(struct media_device *mdev,
>>> -					 struct module *owner)
>>> +int __must_check media_device_init(struct media_device *mdev)
>>
>> I think I suggested making media_device_init() return void as the only
>> remaining source of errors would be driver bugs.
>>
>> I'd simply replace the WARN_ON() below with BUG().
> 
> That sounds like bad idea to me, and it is against the current
> Kernel policy of using BUG() only when there's no other way, e. g. on
> event so severe that the Kernel has no other thing to do except to
> stop running.
>

I agree with you, that was exactly my point and what I told Sakari [0] but
he had a strong opinion about it and I didn't mind too much so I decided at
the end to just change it to a BUG_ON() so I could get his ack for this set.
 
> For sure, this is not the case here. Also, all drivers have already
> a logic that checks if the device init happened. So, they should already
> be doing the right thing.
>
> Regards,
> Mauro

[0]: https://lkml.org/lkml/2015/9/10/483

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
