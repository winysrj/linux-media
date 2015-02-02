Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-232.synserver.de ([212.40.185.232]:1063 "EHLO
	smtp-out-232.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266AbbBBNtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 08:49:12 -0500
Message-ID: <54CF8057.1060806@metafoo.de>
Date: Mon, 02 Feb 2015 14:49:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?windows-1252?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/15] [media] adv7180: Use inline function instead
 of macro
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>	<1422028354-31891-4-git-send-email-lars@metafoo.de> <20150202113613.07673af0@recife.lan>
In-Reply-To: <20150202113613.07673af0@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2015 02:36 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 23 Jan 2015 16:52:22 +0100
> Lars-Peter Clausen <lars@metafoo.de> escreveu:
>
>> Use a inline function instead of a macro for the container_of helper for
>> getting the driver's state struct from a control. A inline function has the
>> advantage that it is more typesafe and nicer in general.
>
> I don't see any advantage on this.
>
> See: container_of is already a macro, and it is written in a way that, if
> you use it with inconsistent values, the compilation will break.

Yes, container_of is a macro, because it needs to be a macro. Compilation 
will also not always break if you pass in a incorrect type, it might succeed 
with even generating a warning. Furthermore if compilation breaks the error 
message is completely incomprehensible. Using a function instead makes sure 
that the error message you get is in the style of "passing argument of wrong 
type to function, expected typeX, got typeY".

>
> Also, there's the risk that, for whatever reason, gcc to decide to not
> inline this.

If the compiler does not inline this it probably has a good reason to do so. 
Not inlining this will not break the functionality, so it is not a problem.

- Lars
