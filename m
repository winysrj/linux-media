Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3F0WcB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 18:32:01 -0400
Message-ID: <51CCBD5D.4000007@redhat.com>
Date: Fri, 28 Jun 2013 00:31:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] v4l-utils: Fix crashes found by Mayhem
References: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for working on this, both patches look good, ack series.

Regards,

Hans


On 06/27/2013 11:11 PM, Gregor Jasny wrote:
> The Mayhem Team ran their code checker over the Debian archive and
> also found two crashes in v4l-utils.
>
> See http://lists.debian.org/debian-devel/2013/06/msg00720.html
>
> Gregor Jasny (2):
>    libv4lconvert: Prevent integer overflow by checking width and height
>    keytable: Always check if strtok return value is null
>
>   lib/libv4lconvert/ov511-decomp.c |  7 ++++++-
>   lib/libv4lconvert/ov518-decomp.c |  7 ++++++-
>   utils/keytable/keytable.c        | 19 ++++++++++++++++---
>   3 files changed, 28 insertions(+), 5 deletions(-)
>
