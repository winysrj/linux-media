Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61982 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2ARM4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:56:14 -0500
Received: by werb13 with SMTP id b13so325352wer.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 04:56:12 -0800 (PST)
Message-ID: <4F16C16A.7000208@googlemail.com>
Date: Wed, 18 Jan 2012 13:56:10 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <2648c3dfc9ea2bd3bae776200d7e056e@chewa.net> <201201181344.09700.pboettcher@kernellabs.com>
In-Reply-To: <201201181344.09700.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/18/12 1:44 PM, Patrick Boettcher wrote:
> I missed the first message of this thread, that's why I hijacked it here
> and it is short:
>
> I love cmake and can't understand why people are not preferring it over
> autotools for user-space applications and conditional+configurable
> builds.
>
> I hope my mail is not too off-topic.

My first attempt to add a sane buildsystem used cmake, too:
https://github.com/gjasny/v4l-utils-cmake

But Hans (de Goede) preferred something more 'standard'. So I learned 
autofoo. And I must admit it really got better during the years.

And packaging is also easy:
http://bazaar.launchpad.net/~libv4l/+junk/packaging/view/head:/rules

Thanks,
Gregor
