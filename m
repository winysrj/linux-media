Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab2EWIOT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 04:14:19 -0400
Message-ID: <4FBC9C58.6070907@redhat.com>
Date: Wed, 23 May 2012 10:14:16 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Paulo Assis <pj.assis@gmail.com>,
	=?ISO-8859-1?Q?Llu=EDs_Batlle_i?= =?ISO-8859-1?Q?_Rossell?=
	<viric@viric.name>, linux-media@vger.kernel.org
Subject: Re: Problems with the gspca_ov519 driver
References: <20120522110018.GX1927@vicerveza.homeunix.net> <CAPueXH6uN4UQO_WL_pc9wBoZV=v_7AVtQKcruKY=BCMeJOw-2Q@mail.gmail.com> <4FBBA515.7010006@redhat.com> <20120522230214.700ec32864670a7813260577@studenti.unina.it>
In-Reply-To: <20120522230214.700ec32864670a7813260577@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/22/2012 11:02 PM, Antonio Ospite wrote:

<snip>
> I feel I can add a:
>
> Tested-by: Antonio Ospite<ospite@studenti.unina.it>

Thanks added to the commit message.

> I can backport the change to older kernels and even CC linux-stable if
> you think it is appropriate, that's the least I can do to expiate for
> knowing about a bug/regression and not hunting its cause hard enough.

Hehe, I've CC-ed stable@kernel.org on the patch, it should apply cleanly
to older versions, so no backporting is needed.

> HdG maybe you could mention f7059ea in the commit message of this fix
> if you can confirm the problem was introduced there.

I can confirm that the problem was introduced there and I've added a
reference to that commmit to the commit message thanks for looking
that commit up!

Regards,

Hans
