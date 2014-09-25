Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37756 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaIYTDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 15:03:32 -0400
Message-ID: <54246702.6000907@osg.samsung.com>
Date: Thu, 25 Sep 2014 13:03:30 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com> <20140925160134.GA6207@linuxtv.org> <5424539D.8090503@osg.samsung.com> <20140925181747.GA21522@linuxtv.org> <542462C4.7020907@osg.samsung.com>
In-Reply-To: <542462C4.7020907@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes and Mauro,

On 09/25/2014 12:45 PM, Shuah Khan wrote:

>>
> 
> Revert is good. Just checked 3.16 and we are good
> on that. It needs to be reverted from 3.17 for sure.

Mauro! Do you need anything from me for this revert?
Please let me know. Gotta be done soon I am guessing
with us so close to 3.17 release.

> 
> ok now I know why the second path didn't
> apply. It depends on another change that added resume
> function
> 
> 7ab1c07614b984778a808dc22f84b682fedefea1
> 
> You don't need the second patch. The first patch applied
> to 3.17 and fails on 3.16
> 
> http://patchwork.linuxtv.org/patch/26073/
> 
> I am working on 3.16 back-port for the first one to 3.16
> and send one shortly for you to test.
> 

The first patch depends the work done in 3.17, I don't
see it meeting the stable rules to go into 3.16.

Johannes! Do you need the request_firmware patch for
3.16?? Are you seeing problems there. 3.16 doesn't
have b89193e0b06f

thanks,
--- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
