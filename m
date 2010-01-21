Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58042 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0AURqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 12:46:51 -0500
Received: by fxm20 with SMTP id 20so275070fxm.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 09:46:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264040489.3098.54.camel@palomino.walls.org>
References: <1a297b361001200424i24f9c1d2v2535aa18c80b3874@mail.gmail.com>
	 <1264040489.3098.54.camel@palomino.walls.org>
Date: Thu, 21 Jan 2010 21:46:50 +0400
Message-ID: <1a297b361001210946j1fa25dah5706be084a95de99@mail.gmail.com>
Subject: Re: SSH key parser
From: Manu Abraham <abraham.manu@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Thu, Jan 21, 2010 at 6:21 AM, Andy Walls <awalls@radix.net> wrote:
> On Wed, 2010-01-20 at 16:24 +0400, Manu Abraham wrote:
>> Hi all,
>>
>> I have been working with some T&M applications. Does anybody know of a
>> good SSH key parser that I need to use, for remote authentication in
>> such applications. Or does SSH sound like using a hammer against a fly
>> in such a circumstance ?
>
> Well, computer and communications security is more than just a good key
> parser.  It also involves protocols, procedures, audits, proper clocks,
> etc.  But I digress....
>
>
> I don't know what you mean by T&M, but maybe you might find dropbear SSH
> useful:


I meant Test & Measurement for some debugging applications, which
eventually would be Open Source and public. I was looking on the
security/authentication aspects of a remote applications and hence
SSH. Maybe it might be too big a hammer, but well, without trying, i
guess who knows ...


> http://matt.ucc.asn.au/dropbear/dropbear.html
>
> I make no claims as to the secuirty "goodness" of Dropbear SSH; I only
> know that it exists.
>
> Be aware that getting enough entropy in the entropy pool to generate
> good host keys on an embedded platform with no mouse or keyboard can be
> a problem.  But you only have to do that once really, if you never
> rotate keys.
>
> And watch out for those Australian drop-bears, I hear they are deadly.
>
> Regards,
> Andy


Thanks. I appreciate your feedback very much. I will try it out soon.


Thanks,
Manu
