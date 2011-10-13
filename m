Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1JMDOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 23:14:52 -0400
Received: by bkbzt4 with SMTP id zt4so842904bkb.19
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 20:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E95FBC9.3060309@lockie.ca>
References: <4E95F8D3.4070104@lockie.ca>
	<4E95FBC9.3060309@lockie.ca>
Date: Wed, 12 Oct 2011 23:14:51 -0400
Message-ID: <CAGoCfiy5=te3sgEs9UhANEQbMVDkJ28ordoJAmYtPqkz5A1JkA@mail.gmail.com>
Subject: Re: where is the cx23887 module in kernel-3.04 config?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 4:42 PM, James <bjlockie@lockie.ca> wrote:
> On 10/12/11 16:30, James wrote:
>>
>> Where is the cx23887 module in the kernel-3.04 config?
>> I'm trying to get a Hauppauge WinTV-HVR-1250 working.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Found it under video4lnux driver and not DVB/ATSC adapters (which seems more
> logical).

In general, everything that is a hybrid card is under media/video.
That's just a product of the way the two trees evolved (v4l vs.
dvb)...

Steven actually has a tree which I believe has support for pretty much
every 1250 variant.  It's not merged upstream though, so you will
likely have to do some tweaking of the code to make it work with
current kernels.

http://kernellabs.com/hg/~stoth/cx23888-encoder/

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
