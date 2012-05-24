Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44841 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab2EXOq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 10:46:56 -0400
Message-ID: <4FBE49DC.8090109@iki.fi>
Date: Thu, 24 May 2012 17:46:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
References: <4FB7E489.10803@redhat.com> <4FB7E827.7070701@iki.fi> <201205221926.38970.remi@remlab.net>
In-Reply-To: <201205221926.38970.remi@remlab.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.05.2012 19:26, Rémi Denis-Courmont wrote:
> Le samedi 19 mai 2012 21:36:23 Antti Palosaari, vous avez écrit :
>> On 19.05.2012 21:20, Hans de Goede wrote:
>>> Currently the V4L2 API does not allow for radio devices with more then 1
>>> tuner,
>>> which is a bit of a historical oversight, since many radio devices have 2
>>> tuners/demodulators 1 for FM and one for AM. Trying to model this as 1
>>> tuner
>>> really does not work well, as they have 2 completely separate frequency
>>> bands
>>> they handle, as well as different properties (the FM part usually is
>>> stereo capable, the AM part is not).
>>>
>>> It is important to realize here that usually the AM/FM tuners are part
>>> of 1 chip, and often have only 1 frequency register which is used in
>>> both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
>>> and from a V4L2 API pov these modes are best modeled as 2 tuners.
>>> This is at least true for the radio-cadet card and the tea575x,
>>> which are the only 2 AM capable radio devices we currently know about.
>>
>> For DVB API we changed just opposite direction - from multi-frontend to
>> single-frontend. I think one device per one standard is good choice.
>
> If I understand Hans correctly, he suggests to use two tuners on a *single*
> radio device node, much like a single video device nodes can have multiple
> video inputs. So I think you agree with Hans, and so do I.

OK, then I was misunderstanding it. Unfortunately I have no enough V4L2 
API experience to comment that :i

regards
Antti
-- 
http://palosaari.fi/
