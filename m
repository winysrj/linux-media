Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47672 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2CFQKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:10:48 -0500
Message-ID: <4F563704.50608@lwfinger.net>
Date: Tue, 06 Mar 2012 10:10:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: awalls@md.metrocast.net, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ivtv: Fix build warning
References: <4f53b393.cBPkBHEECVOO9Jzx%Larry.Finger@lwfinger.net> <4F561124.30800@bisect.de>
In-Reply-To: <4F561124.30800@bisect.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2012 07:29 AM, Danny Kukawka wrote:
> Am 04.03.2012 19:25, schrieb Larry Finger:
>> In driver ivtv, there is a mismatch between the type of the radio module parameter
>> and the storage variable, which leads to the following warning:
>>
>>    CC [M]  drivers/media/video/ivtv/ivtv-driver.o
>> drivers/media/video/ivtv/ivtv-driver.c: In function ‘__check_radio’:
>> drivers/media/video/ivtv/ivtv-driver.c:142: warning: return from incompatible pointer type
>> drivers/media/video/ivtv/ivtv-driver.c: At top level:
>> drivers/media/video/ivtv/ivtv-driver.c:142: warning: initialization from incompatible pointer type
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>
> See my already twice send patches:
> http://thread.gmane.org/gmane.linux.kernel/1246476

Thanks for the link, and the information that the warning is being fixed.

Larry

