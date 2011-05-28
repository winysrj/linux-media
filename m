Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1E1Olz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 10:41:55 -0400
Message-ID: <4DE109B0.80506@redhat.com>
Date: Sat, 28 May 2011 11:41:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DDBD504.5020109@redhat.com> <4DE0EE44.8060000@infradead.org> <201105281601.23130.remi@remlab.net>
In-Reply-To: <201105281601.23130.remi@remlab.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-05-2011 10:01, Rémi Denis-Courmont escreveu:
> Le samedi 28 mai 2011 15:44:52 Mauro Carvalho Chehab, vous avez écrit :
>>> int libv4l2_get_associated_devive(int fd, enum
>>> libv4l2_associated_device_types type, ...); Where fd is the fd of an
>>> open /dev/video node, and ... is a param through which the device gets
>>> returned (I guess a char * to a buffer of MAX_PATH length where the
>>> device name gets stored, this could
>>> be an also identifier like hw:0.0 or in case of vbi a /dev/vbi# path,
>>> etc.
>>
>> Using the fd will be more complex, as we'll loose the device node (is there
>> a glibc way to get the device path from the fd?). Well, we may associate
>> the fd descriptor with the device node internally at libv4l.
> 
> Not really. fstat() can tell you fd is a character device, and provide the 
> major and minor though.

Yeah, major/minor should be enough to associate it with the device info. The
library will need to read the uevent information also, to get the device major/minor,
but this should work properly.

I'll write a method for the library to allow using the file descriptor instead
of the file name.

Cheers,
Mauro.

