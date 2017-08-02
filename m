Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:40071 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751142AbdHBILJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:11:09 -0400
Message-ID: <1501661466.31625.3.camel@perches.com>
Subject: Re: [PATCH] media: staging: atomisp: sh_css_calloc shall return a
 pointer to the allocated space
From: Joe Perches <joe@perches.com>
To: "Sergei A. Trusov" <sergei.a.trusov@ya.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@llwyncelyn.cymru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        simran singhal <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Wed, 02 Aug 2017 01:11:06 -0700
In-Reply-To: <1859135.Zd3QESt5CR@z12>
References: <1859135.Zd3QESt5CR@z12>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-08-02 at 18:00 +1000, Sergei A. Trusov wrote:
> The calloc function returns either a null pointer or a pointer to the
> allocated space. Add the second case that is missed.

gads.

Bug added by commit da22013f7df4 ("atomisp: remove indirection from
sh_css_malloc")

These wrappers should really be deleted.
