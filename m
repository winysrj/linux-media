Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:47570 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZEWL5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 07:57:01 -0400
Received: by bwz22 with SMTP id 22so2112836bwz.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 04:57:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905231301.53827.jarhuba2@poczta.onet.pl>
References: <200905230810.39344.jarhuba2@poczta.onet.pl>
	 <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
	 <200905231301.53827.jarhuba2@poczta.onet.pl>
Date: Sat, 23 May 2009 15:57:01 +0400
Message-ID: <1a297b360905230457u7aee8795k4e5b59bd5a49f90b@mail.gmail.com>
Subject: Re: Question about driver for Mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: jarhuba2@poczta.onet.pl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/5/23 Jaros³aw Huba <jarhuba2@poczta.onet.pl>:
>> The latest development snapshot for the mantis based devices can be found
>> here: http://jusst.de/hg/mantis-v4l
>>
>> Currently CI is unsupported, though very preliminary code support for
>> it exists in it.
>> S2 works, pretty much. Or do you have other results ?
>>
>> Regards,
>> Manu
>
> I will test it soon. Do I need to compile my own pathed kernel? Or Is there
> some info on wiki about how to do that in easier way?
> I'm using Kubuntu Karmic with kernel 2.6.30.


Just clone the tree on to your machine
hg clone http://jusst.de/hg/mantis-v4l

Clean stal remnants if any.
make distclean

Build the tree
make

Load the modules

one by one,
or have a script of your own to load it,
or you can do a make install


In case you are sending me debug output, please do load the
mantis.ko and stb0899.ko modules with the verbose=5
module parameter, so that the debug messages are verbosed out.

Otherwise you can forget about the module parameters.

Regards,
Manu
