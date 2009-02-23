Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.icp-qv1-irony-out3.iinet.net.au ([203.59.1.149]:58818
	"EHLO webmail.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbZBWBYv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 20:24:51 -0500
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	hermann pitton <hermann-pitton@arcor.de>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Reply-To: sonofzev@iinet.net.au
Date: Mon, 23 Feb 2009 10:24:29 +0900
Cc: linux-media@vger.kernel.org
Message-Id: <36300.1235352269@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Yes... 


On Mon Feb 23 12:13 , hermann pitton  sent:

>
>Am Sonntag, den 22.02.2009, 11:15 +0100 schrieb Hans Verkuil:
>> Hi all,
>> 
>> There are lot's of discussions, but it can be hard sometimes to actually 
>> determine someone's opinion.
>> 
>> So here is a quick poll, please reply either to the list or directly to me 
>> with your yes/no answer and (optional but welcome) a short explanation to 
>> your standpoint. It doesn't matter if you are a user or developer, I'd like 
>> to see your opinion regardless.
>> 
>> Please DO NOT reply to the replies, I'll summarize the results in a week's 
>> time and then we can discuss it further.
>> 
>> Should we drop support for kernels 
>> 
>> _: Yes
>> _: No
>
>Yes.
>
>> Optional question:
>> 
>> Why:
>
>Keeping too old kernels supported makes others lazy and in worst case
>they ask you to support v4l2 version one. (happened)
>
>Our user base for new devices is covered with down to 2.6.22 for now, we
>likely never got anything from those on old commercial distribution
>kernels, same for Debian and stuff derived from there.
>
>Since new drivers actually prefer to avoid the compat work and are happy
>to make it just into the latest rc1 during the merge window and further
>from there, there is no loss either.
>
>Some new devices we likely get on already established drivers should not
>be hard to add to a v4l-dvb tar ball we leave with support for the even
>older kernels.
>
>Cheers,
>Hermann
> 
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>)


