Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbbBSPGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 10:06:23 -0500
Message-ID: <54E5FBEA.1000005@suse.cz>
Date: Thu, 19 Feb 2015 16:06:18 +0100
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
References: <6116702.rrbrOqQ26P@wuerfel> <20150219121107.GA19684@sepie.suse.cz> <14254005.QkaJhTuY5H@wuerfel>
In-Reply-To: <14254005.QkaJhTuY5H@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 19.2.2015 v 15:53 Arnd Bergmann napsal(a):
> On Thursday 19 February 2015 13:11:07 Michal Marek wrote:
>> On 2015-02-18 18:12, Arnd Bergmann wrote:
>>> In the media drivers, the v4l2 core knows about all submodules
>>> and calls into them from a common function. However this cannot
>>> work if the modules that get called are loadable and the
>>> core is built-in. In that case we get
>>>
>>> drivers/built-in.o: In function `set_type':
>>> drivers/media/v4l2-core/tuner-core.c:301: undefined reference to `tea5767_attach'
>>> drivers/media/v4l2-core/tuner-core.c:307: undefined reference to `tea5761_attach'
>>> drivers/media/v4l2-core/tuner-core.c:349: undefined reference to `tda9887_attach'
>>> drivers/media/v4l2-core/tuner-core.c:405: undefined reference to `xc4000_attach'
>>> [...]
>>> Ideally Kconfig would be used to avoid the case of a broken dependency,
>>> or the code restructured in a way to turn around the dependency, but either
>>> way would require much larger changes here.
>>
>> What can be done without extending kbuild is to accept
>> CONFIG_VIDEO_TUNER=y and CONFIG_MEDIA_TUNER_FOO=m, but build both into
>> the kernel, e.g.
> 
> Right, but
> 
>> diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
>> index 42e5a01..d2c7e89 100644
>> --- a/drivers/media/tuners/Kconfig
>> +++ b/drivers/media/tuners/Kconfig
>> @@ -71,6 +71,11 @@ config MEDIA_TUNER_TEA5767
>>         help
>>           Say Y here to include support for the Philips TEA5767 radio tuner.
>>  
>> +config MEDIA_TUNER_TEA5767_BUILD
>> +       tristate
>> +       default VIDEO_TUNER || MEDIA_TUNER_TEA5767
>> +       depends on MEDIA_TUNER_TEA5767!=n
>> +
>>  config MEDIA_TUNER_MSI001
>>         tristate "Mirics MSi001"
>>         depends on MEDIA_SUPPORT && SPI && VIDEO_V4L2
> 
> We'd then have to do the same for each tuner driver that we have in the
> kernel or that gets added later.

Yes :-(.


>> Actually, I have hard time coming up with a kconfig syntactic sugar to
>> express such dependency. If I understand it correctly, the valid
>> configurations in this case are
>>
>> MEDIA_TUNER_TEA5767     n       m       y
>> VIDEO_TUNER     n       x       x       x
>>                 m       x       x       x
>>                 y       x               x
>>
>> I.e. only VIDEO_TUNER=y and MEDIA_TUNER_TEA5767=m is incorrect, isn't
>> it?
> 
> Yes, I think that is correct.

OK. In this case, a kconfig extension would be really too specific: "if
set, set to at least X but only if X is set as well."


> We have similar problems in other areas
> of the kernel. In theory, we could enforce the VIDEO_TUNER driver to
> be modular here by adding lots of dependencies to it:
> 
> config VIDEO_TUNER
> 	tristate
> 	depends on MEDIA_TUNER_TEA5761 || !MEDIA_TUNER_TEA5761
> 	depends on MEDIA_TUNER_TEA5767 || !MEDIA_TUNER_TEA5767
> 	depends on MEDIA_TUNER_MSI001  || !MEDIA_TUNER_MSI001

Nah, that's even uglier. I suggest to merge your IS_REACHABLE patch.

Michal
