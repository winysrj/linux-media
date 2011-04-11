Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37967 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1DKVr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 17:47:56 -0400
Received: by wwa36 with SMTP id 36so7172274wwa.1
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 14:47:54 -0700 (PDT)
References: <1300997220-4354-1-git-send-email-jarod@redhat.com> <20110324203108.GX2008@bicker> <20110324220523.GB28094@redhat.com>
In-Reply-To: <20110324220523.GB28094@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <6FD2AAEC-73BF-414A-BEF2-1C9C20A4F4BB@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Dan Carpenter <error27@gmail.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] tm6000: fix vbuf may be used uninitialized
Date: Mon, 11 Apr 2011 17:48:02 -0400
To: Jarod Wilson <jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 24, 2011, at 6:05 PM, Jarod Wilson wrote:

> On Thu, Mar 24, 2011 at 11:31:08PM +0300, Dan Carpenter wrote:
>> On Thu, Mar 24, 2011 at 04:07:00PM -0400, Jarod Wilson wrote:
>>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> 
>> Jarod, there is a lot of information missing from your change log...  :/
> 
> Hrm, I'm building the media stack with all warnings fatal, so this was
> just a quick fix to silence the compiler warning, didn't really look into
> it at all.
> 
>>> CC: devel@driverdev.osuosl.org
>>> ---
>>> drivers/staging/tm6000/tm6000-video.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>> 
>>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>>> index c80a316..bfebedd 100644
>>> --- a/drivers/staging/tm6000/tm6000-video.c
>>> +++ b/drivers/staging/tm6000/tm6000-video.c
>>> @@ -228,7 +228,7 @@ static int copy_streams(u8 *data, unsigned long len,
>>> 	unsigned long header = 0;
>>> 	int rc = 0;
>>> 	unsigned int cmd, cpysize, pktsize, size, field, block, line, pos = 0;
>>> -	struct tm6000_buffer *vbuf;
>>> +	struct tm6000_buffer *vbuf = NULL;
>>> 	char *voutp = NULL;
>>> 	unsigned int linewidth;
>>> 
>> 
>> This looks like a real bug versus just a GCC warning.  It was introduced
>> in 8aff8ba95155df "[media] tm6000: add radio support to the driver".
>> I've added Dmitri to the CC list.
> 
> Thanks much, will try to pay more attention next time. ;)

So I was just circling back around on this one, and took some time to read
the actual code and the radio support addition. After doing so, I don't
see why the patch I proposed wouldn't do. The buffer is only manipulated
if !dev->radio or if vbuf is non-NULL (the memcpy call). If its initialized
to NULL, it only gets used exactly as it did before 8aff8ba9 when
!dev->radio, and if its not been used or its NULL following manipulations
protected by !dev->radio, it doesn't get copied. What is the "real bug" I
am missing there? (Or did I already miss a patch posted to linux-media
addressing it?)

Thanks much,

-- 
Jarod Wilson
jarod@wilsonet.com



